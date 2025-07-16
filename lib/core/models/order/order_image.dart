class OrderImage {
  int? id;
  dynamic orderId;
  String? imageUrl;

  OrderImage({
    this.id,
    this.orderId,
    this.imageUrl,
  });

  factory OrderImage.fromJson(Map<String, dynamic> json) => OrderImage(
    id: json["id"],
    orderId: json["order_id"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "image_url": imageUrl,
  };
}
