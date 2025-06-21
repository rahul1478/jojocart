import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/LocationController.dart';
import '../dataModel/LocationModel.dart';

class LocationSelectionDialog extends StatelessWidget {
  const LocationSelectionDialog({Key? key}) : super(key: key);

  static void show() {
    Get.dialog(
      const LocationSelectionDialog(),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LocationController>();
    final searchController = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 400),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.orange,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Select Your Location',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Find the perfect location for delivery',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // Search Field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search for area, street name, pincode...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  controller.searchPlaces(value);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Content Area
            Flexible(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                }

                if (controller.locationSuggestions.isNotEmpty) {
                  return _buildSuggestionsList(controller);
                }

                if (controller.locationHistory.isNotEmpty && searchController.text.isEmpty) {
                  return _buildHistoryList(controller);
                }

                return _buildEmptyState();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsList(LocationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Suggestions',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: controller.locationSuggestions.length,
            itemBuilder: (context, index) {
              final location = controller.locationSuggestions[index];
              return _buildLocationTile(location, controller);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList(LocationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            const Text(
              'Recent Locations',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: controller.locationHistory.length,
            itemBuilder: (context, index) {
              final location = controller.locationHistory[index];
              return _buildLocationTile(location, controller, isHistory: true);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLocationTile(LocationModel location, LocationController controller, {bool isHistory = false}) {
    return InkWell(
      onTap: () => controller.selectLocation(location),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isHistory ? Icons.history : Icons.location_on_outlined,
                color: Colors.orange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.locationName.isNotEmpty
                        ? location.locationName
                        : location.fullAddress.split(',').first,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (location.pincode.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            location.pincode,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          location.fullAddress,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Start typing to search locations',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter area name, street, or pincode',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}