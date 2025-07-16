import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/translations/lang_keys.dart';
import '../../../app/widgets/common/app_bottom_sheet.dart';
import '../../../app/widgets/feedback/app_toast.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/user/user_data.dart';
import '../../base_controller.dart';

/// Controller for the Change Password screen
/// Handles password validation and API communication
class NewPasswordController extends BaseController {
  // Controllers for form fields
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable variables for UI state
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  /// Toggles password visibility for all password fields
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is removed
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  /// Validates the password fields before submission
  void validation() {
    // Check if new password is entered
    if (newPasswordController.text.isEmpty) {
      showErrorBottomSheet(LangKeys.enterNewPassword.tr);
      return;
    }

    // Check if confirm password is entered
    if (confirmPasswordController.text.isEmpty) {
      showErrorBottomSheet(LangKeys.enterConfirmNewPassword.tr);
      return;
    }

    // Check if new password and confirm password match
    if (confirmPasswordController.text != newPasswordController.text) {
      showErrorBottomSheet(LangKeys.passwordNotMatch.tr);
      return;
    }

    // If all validations pass, proceed to change password
    resetPassword();
  }

  /// Calls API to change the user's password
  Future<void> resetPassword() async {
    try {
      // Prepare request body
      Map<String, dynamic> body = {
        "phone_number": Get.arguments['phone_number'],
        "code": Get.arguments['code'],
        "password": newPasswordController.text.trim(),
        "password_confirmation": confirmPasswordController.text.trim(),
      };

      // Show loading indicator
      isLoading(true);
      // Make API request
      final result = await httpService.request(
        url: ApiConstant.resetPassword,
        method: Method.POST,
        params: body,
      );
      // Process response
      if (result != null) {
        var data = ApiResponse.fromJson(result.data);
        if (data.isSuccess == true) {
          showSuccessBottomSheet(
            data.message ?? "",
            textBtn: LangKeys.continueText.tr,
            onClick: () {
              // storage.setUserToken(data.data!.token!);
              // storage.setUser(data.data!.user!);
              Get.offAllNamed(AppRoutes.signIn);
            },
          );
        } else {
          showErrorBottomSheet(data.message ?? "");
        }
      }
    } finally {
      // Hide loading indicator regardless of outcome
      isLoading(false);
    }
  }
}
