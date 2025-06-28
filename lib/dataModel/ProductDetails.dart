class ProductDetails {
  String? message;
  int? code;
  Data? data;

  ProductDetails({this.message, this.code, this.data});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? productId;
  int? prices;
  int? pp;
  int? discountPrice;
  List<String>? imageLink;
  String? title;
  List<String>? images;
  bool? isMessage;
  bool? isImage;
  bool? isVeg;
  bool? isCourier;
  bool? freeDelivery;
  String? description;
  String? specifications;
  List<Details>? details;
  int? rating;
  List<Weight>? weight;
  String? brand;
  List<String>? color;
  AltTexts? altTexts;
  bool? active;
  String? metaTag;
  String? metaDescription;
  String? ogTitle;
  String? ogDescription;
  double? avgRating;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? hasBalloonNumber;

  Data({this.sId, this.productId, this.prices, this.pp, this.discountPrice, this.imageLink, this.title, this.images, this.isMessage, this.isImage, this.isVeg, this.isCourier, this.freeDelivery, this.description, this.specifications, this.details, this.rating, this.weight, this.brand, this.color, this.altTexts, this.active, this.metaTag, this.metaDescription, this.ogTitle, this.ogDescription, this.avgRating, this.createdAt, this.updatedAt, this.iV, this.hasBalloonNumber});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productId = json['productId'];
    prices = json['prices'];
    pp = json['pp'];
    discountPrice = json['discount_price'];
    imageLink = json['imageLink'].cast<String>();
    title = json['title'];
    if (json['images'] != null) {
      images = <String>[];
      json['images'].forEach((v) {
        images!.add(v.toString()); // ensures value is added as a string
      });
    }

    isMessage = json['is_message'];
    isImage = json['is_image'];
    isVeg = json['is_veg'];
    isCourier = json['is_courier'];
    freeDelivery = json['free_delivery'];
    description = json['description'];
    specifications = json['specifications'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) { details!.add(new Details.fromJson(v)); });
    }
    rating = json['rating'];
    if (json['weight'] != null) {
      weight = <Weight>[];
      json['weight'].forEach((v) { weight!.add(new Weight.fromJson(v)); });
    }
    brand = json['brand'];
    color = json['color'].cast<String>();
    altTexts = json['alt_texts'] != null ? new AltTexts.fromJson(json['alt_texts']) : null;
    active = json['active'];
    metaTag = json['meta_tag'];
    metaDescription = json['meta_description'];
    ogTitle = json['og_title'];
    ogDescription = json['og_description'];
    avgRating = json['avg_rating']?.toDouble();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    hasBalloonNumber = json['has_balloon_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['productId'] = this.productId;
    data['prices'] = this.prices;
    data['pp'] = this.pp;
    data['discount_price'] = this.discountPrice;
    data['imageLink'] = this.imageLink;
    data['title'] = this.title;
    if (this.images != null) {
      data['images'] = this.images;
    }
    data['is_message'] = this.isMessage;
    data['is_image'] = this.isImage;
    data['is_veg'] = this.isVeg;
    data['is_courier'] = this.isCourier;
    data['free_delivery'] = this.freeDelivery;
    data['description'] = this.description;
    data['specifications'] = this.specifications;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    data['rating'] = this.rating;
    if (this.weight != null) {
      data['weight'] = this.weight!.map((v) => v.toJson()).toList();
    }
    data['brand'] = this.brand;
    data['color'] = this.color;
    if (this.altTexts != null) {
      data['alt_texts'] = this.altTexts!.toJson();
    }
    data['active'] = this.active;
    data['meta_tag'] = this.metaTag;
    data['meta_description'] = this.metaDescription;
    data['og_title'] = this.ogTitle;
    data['og_description'] = this.ogDescription;
    data['avg_rating'] = this.avgRating;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['has_balloon_number'] = this.hasBalloonNumber;
    return data;
  }
}

class Details {
  String? key;
  String? value;

  Details({this.key, this.value});

  Details.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}

class Weight {
  String? weight;
  int? price;
  List<String>? images;
  int? pp;
  int? discountPrice;
  String? description;
  String? sId;

  Weight({this.weight, this.price, this.images, this.pp, this.discountPrice, this.description, this.sId});

  Weight.fromJson(Map<String, dynamic> json) {
    weight = json['weight'];
    price = json['price'];
    images = json['images'].cast<String>();
    pp = json['pp'];
    discountPrice = json['discount_price'];
    description = json['description'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weight'] = this.weight;
    data['price'] = this.price;
    data['images'] = this.images;
    data['pp'] = this.pp;
    data['discount_price'] = this.discountPrice;
    data['description'] = this.description;
    data['_id'] = this.sId;
    return data;
  }
}

  class AltTexts {

  AltTexts.fromJson(Map<String, dynamic> json);

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
    }
}