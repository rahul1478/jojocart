

// 2. Location Controller using GetX
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../dataModel/LocationModel.dart';

class LocationController extends GetxController {
  static LocationController get instance => Get.find();

  final GetStorage _storage = GetStorage();
  static const String _locationKey = 'selected_location';
  static const String _locationHistoryKey = 'location_history';

  // Your Google Places API Key
  final String _apiKey = 'AIzaSyBbLKjsBo2m22EJXFrkJDbSSj8u58t0Hfk';

  // Observable variables
  final Rx<LocationModel?> selectedLocation = Rx<LocationModel?>(null);
  final RxList<LocationModel> locationSuggestions = <LocationModel>[].obs;
  final RxList<LocationModel> locationHistory = <LocationModel>[].obs;
  final RxBool isLoading = false.obs;

  // Add this observable to track initialization
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  // Initialize controller with proper async handling
  Future<void> _initializeController() async {
    await _loadSavedLocation();
    await _loadLocationHistory();
    isInitialized.value = true;
  }

  // Load saved location from storage
  Future<void> _loadSavedLocation() async {
    try {
      final locationData = _storage.read(_locationKey);
      if (locationData != null) {
        selectedLocation.value = LocationModel.fromJson(locationData);
      }
    } catch (e) {
      print('Error loading saved location: $e');
    }
  }

  // Load location history
  Future<void> _loadLocationHistory() async {
    try {
      final historyData = _storage.read(_locationHistoryKey);
      if (historyData != null && historyData is List) {
        locationHistory.value = historyData
            .map((item) => LocationModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      print('Error loading location history: $e');
    }
  }

  // Save location to storage
  void _saveLocation(LocationModel location) {
    try {
      _storage.write(_locationKey, location.toJson());
      selectedLocation.value = location;

      // Add to history (avoid duplicates)
      locationHistory.removeWhere((item) => item.placeId == location.placeId);
      locationHistory.insert(0, location);

      // Keep only last 10 locations
      if (locationHistory.length > 10) {
        locationHistory.removeRange(10, locationHistory.length);
      }

      _storage.write(_locationHistoryKey, locationHistory.map((e) => e.toJson()).toList());
    } catch (e) {
      print('Error saving location: $e');
    }
  }

  // Search places using Google Places API
  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      locationSuggestions.clear();
      return;
    }

    isLoading.value = true;
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json'
              '?input=$query'
              '&key=$_apiKey'
              '&components=country:IN'
              '&types=geocode'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictions = data['predictions'] as List;

        locationSuggestions.value = predictions.map((prediction) {
          return LocationModel(
            placeId: prediction['place_id'],
            locationName: prediction['structured_formatting']['main_text'] ?? '',
            pincode: _extractPincode(prediction['description']) ?? '',
            fullAddress: prediction['description'] ?? '',
          );
        }).toList();
      }
    } catch (e) {
      print('Error searching places: $e');
      Get.snackbar('Error', 'Failed to search locations');
    } finally {
      isLoading.value = false;
    }
  }

  // Get place details
  Future<LocationModel?> getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json'
              '?place_id=$placeId'
              '&key=$_apiKey'
              '&fields=geometry,formatted_address,address_components'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'];

        final addressComponents = result['address_components'] as List;
        final pincode = _extractPincodeFromComponents(addressComponents);
        final locationName = _getLocationName(addressComponents);

        return LocationModel(
          placeId: placeId,
          locationName: locationName,
          pincode: pincode,
          fullAddress: result['formatted_address'],
          latitude: result['geometry']['location']['lat']?.toDouble(),
          longitude: result['geometry']['location']['lng']?.toDouble(),
        );
      }
    } catch (e) {
      print('Error getting place details: $e');
    }
    return null;
  }

  // Select location
  Future<void> selectLocation(LocationModel location) async {
    if (location.latitude == null || location.longitude == null) {
      // Get detailed location info
      final detailedLocation = await getPlaceDetails(location.placeId);
      if (detailedLocation != null) {
        _saveLocation(detailedLocation);
      } else {
        _saveLocation(location);
      }
    } else {
      _saveLocation(location);
    }
    Get.back(); // Close dialog
  }

  // Extract pincode from description
  String? _extractPincode(String description) {
    final pincodeRegex = RegExp(r'\b\d{6}\b');
    final match = pincodeRegex.firstMatch(description);
    return match?.group(0);
  }

  // Extract pincode from address components
  String _extractPincodeFromComponents(List addressComponents) {
    for (var component in addressComponents) {
      final types = component['types'] as List;
      if (types.contains('postal_code')) {
        return component['long_name'];
      }
    }
    return '';
  }

  // Get location name from address components
  String _getLocationName(List addressComponents) {
    for (var component in addressComponents) {
      final types = component['types'] as List;
      if (types.contains('locality') || types.contains('sublocality')) {
        return component['long_name'];
      }
    }
    return '';
  }

  // Clear current location
  void clearLocation() {
    selectedLocation.value = null;
    _storage.remove(_locationKey);
  }
}
