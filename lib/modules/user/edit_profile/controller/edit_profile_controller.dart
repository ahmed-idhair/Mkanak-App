import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart'
    as intl_phone;
import 'package:mkanak/core/models/user/user_data.dart';
import 'package:mkanak/modules/provider/p_settings_page/controller/p_settings_page_controller.dart';
import '../../../../app/translations/lang_keys.dart';
import '../../../../app/widgets/common/app_bottom_sheet.dart';
import '../../../../app/widgets/feedback/app_toast.dart';
import '../../../../app/widgets/forms/app_phone_input.dart';
import '../../../../core/api/api_constant.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/api/http_service.dart';
import '../../../../core/models/countries.dart';
import '../../../../core/models/user/user.dart';
import '../../../base_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../../settings_page/controller/settings_page_controller.dart';

class EditProfileController extends BaseController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();

  final emailController = TextEditingController();
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isAgreeTerms = false.obs;
  final phoneFocusNode = FocusNode();

  // final RxString phoneCode = '962'.obs;
  // final RxString countryCode = 'JO'.obs;
  // final RxString flag = '🇯🇴'.obs;
  String? fullMobile;

  User? user;

  final RxBool isLoadingCountry = false.obs;

  var items = <Countries>[].obs;
  Rx<Countries> selectCountry =
      Countries(name: LangKeys.chooseCountry.tr, id: 0).obs;

  @override
  void onInit() {
    super.onInit();
    user = storage.getUser();
    fullNameController.text = user?.name ?? "";
    emailController.text = user?.email ?? "";
    parsePhoneNumber(user?.phoneNumber);
    countries();
  }

  Future<void> parsePhoneNumber(String? mobile) async {
    intl_phone.PhoneNumber phoneNumber = await intl_phone
        .PhoneNumber.getRegionInfoFromPhoneNumber(mobile ?? "");
    if (phoneNumber.phoneNumber != null) {
      phoneController.text = phoneNumber.phoneNumber!.replaceAll(
        "+${phoneNumber.dialCode}",
        "",
      );

      print('Log dialCode ${phoneNumber.dialCode}');
      print('Log isoCode ${phoneNumber.isoCode}');
      currentPhoneData = PhoneData(
        phoneNumber: phoneController.text,
        phoneCode: phoneNumber.dialCode ?? "970",
        countryCode: phoneNumber.isoCode ?? "PS",
        flag: currentPhoneData?.flag ?? "",
      );
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  PhoneData? currentPhoneData;

  // Update current phone data when phone changes
  void onPhoneChanged(PhoneData phoneData) {
    currentPhoneData = phoneData;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> validation() async {
    if (fullNameController.text.isEmpty) {
      showErrorBottomSheet(LangKeys.enterFullName.tr);
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
    // if (phoneController.text.isEmpty) {
    //   AppToast.error(LangKeys.enterMobileNumber.tr);
    //   return;
    // }

    // تحديث رقم الهاتف في currentPhoneData إذا تم تغييره في حقل الإدخال

    // final validationResult = await AppPhoneInput.validateMobile(
    //   currentPhoneData!,
    // );
    // if (!validationResult.isValid) {
    //   AppToast.error(LangKeys.mobileNumberInvalid.tr);
    //   return;
    // }
    if (selectCountry.value.id == 0) {
      showErrorBottomSheet(LangKeys.chooseCountry.tr);
      return;
    }

    updateProfile();
  }

  Future<void> updateProfile() async {
    try {
      Map<String, dynamic> body = {
        "name": fullNameController.text,
        "email": emailController.text.trim(),
        // "phone_number": fullMobile,
        "country_id": selectCountry.value.id,
      };
      isLoading(true);

      final result = await httpService.request(
        url: ApiConstant.updateProfile,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var data = ApiResponse.fromJsonModel(result.data, UserData.fromJson);
        if (data.isSuccess == true) {
          storage.setUser(data.data!.user!);
          Get.find<ProfileController>().updateUser();
          if (Get.isRegistered<SettingsPageController>()) {
            Get.find<SettingsPageController>().updateUser();
          }

          if (Get.isRegistered<PSettingsPageController>()) {
            Get.find<PSettingsPageController>().updateUser();
          }
          showSuccessBottomSheet(
            data.message ?? "",
            onClick: () {
              Get.back();
              Get.back();
            },
          );
          // AppToast.success(data.message ?? "");
        } else {
          showErrorBottomSheet(data.message ?? "");
        }
      }
    } finally {
      isLoading(false);
    }
  }

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
          if (user?.countryId != null) {
            var country = items.firstWhereOrNull(
              (element) => element.id.toString() == user?.countryId.toString(),
            );
            if (country != null) {
              selectCountry.value = country;
            }
          }
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
}
