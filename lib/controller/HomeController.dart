import 'package:flutter/cupertino.dart';
import 'package:jojocart_mobile/view/MouthWateringCakesPage.dart';

import '../dataModel/HomeData.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  var isLoading = false.obs;
  var homeSections = <HomeSection>[].obs;
  var errorMessage = ''.obs;
  var suggestions = <String>[].obs;
  var hasText = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Replace with your actual API endpoint
      final response = await http.get(
        Uri.parse('https://kingsbakerbackend-production.up.railway.app/api/component/getCarosol?key=homeMob'),

        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final homeData = HomeData.fromJson(jsonData['data']);

        // Parse the homeMob JSON string
        final homeMobData = json.decode(homeData.homeMob);
        final List<dynamic> sectionsData = homeMobData['data']['data'];

        homeSections.value = sectionsData
            .map((section) => HomeSection.fromJson(section))
            .toList()
          ..sort((a, b) => a.itemRanked.compareTo(b.itemRanked));

      } else {
        errorMessage.value = 'Failed to load data';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }


  void onItemTap(String route, String text) {
    // Handle item tap navigation
    Get.to(() => ProductViewPage(searchText: route));

  }

  void onSearchChanged(String query) async {
    hasText.value = query.trim().isNotEmpty;

    if (!hasText.value) {
      suggestions.clear();
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("https://kingsbakerbackend-production.up.railway.app/api/suggestionProduct"),
        body: {'query': query},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        suggestions.value = List<String>.from(data['suggestions']);
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
      suggestions.clear();
    }
  }
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}