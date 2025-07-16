import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/extensions/color.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/utils/app_utils.dart';
import 'package:mkanak/app/widgets/app_bar/custom_app_bar.dart';
import 'package:mkanak/app/widgets/buttons/app_button.dart';
import 'package:mkanak/app/widgets/forms/app_custom_text.dart';
import 'package:mkanak/app/widgets/forms/app_text_field.dart';
import 'package:mkanak/modules/user/new_order/controller/new_order_controller.dart';

import '../../../../app/config/app_theme.dart';

class NewOrder extends StatelessWidget {
  NewOrder({Key? key}) : super(key: key);

  final NewOrderController controller = Get.put(NewOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LangKeys.addOrder.tr),
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeSection(),
              SizedBox(height: 16.h),
              _buildPaymentSection(),
              SizedBox(height: 24.h),
              _buildImageSection(),
              SizedBox(height: 24.h),
              _buildDescriptionSection(),
              40.verticalSpace,
              // SizedBox(height: 100.h),
              Obx(
                () => AppButton(
                  text: LangKeys.send.tr,
                  onPressed: controller.submitRequest,
                  isLoading: controller.isLoading.value,
                ),
              ), // Space for bottom button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCustomText(
          text: LangKeys.selectTime.tr,
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
          color: HexColor("#3A3A3A"),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildTimeOption(TimeType.now, LangKeys.now.tr, "ic_now"),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildTimeOption(
                TimeType.later,
                LangKeys.later.tr,
                "ic_later",
              ),
            ),
          ],
        ),
        Obx(() {
          if (controller.selectedTimeType.value == TimeType.later) {
            return Column(
              children: [
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: controller.selectDate,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                color: AppTheme.primaryColor,
                                size: 20.r,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: AppCustomText(
                                  text:
                                      controller.selectedDate.value.isEmpty
                                          ? LangKeys.selectDate.tr
                                          : controller.selectedDate.value,
                                  fontSize: 13.sp,
                                  color:
                                      controller.selectedDate.value.isEmpty
                                          ? Colors.grey[800]!
                                          : HexColor("3A3A3A"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: controller.selectTime,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: AppTheme.primaryColor,
                                size: 20.r,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: AppCustomText(
                                  text:
                                      controller.selectedTime.value.isEmpty
                                          ? LangKeys.selectTime.tr
                                          : controller.selectedTime.value,
                                  fontSize: 13.sp,
                                  color:
                                      controller.selectedTime.value.isEmpty
                                          ? Colors.grey[800]!
                                          : HexColor("3A3A3A"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildTimeOption(TimeType type, String label, String icon) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectTimeType(type),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
          decoration: BoxDecoration(
            color:
                controller.selectedTimeType.value == type
                    ? Colors.white
                    : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color:
                  controller.selectedTimeType.value == type
                      ? AppTheme.primaryColor
                      : Colors.grey[300]!,
              width: controller.selectedTimeType.value == type ? 1.w : 0,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x0d000000),
                offset: Offset(0, 5),
                blurRadius: 15,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x0d000000),
                      offset: Offset(0, 5),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  AppUtils.getIconPath(icon),
                  width: 50.w,
                  height: 50.h,
                ),
              ),
              SizedBox(width: 6.w),

              AppCustomText(
                text: label,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color:
                    controller.selectedTimeType.value == type
                        ? HexColor("3A3A3A")
                        : Colors.grey[700]!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCustomText(
          text: LangKeys.paymentMethod.tr,
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
          color: HexColor("#3A3A3A"),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildPaymentOption(
                PaymentMethod.cash,
                LangKeys.cash.tr,
                "ic_cash",
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildPaymentOption(
                PaymentMethod.online,
                LangKeys.online.tr,
                "ic_online",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOption(PaymentMethod method, String label, String icon) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectPaymentMethod(method),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
          decoration: BoxDecoration(
            color:
                controller.selectedPaymentMethod.value == method
                    ? Colors.white
                    : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color:
                  controller.selectedPaymentMethod.value == method
                      ? AppTheme.primaryColor
                      : Colors.grey[300]!,
              width: controller.selectedPaymentMethod.value == method ? 1.w : 0,
            ),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x0d000000),
                      offset: Offset(0, 5),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  AppUtils.getIconPath(icon),
                  width: 50.w,
                  height: 50.h,
                ),
              ),
              SizedBox(width: 6.w),
              AppCustomText(
                text: label,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color:
                    controller.selectedPaymentMethod.value == method
                        ? HexColor("3A3A3A")
                        : Colors.grey[700]!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCustomText(
          text: LangKeys.selectImages.tr,
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
          color: HexColor("#3A3A3A"),
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: controller.showImagePickerOptions,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppTheme.primaryColor,
                width: 1.w,
                style: BorderStyle.none,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload,
                  color: AppTheme.primaryColor,
                  size: 35.r,
                ),
                SizedBox(height: 8.h),
                AppCustomText(
                  text: LangKeys.uploadImage.tr,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
        ),
        Obx(() {
          if (controller.selectedImages.isNotEmpty) {
            return Column(
              children: [
                SizedBox(height: 16.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                    childAspectRatio: 1,
                  ),
                  itemCount: controller.selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.file(
                              controller.selectedImages[index],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4.h,
                          right: 4.w,
                          child: GestureDetector(
                            onTap: () => controller.removeImage(index),
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 8.h),
                AppCustomText(
                  text: '${controller.selectedImages.length} / 10',
                  fontSize: 12.sp,
                  color: Colors.grey[600]!,
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCustomText(
          text: LangKeys.description.tr.replaceAll(":", ""),
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
          color: HexColor("#3A3A3A"),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: const Color(0x0d000000),
                offset: Offset(0, 5),
                blurRadius: 15,
              ),
            ],
          ),
          child: TextField(
            maxLines: 5,
            textAlign: TextAlign.start,
            onChanged: controller.onDescriptionChanged,
            decoration: InputDecoration(
              hintText: LangKeys.description.tr.replaceAll(":", ""),
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.w),
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
