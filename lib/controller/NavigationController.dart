import 'package:get/get.dart';

import '../dataModel/NavItem.dart';
import '../view/MouthWateringCakesPage.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;
  var selectedCategory = ''.obs;
  var selectedSubItem = ''.obs;
  var expandedCategories = <String, bool>{}.obs;

  final List<Map<String, dynamic>> navItemsData = [
    {
      "title": "Shop By Occasions",
      "content": [
        {
          "category": "Birthday",
          "items": [
            "Flowers",
            "Flowers N Cakes",
            "Cakes",
            "Flowers N Chocolate",
            "Plants",
            "Combos",
            "Gift Hamper",
            "Personalized Gifts",
            "Chocolates",
          ],
        },
        {
          "category": "Anniversary",
          "items": [
            "Gifts",
            "Best Sellers",
            "New Arrival",
            "Premium",
            "Unique",
            "Luxe Anniversary",
          ],
        },
        {
          "category": "Wedding",
          "items": [
            "Flowers",
            "Jewellery",
            "Flowers N Cakes",
            "Cakes",
            "Flowers N Chocolate",
            "Plants",
            "Combos",
            "Gift Hamper",
            "Personalized Gifts",
            "Chocolates",
            "Premium",
          ],
        },
        {
          "category": "Festive Joy",
          "items": [
            "Xmas-joy",
            "Xmas Tree",
            "Cakes",
            "Flowers N Chocolate",
            "Plants",
            "Combos",
            "Gift Hamper",
            "Personalized Gifts",
          ],
        },
        {
          "category": "Other Events",
          "items": ["Get Well Soon Flowers", "Plants"],
        },
      ],
    },
    {
      "title": "Shop By Category",
      "content": [
        {
          "category": "Cakes",
          "items": [
            "All Cakes",
            "Birthday Cakes",
            "Anniversary Cakes",
            "Congratulations",
            "25th Anniversary",
            "Wedding Cakes",
            "1st Anniversary",
            "Short Cakes",
          ],
        },
        {
          "category": "Flowers",
          "items": [
            "Mixed Flowers",
            "Carnations",
            "Exotic Flowers",
            "Roses",
            "Orchids",
            "Lilies",
          ],
        },
        {
          "category": "Personalised",
          "items": [
            "Mugs",
            "Cushion",
            "Bottles",
            "Accessories",
            "Lamps",
            "Frames",
            "Keychains",
            "Clocks",
            "Plates",
          ],
        },
        {
          "category": "Plants",
          "items": ["Indoor Plants", "Desktop Plants", "Hanging Plants"],
        },
        {
          "category": "Chocolates",
          "items": [
            "All Chocolates",
            "Best Seller",
            "New Arrival",
            "Gourmet Chocolates",
            "Premium Chocolates",
          ],
        },
        {
          "category": "Combos N Hampers",
          "items": [
            "Feature Combos",
            "Cake Combos",
            "Flower Combos",
            "Birthday Combos",
            "Wedding Combos",
          ],
        },
      ],
    },
    {
      "title": "Send Gifts Abroad",
      "content": [
        {
          "category": "USA",
          "items": [
            "Christmas Gifts USA",
            "Flowers USA",
            "Gifts USA",
            "Cakes USA",
            "Chocolates USA",
            "Sweets USA",
            "Roses USA",
            "Gift Baskets USA",
          ],
        },
        {
          "category": "Canada",
          "items": [
            "Christmas Gifts Canada",
            "Flowers Canada",
            "Gifts Canada",
            "Cakes Canada",
            "Chocolates Canada",
            "Sweets Canada",
            "Roses Canada",
            "Gift Baskets Canada",
          ],
        },
        {
          "category": "Australia",
          "items": [
            "Christmas Gifts Australia",
            "Flowers Australia",
            "Gifts Australia",
            "Cakes Australia",
            "Chocolates Australia",
            "Sweets Australia",
            "Roses Australia",
            "Gift Baskets Australia",
          ],
        },
        {
          "category": "UK",
          "items": [
            "Christmas Gifts UK",
            "Flowers UK",
            "Gifts UK",
            "Cakes UK",
            "Chocolates UK",
            "Sweets UK",
            "Roses UK",
            "Gift Baskets UK",
          ],
        },
        {
          "category": "UAE",
          "items": [
            "Christmas Gifts UAE",
            "Flowers UAE",
            "Gifts UAE",
            "Cakes UAE",
            "Chocolates UAE",
            "Sweets UAE",
            "Roses UAE",
            "Gift Baskets UAE",
          ],
        },
        {
          "category": "Singapore",
          "items": [
            "Christmas Gifts Singapore",
            "Flowers Singapore",
            "Gifts Singapore",
            "Cakes Singapore",
            "Chocolates Singapore",
            "Sweets Singapore",
            "Roses Singapore",
            "Gift Baskets Singapore",
          ],
        },
      ],
    },
  ];

  late List<NavItem> navItems;

  @override
  void onInit() {
    super.onInit();
    navItems = navItemsData.map((item) => NavItem.fromJson(item)).toList();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  void toggleCategory(String category) {
    expandedCategories[category] = !(expandedCategories[category] ?? false);
  }

  bool isCategoryExpanded(String category) {
    return expandedCategories[category] ?? false;
  }

  void selectSubItem(String category, String subItem) {
    selectedCategory.value = category;
    selectedSubItem.value = subItem;
    // Navigate to product screen
    Get.to(() => ProductViewPage(searchText: subItem));
  }

  NavItem get occasionsData => navItems[0];
  NavItem get categoriesData => navItems[1];
  NavItem get internationalData => navItems[2];
}