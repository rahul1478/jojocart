class HomeData {
  final String id;
  final String homeMob;
  final String updatedAt;

  HomeData({required this.id, required this.homeMob, required this.updatedAt});

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      id: json['_id'] ?? '',
      homeMob: json['homeMob'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class HomeSection {
  final int itemRanked;
  final String title;
  final String type;
  final Map<String, dynamic> containerStyle;
  final Map<String, dynamic> innerContainerStyle;
  final Map<String, dynamic> boxStyle;
  final List<HomeItem> items;

  HomeSection({
    required this.itemRanked,
    required this.title,
    required this.type,
    required this.containerStyle,
    required this.innerContainerStyle,
    required this.boxStyle,
    required this.items,
  });

  factory HomeSection.fromJson(Map<String, dynamic> json) {
    return HomeSection(
      itemRanked: json['item_ranked'] ?? 0,
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      containerStyle: json['containerStyle'] ?? {},
      innerContainerStyle: json['innerContainerStyle'] ?? {},
      boxStyle: json['boxStyle'] ?? {},
      items: (json['items'] as List?)
          ?.map((item) => HomeItem.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class HomeItem {
  final String image;
  final String type;
  final String route;
  final String text;
  final Map<String, dynamic> cardStyle;
  final Map<String, dynamic> imageStyle;
  final Map<String, dynamic> textStyle;

  HomeItem({
    required this.image,
    required this.type,
    required this.route,
    required this.text,
    required this.cardStyle,
    required this.imageStyle,
    required this.textStyle,
  });

  factory HomeItem.fromJson(Map<String, dynamic> json) {
    return HomeItem(
      image: json['image'] ?? '',
      type: json['type'] ?? '',
      route: json['route'] ?? '',
      text: json['text'] ?? '',
      cardStyle: json['cardStyle'] ?? {},
      imageStyle: json['imageStyle'] ?? {},
      textStyle: json['textStyle'] ?? {},
    );
  }
}