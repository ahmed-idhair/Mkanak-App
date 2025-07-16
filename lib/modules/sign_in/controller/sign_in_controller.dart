import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/widgets/common/app_bottom_sheet.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/translations/lang_keys.dart';
import '../../../app/widgets/feedback/app_toast.dart';
import '../../../app/widgets/forms/app_phone_input.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/user/user_data.dart';
import '../../base_controller.dart';

class SignInController extends BaseController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  var rememberMe = false.obs;
  var isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;
  final phoneFocusNode = FocusNode();

  PhoneData? currentPhoneData;

  // final FCMService _fcmService = FCMService();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void onPhoneChanged(PhoneData phoneData) {
    currentPhoneData = phoneData;
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> validation() async {
    if (phoneController.text.isEmpty) {
      showErrorBottomSheet(LangKeys.enterMobileNumber.tr);
      return;
    }
    final validationResult = await AppPhoneInput.validateMobile(
      currentPhoneData!,
    );
    if (!validationResult.isValid) {
      showErrorBottomSheet(LangKeys.mobileNumberInvalid.tr);
      return;
    }

    if (passwordController.text.isEmpty) {
      showErrorBottomSheet(LangKeys.enterPassword.tr);
      // AppToast.error(LangKeys.enterPassword.tr);
      return;
    }

    login(validationResult.fullNumber);
  }

  Future<void> login(String fullNumber) async {
    try {
      Map<String, String> body = {
        "phone_number": fullNumber,
        "password": passwordController.text.trim(),
      };
      isLoading(true);
      final result = await httpService.request(
        url: ApiConstant.login,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var data = ApiResponse.fromJsonModel(result.data, UserData.fromJson);
        if (data.isSuccess == true) {
          // AppToast.success(data.message ?? "");
          if (data.data != null) {
            if (data.data?.user?.phoneNumberVerifiedAt != null) {
              if (data.data?.user?.type.toString() == "0") {
                storage.setUserToken(data.data!.token!);
                storage.setUser(data.data!.user!);
                Get.offAllNamed(AppRoutes.home);
              } else {
                storage.setUserToken(data.data!.token!);
                storage.setUser(data.data!.user!);
                Get.offAllNamed(AppRoutes.pHome);
              }
            } else {
              Get.toNamed(
                AppRoutes.verificationCode,
                arguments: {
                  "from": AppRoutes.signIn,
                  "phone_number": fullNumber,
                  // "token": data.data?.verification?.token,
                },
              );
            }
          }
        } else {
          showErrorBottomSheet(data.message ?? "");
          // showErrorBottomSheet(data.message ?? "");
        }
      }
    } finally {
      isLoading(false);
    }
  }
}
