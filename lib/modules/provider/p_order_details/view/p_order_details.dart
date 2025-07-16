import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mkanak/app/extensions/color.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/widgets/app_bar/custom_app_bar.dart';
import 'package:mkanak/app/widgets/buttons/app_button.dart';
import 'package:mkanak/app/widgets/common/app_empty_state.dart';
import 'package:mkanak/app/widgets/common/app_loading_view.dart';
import 'package:mkanak/app/widgets/core/app_avatar.dart';
import 'package:mkanak/modules/user/order_details/controller/order_details_controller.dart';

import '../../../../app/utils/app_utils.dart';
import '../../../../app/widgets/common/app_network_image.dart';
import '../../../../app/widgets/common/custom_tab_bar.dart';
import '../../../../app/widgets/forms/app_custom_text.dart';
import '../controller/p_order_details_controller.dart';

class POrderDetails extends StatelessWidget {
  POrderDetails({super.key});

  final controller = Get.put(POrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.orderDetails.tr),
      body: GetBuilder<POrderDetailsController>(
        id: 'updateOrder',
        builder: (controller) {
          if (controller.isLoading.isTrue) {
            return AppLoadingView();
          }
          if (controller.order.value.id == null ||
              controller.order.value.id == 0) {
            return AppEmptyState(message: LangKeys.noData.tr);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Name Card
                Container(
                  margin: EdgeInsetsDirectional.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x0d000000),
                        offset: Offset(0, 5),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        // Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Car Icon
                            Container(
                              width: 50.w,
                              height: 50.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x0d000000),
                                    offset: Offset(0, 5),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: AppNetworkImage(
                                  imageUrl:
                                      controller.order.value.service?.image ??
                                      "",
                                  fit: BoxFit.contain,
                                  width: 35.w,
                                  height: 35.h,
                                  borderRadius: 0,
                                ),
                              ),
                            ),
                            // Service Name and Duration
                            8.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppCustomText(
                                    text:
                                        controller.order.value.service?.title ??
                                        "",
                                    color: HexColor("3A3A3A"),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  SizedBox(height: 2.h),
                                  AppCustomText(
                                    text: AppUtils.timeAgo(
                                      controller.order.value.createdAt ?? "",
                                    ),
                                    color: HexColor("8F95A6"),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  controller.order.value.timeType.toString() ==
                                          "1"
                                      ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppCustomText(
                                            text:
                                                "${LangKeys.date.tr} : ${AppUtils.formatDatedMMMMyyyy(controller.order.value.date ?? "")}",
                                            color: HexColor("8F95A6"),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          AppCustomText(
                                            text:
                                                "${LangKeys.theTime.tr} : ${AppUtils.formatTimeTo12Hour(controller.order.value.time ?? "")}",
                                            color: HexColor("8F95A6"),
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),

                        12.verticalSpace,

                        // Divider
                        Divider(
                          color: HexColor("D8D8D8"),
                          height: 0,
                          thickness: 0.5.h,
                        ),
                        12.verticalSpace,
                        // Bottom Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppCustomText(
                                  text: LangKeys.orderStatus.tr.replaceAll(
                                    ":",
                                    "",
                                  ),
                                  color: HexColor("8F95A6"),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                SizedBox(height: 4.h),
                                AppCustomText(
                                  text: AppUtils.getStatusText(
                                    controller.order.value.status.toString(),
                                  ),
                                  color: AppUtils.getStatusColor(
                                    controller.order.value.status.toString(),
                                  ),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppCustomText(
                                  text: LangKeys.theTime.tr.replaceAll(":", ""),
                                  color: HexColor("8F95A6"),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                SizedBox(height: 4.h),
                                AppCustomText(
                                  text:
                                      controller.order.value.timeType
                                                  .toString() ==
                                              "0"
                                          ? LangKeys.now.tr
                                          : LangKeys.later.tr,
                                  color: HexColor("3A3A3A"),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppCustomText(
                                  text: LangKeys.paymentMethod.tr.replaceAll(
                                    ":",
                                    "",
                                  ),
                                  color: HexColor("8F95A6"),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                SizedBox(height: 4.h),
                                AppCustomText(
                                  text:
                                      controller.order.value.paymentMethod
                                                  .toString() ==
                                              "0"
                                          ? LangKeys.cash.tr
                                          : LangKeys.online.tr,
                                  color: HexColor("3A3A3A"),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                controller.order.value.user != null
                    ? 12.verticalSpace
                    : SizedBox(),
                controller.order.value.user != null
                    ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
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
                          AppAvatar(
                            text: controller.order.value.user?.name ?? "",
                            imageUrl: controller.order.value.user?.avatar ?? "",
                            size: 50.r,
                          ),
                          8.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppCustomText(
                                  text: controller.order.value.user?.name ?? "",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                SizedBox(height: 4.h),
                                AppCustomText(
                                  text:
                                      controller
                                          .order
                                          .value
                                          .user
                                          ?.phoneNumber ??
                                      "",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    : SizedBox(),
                12.verticalSpace,
                // Request Details
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x0d000000),
                        offset: Offset(0, 5),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppCustomText(
                        text: LangKeys.orderDetails.tr,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      6.verticalSpace,
                      AppCustomText(
                        text: controller.order.value.description ?? "",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: HexColor("151B44"),
                      ),
                    ],
                  ),
                ),

                12.verticalSpace,

                // Location Map
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x0d000000),
                        offset: Offset(0, 5),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppCustomText(
                        text: LangKeys.location.tr,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      SizedBox(height: 16.h),
                      Stack(
                        children: [
                          SizedBox(
                            height: 200.h,
                            child: GoogleMap(
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                              scrollGesturesEnabled: false,
                              zoomGesturesEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: controller.getOrderLocation(),
                                zoom: 15,
                              ),
                              markers: {
                                Marker(
                                  markerId: MarkerId('order_location'),
                                  position: controller.getOrderLocation(),
                                  infoWindow: InfoWindow(
                                    title: 'موقع الطلب',
                                    snippet: controller.order.value.address,
                                  ),
                                ),
                              },
                            ),
                          ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => controller.openInGoogleMaps(),
                                splashColor: Colors.black.withOpacity(0.05),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                controller.order.value.status.toString() == "0" &&
                        (controller.order.value.canMakeOffer == true ||
                            controller.order.value.canUpdateOffer == true)
                    ? Column(
                      children: [
                        10.verticalSpace,
                        AppButton(
                          text:
                              controller.order.value.canUpdateOffer == true
                                  ? LangKeys.editOffer.tr
                                  : LangKeys.addOffer.tr,
                          onPressed: () {
                            controller.showOfferBottomSheet(
                              isEdit:
                                  controller.order.value.canUpdateOffer ??
                                  false,
                            );
                          },
                        ),
                      ],
                    )
                    : SizedBox(),
                controller.order.value.status.toString() == "1"
                    ? Column(
                      children: [
                        10.verticalSpace,
                        AppButton(
                          text: LangKeys.complete.tr,
                          onPressed: () {
                            controller.updateOrderStatus(2);
                          },
                        ),
                      ],
                    )
                    : SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}
