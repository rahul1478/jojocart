class ProductModel {
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
  List<dynamic>? productDetails; // Placeholder, define a model if needed
  List<Details>? details;
  List<Amenities>? amenities;
  List<String>? event;
  int? rating;
  List<String>? tags;
  List<String>? categories;
  List<String>? addOns;
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

  ProductModel({
    this.sId,
    this.productId,
    this.prices,
    this.pp,
    this.discountPrice,
    this.imageLink,
    this.title,
    this.images,
    this.isMessage,
    this.isImage,
    this.isVeg,
    this.isCourier,
    this.freeDelivery,
    this.description,
    this.specifications,
    this.productDetails,
    this.details,
    this.amenities,
    this.event,
    this.rating,
    this.tags,
    this.categories,
    this.addOns,
    this.weight,
    this.brand,
    this.color,
    this.altTexts,
    this.active,
    this.metaTag,
    this.metaDescription,
    this.ogTitle,
    this.ogDescription,
    this.avgRating,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.hasBalloonNumber,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productId = json['productId'];
    prices = json['prices'];
    pp = json['pp'];
    discountPrice = json['discount_price'];
    imageLink = json['imageLink'] != null ? List<String>.from(json['imageLink']) : null;
    title = json['title'];
    images = json['images'] != null ? List<String>.from(json['images']) : null;
    isMessage = json['is_message'];
    isImage = json['is_image'];
    isVeg = json['is_veg'];
    isCourier = json['is_courier'];
    freeDelivery = json['free_delivery'];
    description = json['description'];
    specifications = json['specifications'];
    productDetails = json['product_details'];
    if (json['details'] != null) {
      details = List<Details>.from(json['details'].map((v) => Details.fromJson(v)));
    }
    if (json['amenities'] != null) {
      amenities = List<Amenities>.from(json['amenities'].map((v) => Amenities.fromJson(v)));
    }
    event = json['event'] != null ? List<String>.from(json['event']) : null;
    rating = json['rating'];
    tags = json['tags'] != null ? List<String>.from(json['tags']) : null;
    categories = json['categories'] != null ? List<String>.from(json['categories']) : null;
    addOns = json['addOns'] != null ? List<String>.from(json['addOns']) : null;
    if (json['weight'] != null) {
      weight = List<Weight>.from(json['weight'].map((v) => Weight.fromJson(v)));
    }
    brand = json['brand'];
    color = json['color'] != null ? List<String>.from(json['color']) : null;
    altTexts = json['alt_texts'] != null ? AltTexts.fromJson(json['alt_texts']) : null;
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
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['productId'] = productId;
    data['prices'] = prices;
    data['pp'] = pp;
    data['discount_price'] = discountPrice;
    data['imageLink'] = imageLink;
    data['title'] = title;
    data['images'] = images;
    data['is_message'] = isMessage;
    data['is_image'] = isImage;
    data['is_veg'] = isVeg;
    data['is_courier'] = isCourier;
    data['free_delivery'] = freeDelivery;
    data['description'] = description;
    data['specifications'] = specifications;
    data['product_details'] = productDetails;
    if (details != null) data['details'] = details!.map((v) => v.toJson()).toList();
    if (amenities != null) data['amenities'] = amenities!.map((v) => v.toJson()).toList();
    data['event'] = event;
    data['rating'] = rating;
    data['tags'] = tags;
    data['categories'] = categories;
    data['addOns'] = addOns;
    if (weight != null) data['weight'] = weight!.map((v) => v.toJson()).toList();
    data['brand'] = brand;
    data['color'] = color;
    if (altTexts != null) data['alt_texts'] = altTexts!.toJson();
    data['active'] = active;
    data['meta_tag'] = metaTag;
    data['meta_description'] = metaDescription;
    data['og_title'] = ogTitle;
    data['og_description'] = ogDescription;
    data['avg_rating'] = avgRating;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['has_balloon_number'] = hasBalloonNumber;
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

class Amenities {
  String? delivery;

  Amenities({this.delivery});

  Amenities.fromJson(Map<String, dynamic> json) {
    delivery = json['Delivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Delivery'] = this.delivery;
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
  AltTexts();

  AltTexts.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    return {};
  }
}

