import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/widgets/forms/app_custom_text.dart';

class BalanceCard extends StatelessWidget {
  final dynamic balance;

  const BalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4A90E2).withOpacity(0.3),
            blurRadius: 15.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 24.r,
                ),
              ),
            ],
          ),
          16.verticalSpace,
          AppCustomText(
            text: LangKeys.availableOrders.tr,
            fontSize: 14.sp,
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w500,
          ),

          AppCustomText(
            text: '${balance.toStringAsFixed(2)}',
            fontSize: 32.sp,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          // SizedBox(height: 4.h),
          //
          // Text(
          //   'شيكل إسرائيلي',
          //   style: TextStyle(
          //     fontSize: 14.sp,
          //     color: Colors.white.withOpacity(0.8),
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
        ],
      ),
    );
  }
}
