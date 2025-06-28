
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jojocart_mobile/theme/appTheme.dart';

import '../controller/ProductOrderController.dart';
import '../dataModel/DeliverySlot.dart';
import '../widget/LoadingIndicator.dart';
import '../widget/LocationDisplayWidget.dart';

class ProductOrderScreen extends StatelessWidget {
  final String productId;
  final String id;

  const ProductOrderScreen({
    Key? key,
    required this.productId,
    required this.id,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductOrderController(
      productId: productId,
      id: id,
    ));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingIndicator(),
                const SizedBox(height: 16),
                const Text('Loading product details...'),
              ],
            ),
          );
        }

        final product = controller.productDetails.value?.data;
        if (product == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Product not found'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshData(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: CustomScrollView(
            slivers: [
              // Improved App Bar
              SliverAppBar(
                expandedHeight: 350,
                pinned: true,
                backgroundColor: AppTheme.surfaceColor,
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                ],

                flexibleSpace: FlexibleSpaceBar(

                  background: _buildImageSection(controller),
                ),
              ),

              // Product Content
              SliverToBoxAdapter(
                child: Container(
                  color: AppTheme.surfaceColor,
                  child: Column(
                    children: [
                      _buildProductInfo(controller, context),
                      _buildWeightOptions(controller, context),
                      _buildMessageOptions(controller, context),
                      _buildLocationSection(context),
                      _buildDeliverySection(controller, context),
                      _buildAboutProduct(controller, context),
                      _buildReviewsSection(controller),
                      const SizedBox(height: 100), // Space for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() => _buildBottomBar(controller)),
    );
  }

  Widget _buildImageSection(ProductOrderController controller) {
    final images = controller.getCurrentImages();

    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.grey[50],
      child: Stack(
        children: [
          // Main Image
          PageView.builder(
            onPageChanged: controller.changeImage,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    images[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[100],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                  ),
                ),
              );
            },
          ),

          // Page Indicators
          if (images.length > 1)
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: controller.currentImageIndex.value == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.currentImageIndex.value == index
                          ? Colors.black
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(ProductOrderController controller, BuildContext context) {
    final product = controller.productDetails.value!.data!;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            product.title ?? '',
            style: context.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),

          // Veg/Non-veg Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: product.isVeg == true ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 6,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.isVeg == true ? 'Eggless' : 'With Egg',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Price Section
          Row(
            children: [
              Text(
                '₹${controller.getDiscountPrice()}',
                style: context.headingSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              const SizedBox(width: 8),
              if (controller.getDiscountPercentage() > 0) ...[
                Text(
                  '₹${controller.getCurrentPrice()}',
                  style: context.bodyMedium?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${controller.getDiscountPercentage()}% OFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Price inclusive of all taxes',
            style: context.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightOptions(ProductOrderController controller, BuildContext context) {
    final weights = controller.productDetails.value?.data?.weight ?? [];

    if (weights.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Options',
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: weights.length,
              itemBuilder: (context, index) {
                final weight = weights[index];
                final isSelected = controller.selectedWeight.value?.sId == weight.sId;

                return GestureDetector(
                  onTap: () => controller.selectWeight(weight),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryColor.withOpacity(0.5) : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected
                          ? AppTheme.primaryColor.withOpacity(0.2)
                          : Colors.white,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[50],
                            ),
                            child: weight.images?.isNotEmpty == true
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                weight.images!.first,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.cake, size: 24, color: Colors.grey),
                              ),
                            )
                                : const Icon(Icons.cake, size: 24, color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            children: [
                              Text(
                                weight.weight ?? '',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '₹${weight.discountPrice ?? weight.price}',
                                style: TextStyle(
                                  fontSize: 9,
                                  color:  Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageOptions(ProductOrderController controller, BuildContext context) {
    final product = controller.productDetails.value!.data!;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customize Your Order',
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          // Message on Cake
          if (product.isMessage == true)
            _buildOptionTile(
              icon: Icons.cake_outlined,
              title: 'Message On Cake',
              subtitle: 'Add a personalized message',
              onTap: () {},
              context: context,
            ),

          const SizedBox(height: 8),

          // Special Request
          _buildOptionTile(
            icon: Icons.edit_note_outlined,
            title: 'Special Request',
            subtitle: 'Any special instructions',
            onTap: () {},
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor, size: 20),
        title: Text(
          title,
          style: context.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: context.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: LocationDisplayWidget(),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutProduct(ProductOrderController controller, BuildContext context) {
    final product = controller.productDetails.value!.data!;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Product',
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          // Vertical expandable cards
          if (product.details?.isNotEmpty == true)
            ...product.details!.map((detail) => _buildExpandableCard(
              detail.key!,
              detail.value!,
              controller,
              context,
            )).toList(),
        ],
      ),
    );
  }

  Widget _buildExpandableCard(String title, String content, ProductOrderController controller, BuildContext context) {
    final isExpanded = controller.expandedSections.contains(title);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? AppTheme.primaryColor.withOpacity(0.3) : Colors.grey[200]!,
          width: isExpanded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded
                ? AppTheme.primaryColor.withOpacity(0.08)
                : Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: () => controller.toggleSection(title),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isExpanded
                    ? AppTheme.primaryColor.withOpacity(0.05)
                    : Colors.transparent,
                borderRadius: isExpanded
                    ? const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                )
                    : BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Icon based on title
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIconForTitle(title),
                      size: 18,
                      color: isExpanded
                          ? AppTheme.primaryColor
                          : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: context.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: isExpanded
                            ? AppTheme.primaryColor
                            : Colors.grey[800],
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isExpanded
                            ? AppTheme.primaryColor.withOpacity(0.1)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: isExpanded
                            ? AppTheme.primaryColor
                            : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Container(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.3),
                          AppTheme.primaryColor.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  _buildContentBasedOnType(title, content, context),
                ],
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBasedOnType(String title, String content, BuildContext context) {
    // Split content by line breaks and filter out empty lines
    final lines = content.split('\r\n').where((line) => line.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        final trimmedLine = line.trim();

        // Check if line contains a colon (key-value pair)
        if (trimmedLine.contains(':') && !trimmedLine.startsWith('http')) {
          final parts = trimmedLine.split(':');
          if (parts.length >= 2) {
            final key = parts[0].trim();
            final value = parts.sublist(1).join(':').trim();

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 10, right: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.primaryColor.withOpacity(0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[200]!,
                          width: 0.5,
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: context.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: '$key: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            TextSpan(text: value),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }

        // Regular paragraph text
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 0.5,
              ),
            ),
            child: Text(
              trimmedLine,
              style: context.bodyMedium?.copyWith(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

// Helper method to get appropriate icon for each section
  IconData _getIconForTitle(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('description') || lowerTitle.contains('product')) {
      return Icons.description_outlined;
    } else if (lowerTitle.contains('delivery') || lowerTitle.contains('shipping')) {
      return Icons.local_shipping_outlined;
    } else if (lowerTitle.contains('care') || lowerTitle.contains('instruction')) {
      return Icons.health_and_safety_outlined;
    } else {
      return Icons.info_outline;
    }
  }


  Widget _buildReviewsSection(ProductOrderController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.rate_review_outlined,
                    color: AppTheme.primaryColor,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Customer Reviews',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                if (controller.productDetails.value?.data?.avgRating != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber.withOpacity(0.1),
                          Colors.orange.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < (controller.productDetails.value!.data!.avgRating!.round())
                                ? Icons.star
                                : Icons.star_border,
                            size: 14,
                            color: Colors.amber[700],
                          );
                        }),
                        const SizedBox(width: 6),
                        Text(
                          '${controller.productDetails.value!.data!.avgRating!.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.amber[800],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Reviews List
          Obx(() {
            if (controller.isReviewsLoading.value) {
              return Container(
                height: 160,
                child: Center(child: LoadingIndicator()),
              );
            }

            final reviews = controller.productReviews.value?.data ?? [];

            if (reviews.isEmpty) {
              return Container(
                height: 120,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.rate_review_outlined,
                        size: 32,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'No reviews yet',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Be the first to review this product',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return _buildReviewCard(review, context);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReviewCard(dynamic review, BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Row
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 16,
                    child: Text(
                      (review.name ?? 'U').substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.name ?? 'Anonymous',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _formatDate(review.createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating Stars
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < (review.rating ?? 0) ? Icons.star : Icons.star_border,
                      size: 12,
                      color: Colors.amber[700],
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Review Text
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  review.review?.isNotEmpty == true
                      ? review.review!
                      : 'Great product! Highly recommended.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 30) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateString;
    }
  }


  Widget _buildBottomBar(ProductOrderController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity Selector
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => controller.updateQuantity(
                    controller.selectedQuantity.value - 1,
                  ),
                  icon: const Icon(Icons.remove, size: 18),
                ),
                Text(
                  '${controller.selectedQuantity.value}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => controller.updateQuantity(
                    controller.selectedQuantity.value + 1,
                  ),
                  icon: const Icon(Icons.add, size: 18),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Add to Cart Button
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Add to cart logic
                Get.snackbar(
                  'Added to Cart',
                  '${controller.productDetails.value?.data?.title} added to cart',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Add to Cart - ₹${(controller.getDiscountPrice() * controller.selectedQuantity.value)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDeliverySection(ProductOrderController controller, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () => _showDeliverySelectionSheet(controller, context),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Obx(() {
            if (controller.selectedDeliveryDate.value != null &&
                controller.selectedDeliverySlot.value != null &&
                controller.selectedTimeSlot.value != null) {
              return _buildSelectedDeliveryInfo(controller, context);
            }

            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey[600],
                      size: 20
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Delivery Date & Time',
                        style: context.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Choose your preferred delivery slot',
                        style: context.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSelectedDeliveryInfo(ProductOrderController controller, BuildContext context) {
    final date = controller.selectedDeliveryDate.value!;
    final slot = controller.selectedDeliverySlot.value!;
    final timeSlot = controller.selectedTimeSlot.value!;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.check_circle,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${date.day} ${_getMonthName(date.month)}, ${date.year}',
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${slot.title} - ${timeSlot.time}',
                style: context.bodySmall?.copyWith(
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),
              if (slot.price > 0) ...[
                const SizedBox(height: 2),
                Text(
                  'Delivery Charge: ₹${slot.price}',
                  style: context.bodySmall?.copyWith(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
              Icons.edit,
              size: 16,
              color: Colors.grey
          ),
        ),
      ],
    );
  }

  void _showDeliverySelectionSheet(ProductOrderController controller, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DeliverySelectionSheet(controller: controller),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

}

class DeliverySelectionSheet extends StatefulWidget {
  final ProductOrderController controller;

  const DeliverySelectionSheet({Key? key, required this.controller}) : super(key: key);

  @override
  State<DeliverySelectionSheet> createState() => _DeliverySelectionSheetState();
}

class _DeliverySelectionSheetState extends State<DeliverySelectionSheet> {
  int currentStep = 0;
  DateTime? tempSelectedDate;
  DeliverySlot? tempSelectedSlot;
  TimeSlot? tempSelectedTimeSlot;

  @override
  void initState() {
    super.initState();
    // Initialize with current selections if any
    tempSelectedDate = widget.controller.selectedDeliveryDate.value;
    tempSelectedSlot = widget.controller.selectedDeliverySlot.value;
    tempSelectedTimeSlot = widget.controller.selectedTimeSlot.value;

    // Set current step based on existing selections
    if (tempSelectedDate != null) currentStep = 1;
    if (tempSelectedSlot != null) currentStep = 2;
    if (tempSelectedTimeSlot != null) currentStep = 2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                if (currentStep > 0)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (currentStep == 2) {
                          currentStep = 1;
                        } else if (currentStep == 1) {
                          currentStep = 0;
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getStepTitle(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Progress indicator
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildStepIndicator(0, 'Date'),
                Expanded(child: _buildStepLine(0)),
                _buildStepIndicator(1, 'Slot'),
                Expanded(child: _buildStepLine(1)),
                _buildStepIndicator(2, 'Time'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Content
          Expanded(
            child: _buildStepContent(),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (currentStep) {
      case 0:
        return 'Select Delivery Date';
      case 1:
        return 'Choose Delivery Slot';
      case 2:
        return 'Pick Time Slot';
      default:
        return 'Delivery Selection';
    }
  }

  Widget _buildStepIndicator(int step, String label) {
    bool isActive = currentStep >= step;
    bool isCompleted = currentStep > step;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppTheme.primaryColor
                : isActive
                ? AppTheme.primaryColor.withOpacity(0.2)
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
            border: isActive && !isCompleted
                ? Border.all(color: AppTheme.primaryColor, width: 2)
                : null,
          ),
          child: Center(
            child: isCompleted
                ? Icon(
              Icons.check,
              color: Colors.white,
              size: 18,
            )
                : Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? AppTheme.primaryColor : Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? AppTheme.primaryColor : Colors.grey[600],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    bool isCompleted = currentStep > step;

    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isCompleted ? AppTheme.primaryColor : Colors.grey[200],
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildDateSelection();
      case 1:
        return _buildSlotSelection();
      case 2:
        return _buildTimeSelection();
      default:
        return Container();
    }
  }

  Widget _buildDateSelection() {
    return Column(
      children: [
        Expanded(
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.deepOrange, // selected date background
                onPrimary: AppTheme.primaryColor,    // selected date text color
                onSurface: Colors.black,    // default text color
              ),
            ),
            child: CalendarDatePicker(
              initialDate: tempSelectedDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 30)),
              onDateChanged: (date) {
                setState(() {
                  tempSelectedDate = date;
                });
                },
            ),
          ),

        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Gift may be delivered prior or after the chosen date.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: tempSelectedDate != null
                      ? () {
                    // Save date to controller
                    widget.controller.selectDeliveryDate(tempSelectedDate!);
                    setState(() {
                      currentStep = 1;
                    });
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildSlotSelection() {
    final slots = widget.controller.getAvailableDeliverySlots();

    return Column(
      children: [
        if (tempSelectedDate != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  '${tempSelectedDate!.day} ${_getMonthName(tempSelectedDate!.month)}, ${tempSelectedDate!.year}',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];
              bool isSelected = tempSelectedSlot == slot;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      tempSelectedSlot = slot;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.grey[200]!,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.grey[400]!,
                              width: 2,
                            ),
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                slot.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: isSelected
                                      ? AppTheme.primaryColor
                                      : Colors.black87,
                                ),
                              ),
                              if (slot.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  slot.description,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: slot.price == 0
                                ? Colors.green.withOpacity(0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            slot.price == 0 ? 'FREE' : '₹${slot.price}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: slot.price == 0
                                  ? Colors.green[700]
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: tempSelectedSlot != null
                  ? () {
                // Save selections to controller
                widget.controller.selectDeliveryDate(tempSelectedDate!);
                widget.controller.selectDeliverySlot(tempSelectedSlot!);
                setState(() {
                  currentStep = 2;
                });
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildTimeSelection() {
    final timeSlots = widget.controller.getAvailableTimeSlots();

    return Column(
      children: [
        // Selected date and slot info
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppTheme.primaryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${tempSelectedDate!.day} ${_getMonthName(tempSelectedDate!.month)}, ${tempSelectedDate!.year}',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.local_shipping,
                    color: AppTheme.primaryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tempSelectedSlot!.title,
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: tempSelectedSlot!.price == 0
                          ? Colors.green.withOpacity(0.2)
                          : AppTheme.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tempSelectedSlot!.price == 0
                          ? 'FREE'
                          : '₹${tempSelectedSlot!.price}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: tempSelectedSlot!.price == 0
                            ? Colors.green[700]
                            : AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Time slots
        if (timeSlots.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No time slots available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please select a different date or delivery slot',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = timeSlots[index];
                bool isSelected = tempSelectedTimeSlot == timeSlot;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        tempSelectedTimeSlot = timeSlot;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryColor.withOpacity(0.1)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.grey[200]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : Colors.grey[400]!,
                                width: 2,
                              ),
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            timeSlot.time,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        // Confirm button
        Container(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: tempSelectedTimeSlot != null
                  ? () {
                // Save all selections to controller
                widget.controller.selectDeliveryDate(tempSelectedDate!);
                widget.controller.selectDeliverySlot(tempSelectedSlot!);
                widget.controller.selectTimeSlot(tempSelectedTimeSlot!);
                Navigator.pop(context);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Confirm Selection',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}