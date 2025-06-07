import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Add this dependency

import '../controller/ProductController.dart';
import '../dataModel/ProductModel.dart';
import '../widget/LoadingIndicator.dart';

class SameDayPage extends StatefulWidget {
  final String searchText;

  const SameDayPage({
    Key? key,
    required this.searchText,
  }) : super(key: key);

  @override
  State<SameDayPage> createState() => _SameDayPageState();
}

class _SameDayPageState extends State<SameDayPage> {
  late ProductController controller;

  @override
  void initState() {
    super.initState();
    // Always create a fresh controller instance for this screen
    // This ensures we don't have stale data from previous searches
    final String controllerTag = 'product_${widget.searchText}_${DateTime.now().millisecondsSinceEpoch}';
    controller = Get.put(ProductController(), tag: controllerTag);

    // Set search text and load products immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setSearchText(widget.searchText);
    });
  }

  @override
  void dispose() {
    // Clean up the specific controller instance
    final String controllerTag = 'product_${widget.searchText}_${DateTime.now().millisecondsSinceEpoch}';
    Get.delete<ProductController>(tag: controllerTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Category Filter Chips
          SliverToBoxAdapter(
            child: Container(
              height: 106,
              margin: const EdgeInsets.only(top: 16, bottom: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryChip('Father\'s Day', 'assets/fathers_day.jpg', true),
                  _buildCategoryChip('Bestsellers', 'assets/bestsellers.jpg', false),
                  _buildCategoryChip('FNP Luxe', 'assets/luxe.jpg', false),
                  _buildCategoryChip('Same Day\nDelivery', 'assets/same_day.jpg', false),
                ],
              ),
            ),
          ),

          // Products Grid
          Obx(() {
            if (controller.isLoading.value && controller.products.isEmpty) {
              // Show skeleton loading instead of spinner
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildSkeletonCard(),
                    childCount: 6, // Show 6 skeleton cards
                  ),
                ),
              );
            }

            if (controller.hasError.value && controller.products.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.refreshProducts,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    // Handle load more logic
                    if (index >= controller.products.length) {
                      if (controller.hasMoreData.value && !controller.isLoadingMore.value) {
                        // Trigger load more only once
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          controller.loadMoreProducts();
                        });
                      }

                      if (controller.isLoadingMore.value) {
                        return _buildSkeletonCard();
                      }

                      return const SizedBox.shrink();
                    }

                    final product = controller.products[index];
                    return _buildProductCard(product, context);
                  },
                  childCount: controller.products.length +
                      (controller.hasMoreData.value ? 1 : 0),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Skeleton card for loading state
  Widget _buildSkeletonCard() {
    return Skeletonizer(
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skeleton Image
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  color: Colors.grey,
                ),
              ),
            ),
            // Skeleton Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Skeleton Title
                    Container(
                      width: double.infinity,
                      height: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    // Skeleton Price
                    Container(
                      width: 80,
                      height: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    // Skeleton Delivery
                    Container(
                      width: 120,
                      height: 12,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDisplayTitle(String searchText) {
    final lowerText = searchText.toLowerCase();
    if (lowerText.contains('chocolate')) {
      return 'Chocolates';
    } else if (lowerText.contains('cake')) {
      return 'Cakes';
    } else if (lowerText.contains('flower')) {
      return 'Flowers';
    } else if (lowerText.contains('gift')) {
      return 'Gifts';
    } else {
      return searchText;
    }
  }

  Widget _buildCategoryChip(String label, String imagePath, bool isSelected) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: Colors.blue, width: 2)
                  : Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                color: Colors.grey.shade100,
                child: const Icon(
                  Icons.cake,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? Colors.blue : Colors.black,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductModel product, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: Stack(
                  children: [
                    Image.network(
                      product.imageLink?.isNotEmpty == true
                          ? product.imageLink!.first
                          : 'https://via.placeholder.com/200x200?text=No+Image',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 30,
                          ),
                        );
                      },
                    ),

                    // Rating Badge
                    if (product.avgRating != null && product.avgRating! > 0)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 10,
                              ),
                              Text(
                                product.avgRating!.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Wishlist Button
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),

                    // Discount Badge
                    if (product.discountPrice != null &&
                        product.prices != null &&
                        product.discountPrice! < product.prices!)
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${(((product.prices! - product.discountPrice!) / product.prices!) * 100).round()}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.title ?? 'Delicious Cake',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),
                  // Bottom section with price and delivery
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price Row
                      Row(
                        children: [
                          Text(
                            '₹${product.discountPrice ?? product.prices ?? 0}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          if (product.discountPrice != null &&
                              product.prices != null &&
                              product.discountPrice! < product.prices!)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                '₹${product.prices}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Delivery Info
                      Text(
                        'Earliest Delivery: 09 Jun',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}