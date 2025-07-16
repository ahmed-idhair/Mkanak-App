import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/widgets/common/app_bottom_sheet.dart';
import 'package:mkanak/app/widgets/forms/app_text_field.dart';
import 'package:mkanak/core/models/order/order.dart';
import 'package:mkanak/modules/base_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/widgets/buttons/app_button.dart';
import '../../../../app/widgets/feedback/app_toast.dart';
import '../../../../app/widgets/forms/app_custom_text.dart';
import '../../../../core/api/api_constant.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/api/http_service.dart';

class POrderDetailsController extends BaseController {
  final selectedTabIndex = 0.obs;
  var isLoading = false.obs;
  var order = Order().obs;
  GoogleMapController? googleMapController;

  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final offerFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    getOrderDetails();
  }

  @override
  void dispose() {
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> openInGoogleMaps() async {
    if (order.value.latitude != null && order.value.longitude != null) {
      final lat = order.value.latitude!;
      final lng = order.value.longitude!;

      // Try to open in Google Maps app first
      final googleMapsUrl =
          'comgooglemaps://?daddr=$lat,$lng&directionsmode=driving';
      final googleMapsWebUrl =
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';

      try {
        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl));
        } else if (await canLaunchUrl(Uri.parse(googleMapsWebUrl))) {
          await launchUrl(
            Uri.parse(googleMapsWebUrl),
            mode: LaunchMode.externalApplication,
          );
        } else {
          AppToast.error('لا يمكن فتح الخرائط');
        }
      } catch (e) {
        AppToast.error('حدث خطأ في فتح الخرائط');
      }
    } else {
      AppToast.error('الموقع غير متوفر');
    }
  }

  LatLng getOrderLocation() {
    if (order.value.latitude != null && order.value.longitude != null) {
      return LatLng(
        double.parse(order.value.latitude!),
        double.parse(order.value.longitude!),
      );
    }
    // Default to Gaza coordinates if no location available
    return LatLng(31.5, 34.4);
  }

  // Move camera to order location
  void moveToOrderLocation() {
    if (googleMapController != null) {
      googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: getOrderLocation(), zoom: 16),
        ),
      );
    }
  }

  // Create custom marker for order location
  Future<Set<Marker>> getMarkers() async {
    final Set<Marker> markers = {};

    if (order.value.latitude != null && order.value.longitude != null) {
      markers.add(
        Marker(
          markerId: MarkerId('order_location'),
          position: getOrderLocation(),
          infoWindow: InfoWindow(
            title: 'موقع الطلب',
            snippet: order.value.address ?? 'موقع الخدمة المطلوبة',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    return markers;
  }

  // Reject order offer
  Future<void> rejectOffer(int offerId) async {
    try {
      EasyLoading.show();
      Map<String, dynamic> body = {"offer_id": offerId};
      final result = await httpService.request(
        url: "${ApiConstant.orders}/${order.value.id}/reject-offer",
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var response = ApiResponse.fromJson(result.data);
        if (response.isSuccess) {
          AppToast.success('تم رفض العرض');
          getOrderDetails(); // Refresh order details
        } else {
          AppToast.error(response.message);
        }
      }
    } catch (e) {
      AppToast.error('حدث خطأ في رفض العرض');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> getOrderDetails() async {
    try {
      update(['updateOrder']);
      isLoading(true);
      final result = await httpService.request(
        url: "${ApiConstant.providerOrders}/${Get.arguments['orderId']}",
        method: Method.GET,
      );
      if (result != null) {
        var response = ApiResponse.fromJsonModel(result.data, Order.fromJson);
        if (response.isSuccess && response.data != null) {
          order.value = response.data!;
          if (order.value.myOffer != null) {
            priceController.text = order.value.myOffer?.price.toString() ?? "0";
            descriptionController.text = order.value.myOffer?.description ?? "";
          }
          // print('Log user type ${user?.type}');
        } else {
          AppToast.error(response.message);
        }
      }
    } finally {
      isLoading(false);
      update(['updateOrder']);
    }
  }

  // Show add/edit offer bottom sheet
  void showOfferBottomSheet({bool isEdit = false}) {
    // Reset or set current values
    if (!isEdit) {
      priceController.clear();
      descriptionController.clear();
    }

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        padding: EdgeInsets.all(16.r),
        child: Form(
          key: offerFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 50.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              SizedBox(height: 20.h),

              // Title
              AppCustomText(
                text: isEdit ? LangKeys.editOffer.tr : LangKeys.addOffer.tr,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              SizedBox(height: 8.h),
              AppCustomText(
                text:
                    isEdit
                        ? LangKeys.updateOfferMsg.tr
                        : LangKeys.enterPriceDesOffer.tr,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              // Price Field
              AppTextField(
                label: LangKeys.price.tr,
                controller: priceController,
                hintText: LangKeys.enterPrice.tr,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LangKeys.enterPrice.tr;
                  }
                  if (double.tryParse(value) == null) {
                    return 'يرجى إدخال رقم صحيح';
                  }
                  if (double.parse(value) <= 0) {
                    return 'يجب أن يكون السعر أكبر من صفر';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              AppTextField(
                label: LangKeys.description.tr,
                controller: descriptionController,
                hintText: LangKeys.descriptionOfferMsg.tr,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LangKeys.descriptionOfferMsg.tr;
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: LangKeys.cancel.tr,
                      color: Colors.red,
                      onPressed: () => Get.back(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppButton(
                      text:
                          isEdit ? LangKeys.editOffer.tr : LangKeys.addOffer.tr,
                      // color: Color(0xFF4A90E2),
                      onPressed: () {
                        if (offerFormKey.currentState!.validate()) {
                          if (isEdit) {
                            updateOffer();
                          } else {
                            submitOffer();
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(Get.context!).viewInsets.bottom),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Submit new offer
  Future<void> submitOffer() async {
    try {
      EasyLoading.show();
      Map<String, dynamic> body = {
        "price": double.parse(priceController.text),
        "description": descriptionController.text.trim(),
      };
      final result = await httpService.request(
        url: "${ApiConstant.providerOrders}/${order.value.id}/offers",
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var response = ApiResponse.fromJson(result.data);
        if (response.isSuccess) {
          Get.back(); // Close bottom sheet
          AppToast.success(response.message);
          getOrderDetails(); // Refresh order details
        } else {
          AppToast.error(response.message);
        }
      }
    } catch (e) {
      AppToast.error('حدث خطأ في إرسال العرض');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> updateOffer() async {
    try {
      EasyLoading.show();
      Map<String, dynamic> body = {
        "price": double.parse(priceController.text),
        "description": descriptionController.text.trim(),
      };
      final result = await httpService.request(
        url: "${ApiConstant.providerOffers}/${order.value.myOffer?.id}",
        method: Method.PUT,
        params: body,
      );
      if (result != null) {
        var response = ApiResponse.fromJson(result.data);
        if (response.isSuccess) {
          Get.back(); // Close bottom sheet
          AppToast.success(response.message);
          getOrderDetails(); // Refresh order details
        } else {
          AppToast.error(response.message);
        }
      }
    } catch (e) {
      AppToast.error('حدث خطأ في إرسال العرض');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> updateOrderStatus(int status) async {
    try {
      EasyLoading.show();
      Map<String, dynamic> body = {"status": status};
      final result = await httpService.request(
        url: "${ApiConstant.providerOrders}/${order.value.id}/status",
        method: Method.PUT,
        params: body,
      );
      if (result != null) {
        var response = ApiResponse.fromJson(result.data);
        if (response.isSuccess) {
          AppToast.success(response.message);
          getOrderDetails(); // Refresh order details
        } else {
          AppToast.error(response.message);
        }
      }
    } catch (e) {
      // AppToast.error('حدث خطأ في إرسال العرض');
    } finally {
      EasyLoading.dismiss();
    }
  }
}
