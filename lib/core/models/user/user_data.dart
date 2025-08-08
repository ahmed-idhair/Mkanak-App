
import 'user.dart';

class UserData {
  User? user;
  String? token;

  UserData({this.user, this.token});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    user: User.fromJson(json["user"]),
    token: json["access_token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "access_token": token,
  };
}
