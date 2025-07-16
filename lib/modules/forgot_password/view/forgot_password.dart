import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../app/extensions/color.dart';
import '../../../app/translations/lang_keys.dart';
import '../../../app/widgets/app_bar/custom_app_bar.dart';
import '../../../app/widgets/buttons/app_button.dart';
import '../../../app/widgets/forms/app_custom_text.dart';
import '../../../app/widgets/forms/app_phone_input.dart';
import '../../../app/widgets/forms/app_text_field.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  ForgotPasswordController controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: LangKeys.forgotPasswordStr.tr,
        bgColor: Colors.white,
        titleColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              16.verticalSpace,
              AppCustomText(
                text: LangKeys.pleaseEnterYourEmailToResetThePassword.tr,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: HexColor("000B12").withValues(alpha: 0.93),
              ),
              28.verticalSpace,
              AppPhoneInput(
                controller: controller.phoneController,
                labelText: LangKeys.mobileNumber.tr,
                onPhoneChanged: controller.onPhoneChanged,
              ),
              80.verticalSpace,
              Obx(
                () => AppButton(
                  text: LangKeys.send.tr,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.validation,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
