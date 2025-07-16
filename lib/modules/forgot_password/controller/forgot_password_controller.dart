import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/translations/lang_keys.dart';
import '../../../app/widgets/common/app_bottom_sheet.dart';
import '../../../app/widgets/feedback/app_toast.dart';
import '../../../app/widgets/forms/app_phone_input.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../base_controller.dart';

class ForgotPasswordController extends BaseController {
  final phoneController = TextEditingController();
  final RxBool isLoading = false.obs;
  final phoneFocusNode = FocusNode();

  PhoneData? currentPhoneData;

  void onPhoneChanged(PhoneData phoneData) {
    currentPhoneData = phoneData;
  }

  @override
  void dispose() {
    phoneController.dispose();
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
    forgotPassword(validationResult.fullNumber);
  }

  Future<void> forgotPassword(String fullNumber) async {
    try {
      Map<String, String> body = {"phone_number": fullNumber};
      isLoading(true);
      final result = await httpService.request(
        url: ApiConstant.forgotPassword,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var data = ApiResponse.fromJson(result.data);
        if (data.isSuccess == true) {
          AppToast.success(data.message ?? "");
          // if (data.data != null &&
          //     data.data?.verification != null &&
          //     data.data?.verification?.token != null &&
          //     data.data?.verification?.token != "") {
          Get.toNamed(
            AppRoutes.verificationCode,
            arguments: {
              "from": AppRoutes.forgotPassword,
              "phone_number": fullNumber,
              // "token": data.data?.verification?.token,
            },
          );
          // }
        } else {
          AppToast.error(data.message ?? "");
          // showErrorBottomSheet(data.message ?? "");
        }
      }
    } finally {
      isLoading(false);
    }
  }
}
