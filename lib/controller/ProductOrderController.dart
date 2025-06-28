
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../dataModel/DeliverySlot.dart';
import '../dataModel/ProductDetails.dart';
import '../dataModel/ProductReviews.dart';

class ProductOrderController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var isReviewsLoading = false.obs;
  var productDetails = Rxn<ProductDetails>();
  var productReviews = Rxn<ProductReviews>();
  var selectedWeight = Rxn<Weight>();
  var selectedQuantity = 1.obs;
  var currentImageIndex = 0.obs;
  var selectedAboutSection = 0.obs; // 0: Description, 1: Delivery, 2: Care
  final RxSet<String> expandedSections = <String>{}.obs;
  final selectedDeliveryDate = Rxn<DateTime>();
  final selectedDeliverySlot = Rxn<DeliverySlot>();
  final selectedTimeSlot = Rxn<TimeSlot>();
  final deliverySlots = <DeliverySlot>[].obs;
  final isCourier = false.obs;
  final freeDelivery = false.obs;
  final String productId;
  final String id;

  // Add timeout and retry logic
  static const Duration _timeout = Duration(seconds: 10);
  static const int _maxRetries = 3;

  ProductOrderController({required this.productId, required this.id});

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    initializeDeliverySlots();
  }

  // Initialize data with parallel loading
  Future<void> _initializeData() async {
    // Load both APIs in parallel for better performance
    await Future.wait([
      fetchProductDetails(),
      fetchProductReviews(),
    ]);
  }

  // Improved fetch product details with retry logic
  Future<void> fetchProductDetails() async {
    int retryCount = 0;

    while (retryCount < _maxRetries) {
      try {
        isLoading.value = true;

        final response = await http.get(
          Uri.parse('https://kingsbakerbackend-production.up.railway.app/api/product/getProduct?productId=$productId'),
          headers: {
            'Content-Type': 'application/json',
            'Connection': 'keep-alive',
          },
        ).timeout(_timeout);

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          productDetails.value = ProductDetails.fromJson(jsonData);
          print("---------- ${jsonData}");
          // Set default weight selection
          if (productDetails.value?.data?.weight?.isNotEmpty == true) {
            selectedWeight.value = productDetails.value!.data!.weight!.first;
          }

          isLoading.value = false;
          return; // Success, exit retry loop
        } else {
          throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
        }
      } on TimeoutException {
        retryCount++;
        if (retryCount >= _maxRetries) {
          isLoading.value = false;
          Get.snackbar(
            'Connection Timeout',
            'Failed to load product details. Please check your internet connection.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          return;
        }
        // Wait before retrying
        await Future.delayed(Duration(seconds: retryCount));
      } catch (e) {
        retryCount++;
        if (retryCount >= _maxRetries) {
          isLoading.value = false;
          Get.snackbar(
            'Error',
            'Failed to fetch product details: ${e.toString()}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          print(e.toString());
          return;
        }
        await Future.delayed(Duration(seconds: retryCount));
      }
    }
  }

  // Improved fetch product reviews with retry logic
  Future<void> fetchProductReviews() async {
    int retryCount = 0;

    while (retryCount < _maxRetries) {
      try {
        isReviewsLoading.value = true;

        final response = await http.get(
          Uri.parse('https://kingsbakerbackend-production.up.railway.app/api/reviews/getReviews?product_id=$id'),
          headers: {
            'Content-Type': 'application/json',
            'Connection': 'keep-alive',
          },
        ).timeout(_timeout);

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          productReviews.value = ProductReviews.fromJson(jsonData);
          isReviewsLoading.value = false;
          return;
        } else {
          throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
        }
      } on TimeoutException {
        retryCount++;
        if (retryCount >= _maxRetries) {
          isReviewsLoading.value = false;
          return; // Fail silently for reviews as they're not critical
        }
        await Future.delayed(Duration(seconds: retryCount));
      } catch (e) {
        retryCount++;
        if (retryCount >= _maxRetries) {
          isReviewsLoading.value = false;
          return;
        }
        await Future.delayed(Duration(seconds: retryCount));
      }
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await _initializeData();
  }

  // Select weight variant
  void selectWeight(Weight weight) {
    selectedWeight.value = weight;
    currentImageIndex.value = 0; // Reset image index when weight changes
  }

  // Update quantity
  void updateQuantity(int qty) {
    if (qty > 0) {
      selectedQuantity.value = qty;
    }
  }

  // Get current price
  int getCurrentPrice() {
    return selectedWeight.value?.price ?? productDetails.value?.data?.prices ?? 0;
  }

  // Get discount price
  int getDiscountPrice() {
    return selectedWeight.value?.discountPrice ?? productDetails.value?.data?.discountPrice ?? 0;
  }

  // Calculate discount percentage
  int getDiscountPercentage() {
    final price = getCurrentPrice();
    final discountPrice = getDiscountPrice();
    if (price > 0 && discountPrice > 0 && discountPrice < price) {
      return ((price - discountPrice) / price * 100).round();
    }
    return 0;
  }

  // Change image
  void changeImage(int index) {
    currentImageIndex.value = index;
  }

  // Get current image list
  List<String> getCurrentImages() {
    if (selectedWeight.value?.images?.isNotEmpty == true) {
      return selectedWeight.value!.images!;
    }
    return productDetails.value?.data?.imageLink ?? [];
  }

  // Select about section
  void selectAboutSection(int index) {
    selectedAboutSection.value = index;
  }

  void toggleSection(String sectionTitle) {
    if (expandedSections.contains(sectionTitle)) {
      expandedSections.remove(sectionTitle);
    } else {
      expandedSections.add(sectionTitle);
    }
  }

// Optional: Method to expand all sections
  void expandAllSections() {
    if (productDetails.value?.data?.details != null) {
      final allSections = productDetails.value!.data!.details!
          .map((detail) => detail.key!)
          .toSet();
      expandedSections.addAll(allSections);
    }
  }

  // Add this method to initialize delivery slots
  void initializeDeliverySlots() {
    deliverySlots.value = [
      DeliverySlot(
        id: "fixed",
        title: "Fixed Time Delivery",
        price: 99,
        description: "Choose from any 1-hour slot",
        expressSlots: [
          TimeSlot(id: 1, time: "10:00 AM - 11:00 AM"),
          TimeSlot(id: 2, time: "11:00 AM - 12:00 PM"),
          TimeSlot(id: 3, time: "12:00 PM - 1:00 PM"),
          TimeSlot(id: 4, time: "1:00 PM - 2:00 PM"),
          TimeSlot(id: 5, time: "2:00 PM - 3:00 PM"),
          TimeSlot(id: 6, time: "3:00 PM - 4:00 PM"),
          TimeSlot(id: 7, time: "4:00 PM - 5:00 PM"),
          TimeSlot(id: 8, time: "5:00 PM - 6:00 PM"),
          TimeSlot(id: 9, time: "6:00 PM - 7:00 PM"),
          TimeSlot(id: 10, time: "7:00 PM - 8:00 PM"),
          TimeSlot(id: 11, time: "8:00 PM - 9:00 PM"),
        ],
      ),
      DeliverySlot(
        id: "standard",
        title: "Standard Delivery",
        price: 19,
        description: "Choose between 1st half or 2nd half of the day",
        expressSlots: [
          TimeSlot(id: 1, time: "9:00 AM - 2:00 PM"),
          TimeSlot(id: 2, time: "12:00 PM - 5:00 PM"),
          TimeSlot(id: 3, time: "4:00 PM - 9:00 PM"),
          TimeSlot(id: 4, time: "5:00 PM - 12:00 AM"),
        ],
      ),
      DeliverySlot(
        id: "express",
        title: "Express Delivery",
        price: 49,
        description: "Choose from any slot during the day",
        expressSlots: [
          TimeSlot(id: 1, time: "09:00 AM - 01:00 PM"),
          TimeSlot(id: 2, time: "01:00 PM - 05:00 PM"),
          TimeSlot(id: 3, time: "05:00 PM - 09:00 PM"),
          TimeSlot(id: 4, time: "07:00 PM - 11:00 PM"),
        ],
      ),
      DeliverySlot(
        id: "midnight",
        title: "Midnight Delivery",
        price: 249,
        description: "Gift will be delivered any time between 11:00 PM-11:59 PM",
        expressSlots: [TimeSlot(id: 1, time: "11:00 PM - 11:59 PM")],
      ),
      DeliverySlot(
        id: "courier",
        title: "Courier Delivery",
        price: 60,
        description: "",
        expressSlots: [TimeSlot(id: 1, time: "09:00 AM - 9:00 PM")],
      ),
      DeliverySlot(
        id: "freeDelivery",
        title: "Free Delivery",
        price: 0,
        description: "Choose for free in your given timeslot.",
        expressSlots: [
          TimeSlot(id: 1, time: "9:00 AM - 2:00 PM"),
          TimeSlot(id: 2, time: "12:00 PM - 5:00 PM"),
          TimeSlot(id: 3, time: "4:00 PM - 9:00 PM"),
          TimeSlot(id: 4, time: "5:00 PM - 12:00 AM"),
        ],
      ),
    ];
  }

// Add these methods to your ProductOrderController
  List<TimeSlot> getAvailableTimeSlots() {
    // Add debug prints
    print("=== DEBUG: getAvailableTimeSlots ===");
    print("selectedDeliverySlot: ${selectedDeliverySlot.value?.title}");
    print("selectedDeliveryDate: ${selectedDeliveryDate.value}");

    if (selectedDeliverySlot.value == null || selectedDeliveryDate.value == null) {
      print("Null values found, returning empty list");
      return [];
    }

    final selectedSlot = selectedDeliverySlot.value!;
    final selectedDate = selectedDeliveryDate.value!;
    final now = DateTime.now();

    // Check if selected date is today
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    print("Is today: $isToday");
    print("Available slots in selected delivery slot: ${selectedSlot.expressSlots.length}");

    // If not today, return all available slots
    if (!isToday) {
      print("Not today, returning all slots: ${selectedSlot.expressSlots.length}");
      return selectedSlot.expressSlots;
    }

    // For today, filter slots that are at least 2 hours from now
    final twoHoursLater = now.add(Duration(hours: 2));
    print("Current time: $now");
    print("Two hours later: $twoHoursLater");

    final availableSlots = selectedSlot.expressSlots.where((slot) {
      try {
        // Parse the time string (e.g., "10:00 AM - 11:00 AM")
        final timeRange = slot.time.split(' - ');
        if (timeRange.isEmpty) return false;

        final startTimeString = timeRange[0].trim();
        print("Parsing time: $startTimeString");

        // Handle different time formats
        final timePattern = RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)', caseSensitive: false);
        final match = timePattern.firstMatch(startTimeString);

        if (match == null) {
          print("Could not parse time: $startTimeString");
          return false;
        }

        int hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);
        final period = match.group(3)!.toUpperCase();

        // Convert to 24-hour format
        if (period == 'PM' && hour != 12) {
          hour += 12;
        } else if (period == 'AM' && hour == 12) {
          hour = 0;
        }

        final slotDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            hour,
            minute
        );

        print("Slot time: $slotDateTime, Two hours later: $twoHoursLater");
        final isAvailable = slotDateTime.isAfter(twoHoursLater);
        print("Is available: $isAvailable");

        return isAvailable;
      } catch (e) {
        print("Error parsing time slot: ${slot.time}, Error: $e");
        return false;
      }
    }).toList();

    print("Filtered available slots: ${availableSlots.length}");
    return availableSlots;
  }

