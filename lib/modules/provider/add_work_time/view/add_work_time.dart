import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/widgets/app_bar/custom_app_bar.dart';
import 'package:mkanak/app/widgets/buttons/app_button.dart';
import 'package:mkanak/modules/provider/add_work_time/controller/add_work_time_controller.dart';

import '../../../../app/widgets/forms/app_custom_text.dart';
import '../../../../app/widgets/forms/app_drop_down.dart';

class AddWorkTime extends StatelessWidget {
  AddWorkTime({super.key});

  final controller = Get.put(AddWorkTimeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(title: LangKeys.addWorkTime.tr),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day Selection Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10.r,
                    offset: Offset(0, 5.h),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppDropdown<DayModel>(
                    label: LangKeys.selectDay.tr,
                    items: controller.daysOfWeek,
                    isRequired: true,
                    selectedItem: controller.selectedDay.value,
                    itemAsString: (country) => country.name ?? "",
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedDay.value = value;
                      }
                    },
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            // Time Selection Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10.r,
                    offset: Offset(0, 5.h),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCustomText(
                    text: LangKeys.workingHours.tr,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  16.verticalSpace,
                  // From Time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.blue.shade600,
                        size: 24.r,
                      ),
                      SizedBox(width: 8.w),
                      AppCustomText(
                        text: '${LangKeys.from.tr} :',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                      Spacer(),
                      Obx(
                        () => GestureDetector(
                          onTap: () => controller.selectTime(context, true),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: AppCustomText(
                              text: controller.fromTime.value,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // To Time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        color: Colors.red.shade600,
                        size: 24.w,
                      ),
                      SizedBox(width: 8.w),
                      AppCustomText(
                        text: '${LangKeys.to.tr} :',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                      Spacer(),
                      Obx(
                        () => GestureDetector(
                          onTap: () => controller.selectTime(context, false),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: AppCustomText(
                              text: controller.toTime.value,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            30.verticalSpace,
            Obx(
              () => AppButton(
                text: LangKeys.add.tr,
                isLoading: controller.isLoading.value,
                onPressed: controller.validation,
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
