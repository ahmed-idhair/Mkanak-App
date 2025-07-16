import 'package:mkanak/core/models/user/user.dart';

class OrderOffer {
  int? id;
  dynamic orderId;
  dynamic providerId;
  String? description;
  dynamic price;
  dynamic status;
  String? createdAt;
  String? updatedAt;
  User? provider;

  OrderOffer({
    this.id,
    this.orderId,
    this.providerId,
    this.description,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.provider,
  });

  factory OrderOffer.fromJson(Map<String, dynamic> json) => OrderOffer(
    id: json["id"],
    orderId: json["order_id"],
    providerId: json["provider_id"],
    description: json["description"],
    price: json["price"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    provider: json["provider"] != null ? User.fromJson(json["provider"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "provider_id": providerId,
    "description": description,
    "price": price,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "provider": provider?.toJson(),
  };
}
