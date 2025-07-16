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

class OrderDetailsController extends BaseController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final selectedTabIndex = 0.obs;
  var isLoading = false.obs;
  var order = Order().obs;
  GoogleMapController? googleMapController;
  final ratingValue = 0.0.obs;
  final commentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedTabIndex.value = tabController.index;
    });
    getOrderDetails();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
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

  // Accept order offer
  Future<void> acceptOffer(int offerId) async {
    try {
      EasyLoading.show();
      Map<String, dynamic> body = {"offer_id": offerId};
      final result = await httpService.request(
        url: "${ApiConstant.orders}/${order.value.id}/accept-offer",
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var response = ApiResponse.fromJson(result.data);
        if (response.isSuccess) {
          getOrderDetails(); // Refresh order details
        } else {
          showErrorBottomSheet(response.message ?? "");
        }
      }
    } catch (e) {
      AppToast.error('حدث خطأ في قبول العرض');
    } finally {
      EasyLoading.dismiss();
    }
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

  Future<void> cancelOrder() async {
    try {
      EasyLoading.show();
      final result = await httpService.request(
        url: "${ApiConstant.orders}/${order.value.id}/cancel",
        method: Method.PUT,
      );
      if (result != null) {
        var response = ApiResponse.fromJson(result.data);
        if (response.isSuccess) {
          getOrderDetails(); // Refresh order details
        } else {
          showErrorBottomSheet(response.message);
        }
      }
    } catch (e) {
      // AppToast.error('حدث خطأ في رفض العرض');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> getOrderDetails() async {
    try {
      update(['updateOrder']);
      isLoading(true);
      final result = await httpService.request(
        url: "${ApiConstant.orders}/${Get.arguments['orderId']}",
        method: Method.GET,
      );
      if (result != null) {
        var response = ApiResponse.fromJsonModel(result.data, Order.fromJson);
        if (response.isSuccess && response.data != null) {
          order.value = response.data!;
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

  // Show rating bottom sheet
  void showRatingBottomSheet() {
    // Reset values
    ratingValue.value = 0.0;
    commentController.clear();

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
              text: LangKeys.rateOrder.tr,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),

            SizedBox(height: 8.h),

            AppCustomText(
              text: LangKeys.shareYourFeedbackAboutTheServiceQuality.tr,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20.h),

            // Rating Stars
            Obx(
              () => Column(
                children: [
                  AppCustomText(
                    text:
                        '${LangKeys.yourRating.tr}: ${ratingValue.value.toStringAsFixed(1)}',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),

                  SizedBox(height: 12.h),

                  RatingBar.builder(
                    initialRating: ratingValue.value,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 32.w,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemBuilder:
                        (context, _) =>
                            Icon(Icons.star, color: Color(0xFFFFB800)),
                    unratedColor: Colors.grey.shade300,
                    onRatingUpdate: (rating) {
                      ratingValue.value = rating;
                    },
                    glow: false,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Comment TextField
            AppTextField(
              label: LangKeys.comment.tr,
              controller: commentController,
              isRequired: false,
              maxLines: 4,
              hintText: LangKeys.writeYourCommentHere.tr,
            ),

            SizedBox(height: 20.h),

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
                  child: Obx(
                    () => AppButton(
                      text: LangKeys.submitRating.tr,
                      color:
                          ratingValue.value > 0
                              ? Color(0xFF4A90E2)
                              : Colors.grey.shade400,
                      onPressed: () => submitRating(),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: MediaQuery.of(Get.context!).viewInsets.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> submitRating() async {
    if (ratingValue.value <= 0) {
      AppToast.error(LangKeys.pleaseSelectRatingFirst.tr);
      return;
    }

    try {
      EasyLoading.show();
      Map<String, dynamic> body = {
        "rating": ratingValue.value,
        "comment": commentController.text.trim(),
      };
      final result = await httpService.request(
        url: "${ApiConstant.orders}/${order.value.id}/rate",
        method: Method.POST,
        params: body,
      );

      if (result != null) {
        var response = ApiResponse.fromJson(result.data);
        if (response.isSuccess) {
          Get.back(); // Close bottom sheet
          getOrderDetails(); // Refresh order details
        } else {
          AppToast.error(response.message);
        }
      }
    } catch (e) {
      // AppToast.error('حدث خطأ في إرسال التقييم');
    } finally {
      EasyLoading.dismiss();
    }
  }
}
