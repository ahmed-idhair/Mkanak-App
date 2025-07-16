import 'order/order.dart';

class Rate {
  int? id;
  double? rating;
  String? comment;
  dynamic userId;
  String? createdAt;
  String? updatedAt;
  dynamic orderId;
  Order? order;

  Rate({
    this.id,
    this.rating,
    this.comment,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.orderId,
    this.order,
  });


  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
    id: json["id"],
    rating: double.parse(json["rating"].toString()),
    comment: json["comment"],
    userId: json["user_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    orderId: json["order_id"],
    order: json["order"] != null ? Order.fromJson(json["order"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rating": rating,
    "comment": comment,
    "user_id": userId,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "order_id": orderId,
    "order": order?.toJson(),
  };
}