// Also add this improved method for getting delivery slots
  List<DeliverySlot> getAvailableDeliverySlots() {
    print("=== DEBUG: getAvailableDeliverySlots ===");
    print("freeDelivery: ${freeDelivery.value}");
    print("isCourier: ${isCourier.value}");
    print("Total delivery slots: ${deliverySlots.length}");

    List<DeliverySlot> availableSlots = [];

    // Check for free delivery first
    if (freeDelivery.value) {
      final freeSlot = deliverySlots.firstWhereOrNull((slot) => slot.id == "freeDelivery");
      if (freeSlot != null) {
        availableSlots.add(freeSlot);
        print("Added free delivery slot");
      }
    }

    // Check for courier delivery
    if (isCourier.value) {
      final courierSlot = deliverySlots.firstWhereOrNull((slot) => slot.id == "courier");
      if (courierSlot != null) {
        availableSlots.add(courierSlot);
        print("Added courier delivery slot");
      }
    }

    // If no special delivery types, show all standard options
    if (availableSlots.isEmpty) {
      availableSlots = deliverySlots.where((slot) =>
      slot.id != "courier" && slot.id != "freeDelivery").toList();
      print("Added standard delivery slots: ${availableSlots.length}");
    }

    // Debug: Print all available slots
    for (var slot in availableSlots) {
      print("Available slot: ${slot.title} (${slot.expressSlots.length} time slots)");
    }

    return availableSlots;
  }

  void selectDeliveryDate(DateTime date) {
    selectedDeliveryDate.value = date;
    selectedDeliverySlot.value = null;
    selectedTimeSlot.value = null;
  }

  void selectDeliverySlot(DeliverySlot slot) {
    selectedDeliverySlot.value = slot;
    selectedTimeSlot.value = null;
  }

  void selectTimeSlot(TimeSlot slot) {
    selectedTimeSlot.value = slot;
  }

// Optional: Method to collapse all sections
  void collapseAllSections() {
    expandedSections.clear();
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}