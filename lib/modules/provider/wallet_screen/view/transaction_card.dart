import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/widgets/forms/app_custom_text.dart';
import 'package:mkanak/core/models/wallet/transactions.dart';

import '../contoller/wallet_controller.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final WalletController controller;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.2),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: Colors.green,
                  size: 20.r,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCustomText(
                      text: '${LangKeys.order.tr} #${transaction.orderId}',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    SizedBox(height: 2.h),
                    AppCustomText(
                      text:
                          '${controller.formatDate(transaction.createdAt ?? "")} • ${controller.formatTime(transaction.createdAt ?? "")}',
                      fontSize: 10.sp,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppCustomText(
                    text: '+${transaction.total!.toStringAsFixed(2)}',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.green.shade600,
                  ),
                  // SizedBox(height: 4.h),
                  // Container(
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 8.w,
                  //     vertical: 4.h,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.green.withValues(alpha: 0.1),
                  //     borderRadius: BorderRadius.circular(12.r),
                  //   ),
                  //   child: Text(
                  //     controller.getTransactionStatusText(
                  //       transaction.status ?? 0,
                  //     ),
                  //     style: TextStyle(
                  //       fontSize: 10.sp,
                  //       fontWeight: FontWeight.w600,
                  //       color: controller.getTransactionStatusColor(
                  //         transaction.status ?? 0,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),

          if (transaction.order != null) ...[
            SizedBox(height: 12.h),
            // Order Details
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        size: 16.r,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: AppCustomText(
                          text: transaction.order!.description ?? "",
                          fontSize: 14.sp,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16.r,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: AppCustomText(
                          text: transaction.order!.address ?? "",
                          fontSize: 12.sp,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
