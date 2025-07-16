import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mkanak/core/models/countries.dart';
import '../../../app/config/app_theme.dart';
import '../../../app/extensions/color.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/translations/lang_keys.dart';
import '../../../app/utils/app_utils.dart';
import '../../../app/widgets/buttons/app_button.dart';
import '../../../app/widgets/common/app_loading_view.dart';
import '../../../app/widgets/forms/app_checkbox.dart';
import '../../../app/widgets/forms/app_custom_text.dart';
import '../../../app/widgets/forms/app_drop_down.dart';
import '../../../app/widgets/forms/app_phone_input.dart';
import '../../../app/widgets/forms/app_text_field.dart';
import '../controller/sign_up_controller.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: CustomAppBar(title: LangKeys.signUp.tr),
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
                16.verticalSpace,
                AppCustomText(
                  text: LangKeys.createAnAccount.tr,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                ),
                24.verticalSpace,
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRoleButton(
                        icon: Icons.person,
                        label: LangKeys.provider.tr,
                        role: '1',
                        isSelected: controller.selectedRole.value == '1',
                        onTap: () => controller.selectRole('1'),
                        color: Colors.amber,
                      ),
                      24.horizontalSpace,
                      _buildRoleButton(
                        icon: Icons.person_outline,
                        label: LangKeys.user.tr,
                        role: '0',
                        isSelected: controller.selectedRole.value == '0',
                        onTap: () => controller.selectRole('0'),
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ),
                18.verticalSpace,
                AppTextField(
                  label: LangKeys.fullName.tr,
                  hintText: LangKeys.enterFullName.tr,
                  controller: controller.fullNameController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                18.verticalSpace,
                GetBuilder<SignUpController>(
                  id: "selectCountry",
                  builder: (controller) {
                    if (controller.isLoadingCountry.isTrue) {
                      return const AppLoadingView();
                    }
                    return AppDropdown<Countries>(
                      label: LangKeys.chooseCountry.tr,
                      items: controller.items,
                      isRequired: true,
                      selectedItem: controller.selectCountry.value,
                      itemAsString: (country) => country.name ?? "",
                      onChanged: (value) {
                        if (value != null) {
                          controller.selectCountry.value = value;
                          controller.update(['selectCountry']);
                        }
                      },
                    );
                  },
                ),
                18.verticalSpace,
                AppPhoneInput(
                  controller: controller.phoneController,
                  // hintText: 'Enter your phone number',
                  labelText: LangKeys.mobileNumber.tr,
                  // initialPhoneNumber: "+962790123456", // Pass existing number here
                  onPhoneChanged: controller.onPhoneChanged,
                ),
                18.verticalSpace,
                AppTextField(
                  label: LangKeys.email.tr,
                  hintText: LangKeys.enterEmail.tr,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                18.verticalSpace,
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
                18.verticalSpace,
                Obx(
                  () => AppTextField(
                    label: LangKeys.confirmPassword.tr,
                    hintText: LangKeys.enterConfirmPassword.tr,
                    controller: controller.confirmPasswordController,
                    obscureText: !controller.isPasswordVisible.value,
                    textInputAction: TextInputAction.done,
                    suffixIcon:
                        controller.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                    onSuffixIconPressed: controller.togglePasswordVisibility,
                  ),
                ),
                11.verticalSpace,
                Row(
                  children: [
                    Obx(
                      () => AppCheckbox(
                        value: controller.isAgreeTerms.value,
                        onChanged: (value) {
                          controller.isAgreeTerms(value);
                        },
                        label: "",
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text.rich(
                          textAlign: TextAlign.start,
                          TextSpan(
                            text: LangKeys.iHaveReadAndAgreeToThe.tr,
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: LangKeys.termsOfService.tr,
                                style: GoogleFonts.roboto(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  color: AppTheme.primaryColor,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.toNamed(
                                          AppRoutes.pageView,
                                          arguments: {
                                            "title":
                                                LangKeys.termsAndConditions.tr,
                                            "key": "terms-conditions",
                                          },
                                        );
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //SizedBox
                  ],
                ),
                31.verticalSpace,
                Obx(
                  () => AppButton(
                    text: LangKeys.signUp.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.validate,
                  ),
                ),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppCustomText(
                      text: LangKeys.alreadyHaveAnAccount.tr,
                      fontSize: 14.0.sp,
                      color: HexColor("1E232C"),
                      fontWeight: FontWeight.w400,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: AppCustomText(
                        text: LangKeys.signIn.tr,
                        fontSize: 14.0.sp,
                        color: AppTheme.primaryColor,
                        // decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required IconData icon,
    required String label,
    required String role,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            // width: 100,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.transparent,
              border: Border.all(
                color: isSelected ? color : HexColor("999999"),
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : HexColor("999999"),
              size: 28.r,
            ),
          ),
          const SizedBox(height: 4),
          AppCustomText(
            text: label,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? color : HexColor("999999"),
          ),
        ],
      ),
    );
  }
}
