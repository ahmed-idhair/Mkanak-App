import '../order/order.dart';

class Transaction {
  int? id;
  dynamic orderId;
  double? total;
  dynamic status;
  String? createdAt;
  String? updatedAt;
  Order? order;

  Transaction({
    this.id,
    this.orderId,
    this.total,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.order,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    orderId: json["order_id"],
    total: json["total"] != null ? double.parse(json["total"].toString()) : 0.0,
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    order: json["order"] != null ? Order.fromJson(json["order"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "total": total,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "order": order?.toJson(),
  };
}
