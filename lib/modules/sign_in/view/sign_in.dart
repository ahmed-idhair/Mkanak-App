import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../app/config/app_theme.dart';
import '../../../app/extensions/color.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/translations/lang_keys.dart';
import '../../../app/utils/app_utils.dart';
import '../../../app/widgets/buttons/app_button.dart';
import '../../../app/widgets/forms/app_custom_text.dart';
import '../../../app/widgets/forms/app_phone_input.dart';
import '../../../app/widgets/forms/app_text_field.dart';
import '../controller/sign_in_controller.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  SignInController controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                30.verticalSpace,
                SvgPicture.asset(
                  AppUtils.getIconPath("ic_logo_auth"),
                  width: 100.w,
                  height: 100.h,
                ),
                24.verticalSpace,
                AppCustomText(
                  text: LangKeys.logInToYourAccount.tr,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
                10.verticalSpace,
                AppCustomText(
                  text: LangKeys.welcomeBackPleaseEnterYourDetails.tr,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: HexColor("747474"),
                ),
                40.verticalSpace,
                AppPhoneInput(
                  controller: controller.phoneController,
                  // hintText: 'Enter your phone number',
                  labelText: LangKeys.mobileNumber.tr,
                  // initialPhoneNumber: "+962790123456", // Pass existing number here
                  onPhoneChanged: controller.onPhoneChanged,
                ),

                20.verticalSpace,
                Obx(
                  () => AppTextField(
                    label: LangKeys.password.tr,
                    hintText: LangKeys.enterPassword.tr,
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    textInputAction: TextInputAction.done,
                    suffixIcon:
                        controller.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                    onSuffixIconPressed: controller.togglePasswordVisibility,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.forgotPassword);
                      // Get.toNamed(AppRoutes.newOrder);
                    },
                    child: AppCustomText(
                      text: LangKeys.forgotPassword.tr,
                      fontSize: 13.0.sp,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                    ),
                  ),
                ),
                20.verticalSpace,
                Obx(
                  () => AppButton(
                    text: LangKeys.signIn.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.validation,
                  ),
                ),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppCustomText(
                      text: LangKeys.doNotHaveAnAccount.tr,
                      fontSize: 14.0.sp,
                      color: HexColor("1E232C"),
                      fontWeight: FontWeight.w400,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.signUp);
                      },
                      child: AppCustomText(
                        text: LangKeys.signUp.tr,
                        fontSize: 14.0.sp,
                        color: AppTheme.primaryColor,
                        // decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,
                AppButton(
                  text: LangKeys.continueAsAGuest.tr,
                  variant: ButtonVariant.outline,
                  isLoading: false,
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.home);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
