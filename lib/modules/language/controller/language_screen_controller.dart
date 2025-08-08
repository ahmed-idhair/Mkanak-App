// Language Selection Controller

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../base_controller.dart';
import '../view/language_model.dart';

class LanguageScreenController extends BaseController {
  var selectedLanguage = 'en'.obs;
  var isLoading = false.obs;

  final List<LanguageModel> languages = [
    LanguageModel(name: 'العربية', code: 'ar', flagAsset: ''),
    LanguageModel(name: 'English', code: 'en', flagAsset: ''),
  ];

  @override
  void onInit() {
    super.onInit();
    // Load current language
    selectedLanguage.value = storage.getLanguageCode();
  }

  void selectLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
  }

  void selectSystemChoice() {
    selectedLanguage.value = 'system';
  }

  void saveLanguage() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    if (selectedLanguage.value == 'system') {
      // Use system language
      Get.updateLocale(Get.deviceLocale!);
    } else {
      // Use selected language
      Locale newLocale = Locale(selectedLanguage.value);
      Get.updateLocale(newLocale);
    }

    isLoading.value = false;

    Get.snackbar(
      "Success",
      "Language changed successfully. App will restart to take effect.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );

    // Navigate back after a delay
    Future.delayed(Duration(seconds: 2), () {
      Get.back();
    });
  }
}
