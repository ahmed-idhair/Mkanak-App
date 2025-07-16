class Countries {
  int? id;
  String? name;
  String? code;
  String? currency;

  Countries({this.id, this.name, this.code, this.currency});

  factory Countries.fromJson(Map<String, dynamic> json) => Countries(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "currency": currency,
  };
}
