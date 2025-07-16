import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mkanak/core/models/countries.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/translations/lang_keys.dart';
import '../../../app/widgets/common/app_bottom_sheet.dart';
import '../../../app/widgets/feedback/app_toast.dart';
import '../../../app/widgets/forms/app_phone_input.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/user/user_data.dart';
import '../../base_controller.dart';

class SignUpController extends BaseController {
  var selectedRole = '0'.obs;
  final RxBool isLoadingCountry = false.obs;

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var isAgreeTerms = false.obs;
  final phoneFocusNode = FocusNode();

  PhoneData? currentPhoneData;

  var items = <Countries>[].obs;
  Rx<Countries> selectCountry =
      Countries(name: LangKeys.chooseCountry.tr, id: 0).obs;

  @override
  void onInit() {
    super.onInit();
    countries();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Update current phone data when phone changes
  void onPhoneChanged(PhoneData phoneData) {
    currentPhoneData = phoneData;
  }

  void selectRole(String role) {
    selectedRole.value = role;
  }

  Future<void> validate() async {
    if (fullNameController.text.isEmpty) {
      showErrorBottomSheet(LangKeys.enterFullName.tr);
      return;
    }

    if (selectCountry.value.id == 0) {
      showErrorBottomSheet(LangKeys.chooseCountry.tr);
      return;
    }

    // Validate phone
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

    if (emailController.text.isEmpty) {
      showErrorBottomSheet(LangKeys.enterEmail.tr);
      return;
    }
    if (!GetUtils.isEmail(emailController.text)) {
      showErrorBottomSheet(LangKeys.emailNotValid.tr);
      return;
    }
    if (passwordController.text.isEmpty) {
      showErrorBottomSheet(LangKeys.enterPassword.tr);
      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      showErrorBottomSheet(LangKeys.enterConfirmPassword.tr);
      return;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      showErrorBottomSheet(LangKeys.passwordNotMatch.tr);
      return;
    }

    if (isAgreeTerms.isFalse) {
      showErrorBottomSheet(
        "${LangKeys.iHaveReadAndAgreeToThe.tr} ${LangKeys.termsOfService.tr}",
      );
      return;
    }
    register(validationResult.fullNumber);
    // Continue with form submission
    // submitForm(validationResult.fullNumber);
  }

  Future<void> register(String fullNumber) async {
    try {
      Map<String, dynamic> body = {
        "name": fullNameController.text,
        "email": emailController.text,
        "phone_number": fullNumber,
        "type": selectedRole.value,
        "country_id": selectCountry.value.id,
        "password": passwordController.text.trim(),
        "password_confirmation": confirmPasswordController.text.trim(),
      };
      isLoading(true);
      final result = await httpService.request(
        url: ApiConstant.register,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var data = ApiResponse.fromJsonModel(result.data, UserData.fromJson);
        if (data.isSuccess == true) {
          // AppToast.success(data.message ?? "");
          if (data.data != null) {
            Get.toNamed(
              AppRoutes.verificationCode,
              arguments: {
                "from": AppRoutes.signUp,
                "phone_number": fullNumber,
                "token": data.data?.token,
              },
            );
          }
        } else {
          AppToast.error(data.message ?? "");
          // showErrorBottomSheet(data.message ?? "");
        }
      }
    } finally {
      isLoading(false);
    }
  }

  /// Fetches available feedback reasons from API
  Future<void> countries() async {
    try {
      // Show loading indicator
      isLoadingCountry(true);
      // Make API request
      final result = await httpService.request(
        url: ApiConstant.countries,
        method: Method.GET,
      );
      // Process response
      if (result != null) {
        var response = ApiResponse.fromJsonList<Countries>(
          result.data,
          Countries.fromJson,
        );

        // Update feedback reasons list if successful
        if (response.isSuccess && response.data != null) {
          items.value = response.data!;
        } else {
          // Show error message
          AppToast.error(response.message);
        }
      }
    } finally {
      // Hide loading indicator and update UI
      isLoadingCountry(false);
      update(['selectCountry']);
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }
}
