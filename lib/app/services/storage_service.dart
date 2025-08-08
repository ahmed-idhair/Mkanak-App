
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/models/user/user.dart';

class StorageService extends GetxService {
  String? languageCode;
  String? countryCode;
  String? deviceId;
  String? version;
  String? timezone = "Asia/Amman";
  String? appVersion = "1.0";

  // Storage keys
  static const String USER_KEY = "user_mkanak";
  static const String TOKEN_KEY = "token_mkanak";
  static const String LANGUAGE_CODE_KEY = "languageCode";

  Future<StorageService> init() async {
    await GetStorage.init();
    languageCode = GetStorage().read(LANGUAGE_CODE_KEY);
    countryCode = GetStorage().read('countryCode');
    if (languageCode == null || languageCode == "") {
      languageCode = Get.deviceLocale!.languageCode;
      countryCode = Get.deviceLocale!.countryCode;
    }
    return this;
  }

  User? getUser() {
    if (GetStorage().read(USER_KEY) != null) {
      return User.fromJson(GetStorage().read(USER_KEY));
    }
    return null;
  }

  String getLanguageCode() {
    if (GetStorage().read(LANGUAGE_CODE_KEY) != null) {
      return GetStorage().read(LANGUAGE_CODE_KEY);
    }
    return "ar";
  }

  String? getToken() {
    if (GetStorage().read(TOKEN_KEY) != null) {
      return GetStorage().read(TOKEN_KEY);
    }
    return null;
  }

  void setUserToken(String value) {
    GetStorage().write(TOKEN_KEY, value);
  }

  bool isAuth() {
    if (GetStorage().read(TOKEN_KEY) != null &&
        GetStorage().read(USER_KEY) != null) {
      return true;
    }
    return false;
  }

  void clearApp() {
    GetStorage().remove(USER_KEY);
    GetStorage().remove(TOKEN_KEY);
  }

  void write(String key, dynamic value) {
    GetStorage().write(key, value);
  }


  void setUser(User value) {
    GetStorage().write(
      USER_KEY,
      User(
        id: value.id,
        email: value.email,
        avatar: value.avatar,
        name: value.name,
        status: value.status,
        createdAt: value.createdAt,
        phoneNumber: value.phoneNumber,
        type: value.type.toString(),
        updatedAt: value.updatedAt,
        countryId: value.countryId
      ).toJson(),
    );
  }
}
