import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../app/routes/app_routes.dart';
import 'base_controller.dart';
class LanguageController extends BaseController {
  var isArabicSelected = false.obs;
  var isEnglishSelected = false.obs;

  RxBool isCheckNot = true.obs;
  final RxString locale = Get.locale.toString().obs;
  final Map<String, dynamic> optionsLocales = {
    'en': {'languageCode': 'en', 'countryCode': 'US', 'description': 'English'},
    'ar': {'languageCode': 'ar', 'countryCode': 'PS', 'description': 'Arabic'}
  };

  void updateLocale(String key) {
    final String languageCode = optionsLocales[key]['languageCode'];
    final String countryCode = optionsLocales[key]['countryCode'];
    // Update App
    print("Log updateLocale languageCode $languageCode");
    Get.updateLocale(Locale(languageCode));
    // Update obs
    locale.value = Get.locale.toString();
    // Update storage
    storage.write('languageCode', languageCode);
    storage.write('countryCode', countryCode);
    storage.languageCode = languageCode;
    storage.countryCode = countryCode;
    print("Log after updateLocale languageCode ${storage.getLanguageCode()}");
    Get.offAllNamed(AppRoutes.splash);
  }

  void toggle() => isCheckNot.value = isCheckNot.value ? false : true;

  void updateSwitch(bool value) {
    isCheckNot.value = value;
  }
}
