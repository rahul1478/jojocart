import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/NavigationController.dart';

class OccasionsScreen extends StatelessWidget {
  OccasionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFAFAFA),
              Color(0xFFF5F5F5),
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.occasionsData.content.length,
          itemBuilder: (context, index) {
            final category = controller.occasionsData.content[index];

            return Obx(() {
              final isExpanded = controller.isCategoryExpanded(category.category);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  elevation: isExpanded ? 3 : 1,
                  shadowColor: Colors.black.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFE5E5E5),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => controller.toggleCategory(category.category),
                          borderRadius: BorderRadius.circular(12),
                          splashColor: const Color(0xFFF5F5F5),
                          highlightColor: const Color(0xFFF8F8F8),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6B7280),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _getCategoryIcon(category.category),
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category.category,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1F2937),
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${category.items.length} options',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF9CA3AF),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: AnimatedRotation(
                                    turns: isExpanded ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 200),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF6B7280),
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          height: isExpanded ? null : 0,
                          child: isExpanded
                              ? Container(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              children: [
                                Container(
                                  height: 1,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  color: const Color(0xFFF1F1F1),
                                ),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: category.items.map<Widget>((item) {
                                    return InkWell(
                                      onTap: () => controller.selectSubItem(category.category, item),
                                      borderRadius: BorderRadius.circular(16),
                                      splashColor: const Color(0xFFF5F5F5),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9FAFB),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: const Color(0xFFE5E7EB),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            color: Color(0xFF374151),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            letterSpacing: 0.1,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    // Unified grey color scheme for professional look
    return const Color(0xFF6B7280);
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'birthday':
        return Icons.cake_outlined;
      case 'anniversary':
        return Icons.favorite_outlined;
      case 'wedding':
        return Icons.local_florist_outlined;
      case 'festive joy':
        return Icons.celebration_outlined;
      case 'other events':
        return Icons.card_giftcard_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}