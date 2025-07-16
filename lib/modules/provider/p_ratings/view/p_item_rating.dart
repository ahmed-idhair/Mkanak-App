import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/extensions/color.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/utils/app_utils.dart';
import 'package:mkanak/app/widgets/common/app_network_image.dart';
import 'package:mkanak/app/widgets/core/app_avatar.dart';
import 'package:mkanak/app/widgets/forms/app_custom_text.dart';

import '../../../../core/models/order/order.dart';
import '../../../../core/models/rate.dart';

class PItemRating extends StatelessWidget {
  final Rate data;
  final VoidCallback onTap;

  const PItemRating({super.key, required this.data, required this.onTap});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppAvatar(
                    size: 50.r,
                    text: data.order?.user?.name ?? "",
                    imageUrl: data.order?.user?.avatar ?? "",
                  ),
                  // Service Name and Duration
                  8.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppCustomText(
                          text: data.order?.user?.name ?? "",
                          color: HexColor("3A3A3A"),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(height: 4.h),
                        RatingBar.builder(
                          initialRating: data.rating ?? 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          ignoreGestures: true,
                          itemSize: 16.r,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder:
                              (context, _) =>
                                  Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {
                            // print(rating);
                          },
                        ),
                        SizedBox(height: 4.h),
                        AppCustomText(
                          text: AppUtils.timeAgo(data.createdAt ?? ""),
                          color: HexColor("8F95A6"),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              12.verticalSpace,
              AppCustomText(
                textAlign: TextAlign.start,
                text: data.comment ?? "",
                fontSize: 13.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
