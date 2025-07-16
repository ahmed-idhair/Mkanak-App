class Categories {
  int? id;
  String? title;
  String? description;
  String? image;

  Categories({this.id, this.title, this.description, this.image});

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
  };
}
