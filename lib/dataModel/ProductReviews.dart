class ProductReviews {
  String? message;
  int? code;
  List<Data>? data;
  ProductReviews({this.message, this.code, this.data});
  ProductReviews.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Data {
  int? userId;
  String? name;
  String? phone;
  String? email;
  int? rating;
  String? review;
  String? reply;
  String? replyDate;
  String? createdAt;
  Data(
      {this.userId,
        this.name,
        this.phone,
        this.email,
        this.rating,
        this.review,
        this.reply,
        this.replyDate,
        this.createdAt});
  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    rating = json['rating'];
    review = json['review'];
    reply = json['reply'];
    replyDate = json['reply_date'];
    createdAt = json['createdAt'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['reply'] = this.reply;
    data['reply_date'] = this.replyDate;
    data['createdAt'] = this.createdAt;
    return data;
  }
}