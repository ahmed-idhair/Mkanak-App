import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/extensions/color.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/utils/app_utils.dart';
import 'package:mkanak/app/widgets/common/app_network_image.dart';
import 'package:mkanak/app/widgets/forms/app_custom_text.dart';

import '../../../../core/models/order/order.dart';

class ItemOrder extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const ItemOrder({Key? key, required this.order, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                        imageUrl: order.service?.image ?? "",
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
                          text: order.service?.title ?? "",
                          color: HexColor("3A3A3A"),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(height: 2.h),
                        AppCustomText(
                          text: AppUtils.timeAgo(order.createdAt ?? ""),
                          color: HexColor("8F95A6"),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),

                  // // Rating
                  // Container(
                  //   width: 40.w,
                  //   height: 40.w,
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xFF6B73FF).withOpacity(0.1),
                  //     borderRadius: BorderRadius.circular(20.r),
                  //   ),
                  //   child: Center(
                  //     child: Text(
                  //       'rating',
                  //       style: TextStyle(
                  //         fontSize: 16.sp,
                  //         fontWeight: FontWeight.w600,
                  //         color: const Color(0xFF6B73FF),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              12.verticalSpace,

              // Divider
              Divider(color: HexColor("D8D8D8"), height: 0, thickness: 0.5.h),
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
                        text: LangKeys.orderStatus.tr.replaceAll(":", ""),
                        color: HexColor("8F95A6"),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: 4.h),
                      AppCustomText(
                        text: AppUtils.getStatusText(order.status.toString()),
                        color: AppUtils.getStatusColor(order.status.toString()),
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
                            order.timeType.toString() == "0"
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
                        text: LangKeys.paymentMethod.tr.replaceAll(":", ""),
                        color: HexColor("8F95A6"),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: 4.h),
                      AppCustomText(
                        text:
                            order.paymentMethod.toString() == "0"
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
    );
  }
}
