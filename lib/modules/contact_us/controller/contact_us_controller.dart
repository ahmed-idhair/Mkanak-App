import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/widgets/common/app_bottom_sheet.dart';
import '../../../app/translations/lang_keys.dart';
import '../../../app/widgets/feedback/app_toast.dart';
import '../../../app/widgets/forms/app_phone_input.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../base_controller.dart';

/// Controller for the Contact Us screen
/// Handles form validation and API communication for contact requests
class ContactUsController extends BaseController {
  // Text controllers for form fields
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final commentController = TextEditingController();
  final phoneController = TextEditingController();

  // Status variable for UI state management
  final RxBool isLoading = false.obs;
  final phoneFocusNode = FocusNode();

  PhoneData? currentPhoneData;

  @override
  void dispose() {
    // Clean up controllers when the widget is removed
    phoneController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    commentController.dispose();
    subjectController.dispose();
    super.dispose();
  }

  /// Validates all form inputs before submission
  Future<void> validation() async {
    // Check if full name is entered
    if (fullNameController.text.isEmpty) {
      showErrorBottomSheet(LangKeys.enterFullName.tr);
      return;
    }

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
    // Check if email is entered
    // if (emailController.text.isEmpty) {
    //   showErrorBottomSheet(LangKeys.enterFullName.tr);
    //   AppToast.error(LangKeys.enterEmail.tr);
    //   return;
    // }

    // Validate email format
    if(emailController.text.isNotEmpty){
      if (!GetUtils.isEmail(emailController.text)) {
        showErrorBottomSheet(LangKeys.emailNotValid.tr);
        return;
      }
    }

    if (subjectController.text.isEmpty) {
      showErrorBottomSheet(LangKeys.enterSubject.tr);
      return;
    } // Ch
    if (commentController.text.isEmpty) {
      showErrorBottomSheet(LangKeys.enterComment.tr);
      return;
    }

    // If all validations pass, proceed with contact request
    contactUs(validationResult.fullNumber);
  }

  /// Sends contact request to API
  Future<void> contactUs(String fullNumber) async {
    try {
      // Prepare request body
      Map<String, String> body = {
        "name": fullNameController.text,
        "email": emailController.text.trim(),
        "phone_number": fullNumber,
        "message": commentController.text,
        "title": subjectController.text,
      };

      // Show loading indicator
      isLoading(true);

      // Make API request
      final result = await httpService.request(
        url: ApiConstant.contactUs,
        method: Method.POST,
        params: body,
      );

      // Process response
      if (result != null) {
        var data = ApiResponse<void>.fromJson(result.data);
        if (data.status == true) {
          // Show success message and reset form
          showSuccessBottomSheet(data.message ?? "");
          // AppToast.success(data.message ?? "");
          _resetForm();
        } else {
          // Show error message
          showErrorBottomSheet(data.message ?? "");
        }
      }
    } finally {
      // Hide loading indicator regardless of outcome
      isLoading(false);
    }
  }
  void onPhoneChanged(PhoneData phoneData) {
    currentPhoneData = phoneData;
  }
  /// Resets all form fields to initial state
  void _resetForm() {
    fullNameController.clear();
    subjectController.clear();
    emailController.clear();
    phoneController.clear();
    commentController.clear();
  }
}
