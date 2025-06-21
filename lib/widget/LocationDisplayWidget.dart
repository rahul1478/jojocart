import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/LocationController.dart';
import '../theme/appTheme.dart';
import 'LocationSelectionDialog.dart';

class LocationDisplayWidget extends StatelessWidget {
  const LocationDisplayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (controller) {
        return Obx(() {
          final location = controller.selectedLocation.value;
          final isInitialized = controller.isInitialized.value;

          // Show loading indicator while initializing
          if (!isInitialized) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.transparent),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return GestureDetector(
            onTap: () => LocationSelectionDialog.show(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          location?.locationName.isNotEmpty == true
                              ? location!.locationName
                              : (location?.fullAddress.isNotEmpty == true
                              ? location!.fullAddress.split(',').first.trim()
                              : 'Select Location'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (location?.pincode.isNotEmpty == true) ...[
                          const SizedBox(height: 2),
                          Text(
                            location!.pincode,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              height: 1.1,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

