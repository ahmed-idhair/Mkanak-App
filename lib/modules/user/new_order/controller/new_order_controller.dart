import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:mkanak/app/config/app_theme.dart';
import 'package:mkanak/app/routes/app_routes.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/widgets/common/app_bottom_sheet.dart';
import 'package:mkanak/modules/base_controller.dart';
import 'package:mkanak/modules/user/select_location/controller/select_location_controller.dart';
import 'package:mkanak/modules/user/services_page/controller/services_page_controller.dart';

import '../../../../core/api/api_constant.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/api/http_service.dart';

// Enums for selections
enum TimeType { now, later }

enum PaymentMethod { online, cash }

// Controller for managing screen state
class NewOrderController extends BaseController {
  // Observable variables
  Rx<TimeType> selectedTimeType = TimeType.now.obs;
  Rx<PaymentMethod> selectedPaymentMethod = PaymentMethod.cash.obs;
  RxString selectedDate = ''.obs;
  RxString selectedTime = ''.obs;
  RxString description = ''.obs;
  RxList<File> selectedImages = <File>[].obs;
  RxBool isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  void selectTimeType(TimeType type) {
    selectedTimeType.value = type;
    if (type == TimeType.now) {
      selectedDate.value = '';
      selectedTime.value = '';
    }
  }

  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      // locale: const Locale('ar'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // selectedDate.value = '${picked.day}/${picked.month}/${picked.year}';
      selectedDate.value = '${picked.year}-${picked.month}-${picked.day}';
    }
  }

  Future<void> selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6366F1),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedTime.value =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        List<File> imageFiles =
            images.map((image) => File(image.path)).toList();
        selectedImages.addAll(imageFiles);

        // Limit to maximum 10 images
        if (selectedImages.length > 5) {
          selectedImages.value = selectedImages.take(5).toList();
          Get.snackbar(
            'تنبيه',
            'يمكنك اختيار حد أقصى 5 صور',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء اختيار الصور',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImages.add(File(image.path));

        if (selectedImages.length > 5) {
          selectedImages.removeLast();
          Get.snackbar(
            'تنبيه',
            'يمكنك اختيار حد أقصى 5 صور',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء التقاط الصورة',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  void onDescriptionChanged(String value) {
    description.value = value;
  }

  Future<void> submitRequest() async {
    // Validation
    if (selectedTimeType.value == TimeType.later) {
      if (selectedDate.value.isEmpty) {
        showErrorBottomSheet(LangKeys.selectDate.tr);
        return;
      }
      if (selectedTime.value.isEmpty) {
        showErrorBottomSheet(LangKeys.selectTime.tr);
        return;
      }
    }
    if (selectedImages.isEmpty) {
      showErrorBottomSheet(LangKeys.selectImages.tr);
      return;
    }

    if (description.value.trim().isEmpty) {
      showErrorBottomSheet(LangKeys.description.tr);
      return;
    }

    newOrder();
  }

  Future<void> newOrder() async {
    try {
      FocusScopeNode currentFocus = FocusScope.of(Get.context!);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.focusedChild?.unfocus();
      }
      isLoading(true);
      Map<String, dynamic>? body;
      body = {
        'service_id': Get.find<SelectLocationController>().serviceId,
        'time_type': selectedTimeType.value == TimeType.now ? 0 : 1,
        'date':
            selectedTimeType.value == TimeType.later
                ? selectedDate.value
                : null,
        'time':
            selectedTimeType.value == TimeType.later
                ? selectedTime.value
                : null,
        'description': description,
        'payment_method':
            selectedPaymentMethod.value == PaymentMethod.cash ? 0 : 1,
        'address':
            Get.find<SelectLocationController>().selectedLocationAddress.value,
        'latitude':
            Get.find<SelectLocationController>()
                .selectedLocation
                .value
                .latitude,
        'longitude':
            Get.find<SelectLocationController>()
                .selectedLocation
                .value
                .longitude,
      };
      for (int i = 0; i < selectedImages.length; i++) {
        body['images[$i]'] = await d.MultipartFile.fromFile(
          selectedImages[i].path,
        );
      }
      final formData = d.FormData.fromMap(body);

      final result = await httpService.request(
        url: ApiConstant.orders,
        method: Method.POST,
        isUploadImg: true,
        formData: formData,
      );

      if (result != null) {
        var resp = ApiResponse.fromJson(result.data);
        if (resp.isSuccess == true) {
          showSuccessBottomSheet(
            resp.message ?? "",
            onClick: () {
              Get.back();
              Get.offAllNamed(AppRoutes.home);
            },
          );
        } else {
          showErrorBottomSheet(resp.message ?? "");
        }
      }
    } finally {
      isLoading(false);
    }
  }

  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'اختر مصدر الصورة',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      pickImageFromCamera();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFF6366F1).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: const Color(0xFF6366F1),
                            size: 32.sp,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'الكاميرا',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF6366F1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      pickImages();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library,
                            color: const Color(0xFF10B981),
                            size: 32.sp,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'المعرض',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF10B981),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
