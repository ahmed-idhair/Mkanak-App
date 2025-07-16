class WorkingTimes {
  int? id;
  // int? userId;
  // int? day;
  String? fromTime;
  String? toTime;
  String? createdAt;
  String? updatedAt;
  String? dayName;

  WorkingTimes({
    this.id,
    // this.userId,
    // this.day,
    this.fromTime,
    this.toTime,
    this.createdAt,
    this.updatedAt,
    this.dayName,
  });

  factory WorkingTimes.fromJson(Map<String, dynamic> json) => WorkingTimes(
    id: json["id"],
    // userId: json["user_id"],
    // day: json["day"],
    fromTime: json["from_time"],
    toTime: json["to_time"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    dayName: json["day_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    // "user_id": userId,
    // "day": day,
    "from_time": fromTime,
    "to_time": toTime,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "day_name": dayName,
  };
}
