class User {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? phoneNumberVerifiedAt;
  String? avatar;
  dynamic status;
  String? type;
  dynamic ratingAverage;
  dynamic country;
  dynamic countryId;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.countryId,
    this.country,
    this.ratingAverage,
    this.phoneNumber,
    this.phoneNumberVerifiedAt,
    this.avatar,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    country: json["country"],
    countryId: json["country_id"],
    phoneNumber: json["phone_number"],
    phoneNumberVerifiedAt: json["phone_number_verified_at"],
    avatar: json["avatar"],
    type: json["type"].toString(),
    ratingAverage: json["rating_average"].toString(),
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone_number": phoneNumber,
    "phone_number_verified_at": phoneNumberVerifiedAt,
    "avatar": avatar,
    "country_id": countryId,
    "type": type,
    "rating_average": ratingAverage,
    "status": status,
    "country": country,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
