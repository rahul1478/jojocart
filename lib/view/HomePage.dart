import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;

import 'package:get/get.dart';
import 'package:jojocart_mobile/view/MouthWateringCakesPage.dart';
import '../controller/HomeController.dart';
import '../dataModel/HomeData.dart';
import '../theme/appTheme.dart';
import '../widget/LoadingIndicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: controller.searchController,
                focusNode: controller.searchFocusNode,
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search for gifts, cakes, flowers...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: Obx(() => controller.hasText.value
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      FocusScope.of(context).unfocus(); // ⌨️ closes keyboard
                      controller.searchController.clear();
                      controller.onSearchChanged('');
                    },
                  )
                      : const SizedBox.shrink(), // ✅ replaces null
                  ),

                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),

            Obx(() {
              if (controller.suggestions.isEmpty) return SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = controller.suggestions[index];
                    return ListTile(
                      title: Text(suggestion),
                      onTap: () {
                        FocusScope.of(context).unfocus(); // ⌨️ closes keyboard
                        controller.searchController.text = suggestion;
                        controller.suggestions.clear();
                        controller.searchFocusNode.unfocus();

                        Get.to(() => ProductViewPage(searchText: suggestion));
                      },

                    );
                  },
                ),
              );
            }),

            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: LoadingIndicator(),
                  );
                }
                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.fetchHomeData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.homeSections.length,
                  itemBuilder: (context, index) {
                    final section = controller.homeSections[index];
                    return _buildSection(context, section, controller,index);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, HomeSection section, HomeController controller,int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.title.isNotEmpty && index !=0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                section.title.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              )


            ),

          _buildSectionContent(context, section, controller),
        ],
      ),
    );
  }

  Widget _buildSectionContent(BuildContext context, HomeSection section, HomeController controller) {
    switch (section.type) {
      case 'carusel_full':
        return _buildCarousel(section, controller);
      case 'customSizedGrid':
        return _buildCustomGrid(section, controller);
      default:
        return _buildDefaultGrid(section, controller);
    }
  }

  Widget _buildCarousel(HomeSection section, HomeController controller) {
    return Container(
      height: 200,
      child: slider.CarouselSlider.builder(
        itemCount: section.items.length,
        itemBuilder: (context, index, realIndex) {
          final item = section.items[index];
          return _buildCarouselItem(item, controller);
        },
        options: slider.CarouselOptions(
          height: 200,
          viewportFraction: 0.95,
          enableInfiniteScroll: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          enlargeCenterPage: true,
        ),
      ),
    );
  }

  Widget _buildCarouselItem(HomeItem item, HomeController controller) {
    return GestureDetector(
      onTap: () => controller.onItemTap(item.route, item.text),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.network(
                item.image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
              if (item.text.isNotEmpty)
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomGrid(HomeSection section, HomeController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _buildGridContent(section, controller),
    );
  }

  Widget _buildDefaultGrid(HomeSection section, HomeController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: section.items.length,
        itemBuilder: (context, index) {
          return _buildGridItem(section.items[index], controller);
        },
      ),
    );
  }

  Widget _buildGridContent(HomeSection section, HomeController controller) {
    // Determine grid layout based on items count and type
    int crossAxisCount = 3;
    double childAspectRatio = 0.8;

    if (section.items.length <= 3) {
      crossAxisCount = section.items.length;
      childAspectRatio = 0.73;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: section.items.length,
      itemBuilder: (context, index) {
        return _buildGridItem(section.items[index], controller);
      },
    );
  }

  Widget _buildGridItem(HomeItem item, HomeController controller) {
    return GestureDetector(
      onTap: () => controller.onItemTap(item.route, item.text),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.05),
          //     blurRadius: 4,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12),bottom: Radius.circular(12)),
                child: Image.network(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            if (item.text.isNotEmpty)
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    item.text,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}