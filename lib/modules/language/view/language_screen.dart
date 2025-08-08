import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/config/app_theme.dart';
import '../../../app/extensions/color.dart';
import '../../../app/translations/lang_keys.dart';
import '../../../app/widgets/app_bar/custom_app_bar.dart';
import '../../../app/widgets/buttons/app_button.dart';
import '../../../app/widgets/forms/app_custom_text.dart';
import '../../language_controller.dart';
import '../controller/language_screen_controller.dart';
import 'language_model.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  var controller = Get.put(LanguageScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.language.tr),
      // bottomSheet: Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      //   child: ,
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 24.h),
            _buildLanguageOptions(),
            SizedBox(height: 34.h),
            AppButton(
              text: LangKeys.save.tr,
              onPressed: () {
                if (controller.selectedLanguage.value !=
                    controller.storage.getLanguageCode()) {
                  // if(controller.isAuth()){
                  //   Get.find<SettingsPageController>().updateLanguage("ar");
                  // }else{
                  Get.find<LanguageController>().updateLocale(
                    controller.selectedLanguage.value,
                  );
                  // }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCustomText(
          text: LangKeys.chooseLanguage.tr,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: HexColor("#1D2939"),
        ),
        SizedBox(height: 4.h),
        AppCustomText(
          text: LangKeys.chooseLanguageInfo.tr,
          fontSize: 14.sp,
          color: HexColor("#667085"),
        ),
      ],
    );
  }

  Widget _buildLanguageOptions() {
    return Obx(
      () => Column(
        children: [
          // Arabic Option
          _buildLanguageOption(
            language: controller.languages[0],
            isSelected: controller.selectedLanguage.value == 'ar',
            onTap: () => controller.selectLanguage('ar'),
          ),
          SizedBox(height: 16.h),
          // English Option
          _buildLanguageOption(
            language: controller.languages[1],
            isSelected: controller.selectedLanguage.value == 'en',
            onTap: () => controller.selectLanguage('en'),
          ),
          // SizedBox(height: 16.h),
          // _buildLanguageOption(
          //   language: controller.languages[2],
          //   isSelected: controller.selectedLanguage.value == 'system',
          //   onTap: () => controller.selectLanguage('system'),
          // ),
          // // System Choice Option
          // _buildSystemChoiceOption(
          //   isSelected: controller.selectedLanguage.value == 'system',
          //   onTap: () => controller.selectSystemChoice(),
          // ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required LanguageModel language,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppTheme.primaryColor.withValues(alpha: 0.1)
                  : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey,
            width: isSelected ? 1.h : 0.h,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          children: [
            // Flag
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF3F4F6),
              ),
              child: ClipOval(child: _buildFlagWidget(language.code)),
            ),
            SizedBox(width: 12.w),
            // Language Name
            Expanded(
              child: AppCustomText(
                text: language.name,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: HexColor("#1D2939"),
              ),
            ),

            // Selection Indicator
            // if (isSelected)
            //   Container(
            //     width: 24.w,
            //     height: 24.h,
            //     decoration: BoxDecoration(
            //       color: AppTheme.primaryColor,
            //       shape: BoxShape.circle,
            //     ),
            //     child: Icon(Icons.check, color: Colors.white, size: 16.r),
            //   ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagWidget(String languageCode) {
    // Since we can't load actual flag images, we'll use colored containers with text
    switch (languageCode) {
      case 'ar':
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF006C35), Color(0xFF006C35)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(child: AppCustomText(text: "🇸🇦", fontSize: 20.sp)),
        );
      case 'en':
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E40AF), Color(0xFFDC2626)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(child: AppCustomText(text: "🇺🇸", fontSize: 20.sp)),
        );
      default:
        return Container(
          color: Color(0xFFE5E7EB),
          child: Icon(Icons.language, color: Color(0xFF6B7280), size: 20.sp),
        );
    }
  }
}
