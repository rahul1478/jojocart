class CategoryItem {
  final String category;
  final List<String> items;

  CategoryItem({required this.category, required this.items});

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      category: json['category'],
      items: List<String>.from(json['items']),
    );
  }
}