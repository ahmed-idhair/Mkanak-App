import 'package:mkanak/core/models/categories.dart';
import 'package:mkanak/core/models/user/user.dart';

import 'order_image.dart';
import 'order_offer.dart';

class Order {
  int? id;
  dynamic userId;
  dynamic providerId;
  dynamic serviceId;
  dynamic timeType;
  bool? isRated;
  bool? canRate;
  bool? canMakeOffer;
  bool? canUpdateOffer;
  String? date;
  String? time;
  String? description;
  dynamic paymentMethod;
  String? address;
  String? latitude;
  String? longitude;
  dynamic status;
  String? createdAt;
  String? updatedAt;
  Categories? service;
  User? provider;
  User? user;
  OrderOffer? myOffer;
  List<OrderOffer>? orderOffers;
  List<OrderImage>? orderImages;

  Order({
    this.id,
    this.userId,
    this.providerId,
    this.serviceId,
    this.timeType,
    this.date,
    this.time,
    this.isRated,
    this.canRate,
    this.canMakeOffer,
    this.canUpdateOffer,
    this.description,
    this.paymentMethod,
    this.address,
    this.latitude,
    this.longitude,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.service,
    this.provider,
    this.user,
    this.myOffer,
    this.orderOffers,
    this.orderImages,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    // userId: json["user_id"],
    providerId: json["provider_id"],
    serviceId: json["service_id"],
    timeType: json["time_type"],
    date: json["date"],
    time: json["time"],
    isRated: json["is_rated"],
    canRate: json["can_rate"],
    canMakeOffer: json["can_make_offer"],
    canUpdateOffer: json["can_update_offer"],
    description: json["description"],
    paymentMethod: json["payment_method"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    myOffer:
        json["my_offer"] != null ? OrderOffer.fromJson(json["my_offer"]) : null,
    service:
        json["service"] != null ? Categories.fromJson(json["service"]) : null,
    provider: json["provider"] != null ? User.fromJson(json["provider"]) : null,
    user: json["user"] != null ? User.fromJson(json["user"]) : null,
    orderOffers:
        json["order_offers"] != null
            ? List<OrderOffer>.from(
              json["order_offers"].map((x) => OrderOffer.fromJson(x)),
            )
            : [],
    orderImages:
        json["order_images"] != null
            ? List<OrderImage>.from(
              json["order_images"].map((x) => OrderImage.fromJson(x)),
            )
            : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "provider_id": providerId,
    "service_id": serviceId,
    "time_type": timeType,
    "date": date,
    "time": time,
    "description": description,
    "payment_method": paymentMethod,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "service": service?.toJson(),
    "order_offers": List<dynamic>.from(orderOffers!.map((x) => x)),
    "order_images": List<dynamic>.from(orderImages!.map((x) => x.toJson())),
  };
}
