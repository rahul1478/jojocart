import 'CategoryItem.dart';

class NavItem {
  final String title;
  final List<CategoryItem> content;

  NavItem({required this.title, required this.content});

  factory NavItem.fromJson(Map<String, dynamic> json) {
    return NavItem(
      title: json['title'],
      content: (json['content'] as List)
          .map((item) => CategoryItem.fromJson(item))
          .toList(),
    );
  }
}