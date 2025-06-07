import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../dataModel/ProductModel.dart';

class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;
  final RxBool isLoadingMore = false.obs;

  String searchText = '';

  @override
  void onInit() {
    super.onInit();
    debugPrint('🎯 ProductController initialized');
  }

  void setSearchText(String text) {
    debugPrint('🔍 Setting search text: "$text" (Previous: "$searchText")');

    // Always reload when search text is set, regardless of previous value
    // This ensures fresh data for each screen instance
    searchText = text;

    // Reset all states
    currentPage.value = 1;
    products.clear();
    hasMoreData.value = true;
    hasError.value = false;
    isLoading.value = false;
    isLoadingMore.value = false;

    debugPrint('🔄 Cleared data and reloading for search: "$text"');

    // Load products immediately
    if (text.isNotEmpty) {
      loadProducts();
    }
  }

  Future<void> loadProducts({bool loadMore = false}) async {
    // Prevent multiple simultaneous calls
    if ((isLoading.value && !loadMore) || (isLoadingMore.value && loadMore)) {
      debugPrint('⏭️ Skipping load - already loading');
      return;
    }

    if (!hasMoreData.value && loadMore) {
      debugPrint('⏭️ Skipping load - no more data');
      return;
    }

    // Ensure we have search text
    if (searchText.isEmpty) {
      debugPrint('❌ No search text provided');
      return;
    }

    if (loadMore) {
      isLoadingMore.value = true;
      debugPrint('📄 Loading more products - Page: ${currentPage.value}');
    } else {
      isLoading.value = true;
      debugPrint('🚀 Loading initial products - Search: "$searchText"');
    }

    hasError.value = false;

    try {
      final pageToLoad = loadMore ? currentPage.value : 1;
      debugPrint('📡 API Call - Page: $pageToLoad, Search: "$searchText"');

      final response = await http.post(
        Uri.parse('https://kingsbakerbackend-production.up.railway.app/api/product/filterProduct'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "search_text": searchText,
          "sortBy": "new",
          "page": pageToLoad,
          "limit": 33,
          "productFilters": {}
        }),
      );

      debugPrint('📥 Response - Status: ${response.statusCode}, Body Length: ${response.body.length}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        List<ProductModel> newProducts = [];

        if (decoded is List) {
          newProducts = decoded
              .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
              .toList();
        } else if (decoded is Map && decoded.containsKey('products')) {
          List productList = decoded['products'] ?? [];
          newProducts = productList
              .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }

        debugPrint('📦 Parsed ${newProducts.length} products');
        print("check the data: ${jsonEncode(newProducts)}");


        if (loadMore) {
          products.addAll(newProducts);
          currentPage.value++; // Increment page for next load
          debugPrint('➕ Added to existing ${products.length - newProducts.length} products, total now: ${products.length}');
        } else {
          products.assignAll(newProducts);
          currentPage.value = 2; // Next page will be 2
          debugPrint('🔄 Replaced with ${newProducts.length} products');
        }

        // Check if there are more products to load
        hasMoreData.value = newProducts.length >= 33;
        debugPrint('📊 Has more data: ${hasMoreData.value}');

      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('❌ Error loading products: $e');
      hasError.value = true;
      errorMessage.value = e.toString().contains('HTTP 404')
          ? 'Products not found for "$searchText"'
          : 'Failed to load products. Please check your connection.';
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
      debugPrint('✅ Load complete - Loading: ${isLoading.value}, LoadingMore: ${isLoadingMore.value}');
    }
  }

  void loadMoreProducts() {
    debugPrint('🔄 Load more requested - hasMore: ${hasMoreData.value}, isLoadingMore: ${isLoadingMore.value}, isLoading: ${isLoading.value}');
    if (hasMoreData.value && !isLoadingMore.value && !isLoading.value) {
      loadProducts(loadMore: true);
    }
  }

  void refreshProducts() {
    if (searchText.isEmpty) return;

    debugPrint('🔄 Refreshing products for: "$searchText"');
    currentPage.value = 1;
    hasMoreData.value = true;
    hasError.value = false;
    products.clear(); // Clear existing data
    loadProducts();
  }

  @override
  void onClose() {
    debugPrint('🗑️ ProductController disposed');
    // Clean up resources when controller is disposed
    products.clear();
    searchText = '';
    currentPage.value = 1;
    hasMoreData.value = true;
    hasError.value = false;
    isLoading.value = false;
    isLoadingMore.value = false;
    super.onClose();
  }
}