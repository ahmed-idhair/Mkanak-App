
import 'user.dart';
import 'verification.dart';

class UserData {
  User? user;
  // Verification? verification;
  String? token;

  UserData({this.user, this.token});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    user: User.fromJson(json["user"]),
    // verification: Verification.fromJson(json["verification"]),
    token: json["access_token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    // "verification": verification?.toJson(),
    "access_token": token,
  };
}
