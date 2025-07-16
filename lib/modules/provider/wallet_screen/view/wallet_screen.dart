import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/widgets/common/app_empty_state.dart';
import 'package:mkanak/app/widgets/common/app_loading_view.dart';
import 'package:mkanak/app/widgets/forms/app_custom_text.dart';
import 'package:mkanak/modules/provider/wallet_screen/view/transaction_card.dart';

import '../../../../app/translations/lang_keys.dart';
import '../../../../app/widgets/app_bar/custom_app_bar.dart';
import '../contoller/wallet_controller.dart';
import 'balance_card.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final controller = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.wallet.tr),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: AppLoadingView());
        }

        if (controller.walletData.value == null) {
          return AppEmptyState(
            message: LangKeys.noData.tr,
            actionText: LangKeys.retry.tr,
            onActionPressed: () {
              controller.getWallet();
            },
          );
        }

        final wallet = controller.walletData.value!;
        return RefreshIndicator(
          onRefresh: controller.refreshWallet,
          // color: Color(0xFF4A90E2),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance Card
                BalanceCard(balance: wallet.balance),
                20.verticalSpace,

                /*
                // Quick Actions
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 8.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Get.snackbar('قريباً', 'ميزة السحب قريباً');
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Column(
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                color: Color(0xFFE85D75),
                                size: 28.w,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'سحب',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 16.w),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 8.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Get.snackbar('قريباً', 'ميزة الإيداع قريباً');
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Column(
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                color: Color(0xFF63CB5B),
                                size: 28.w,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'إيداع',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 16.w),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 8.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Get.snackbar('تحديث', 'تم تحديث الرصيد');
                            controller.refreshWallet();
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                color: Color(0xFF4A90E2),
                                size: 28.w,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'السجل',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                 */

                // SizedBox(height: 32.h),

                // Transactions Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppCustomText(
                      text: LangKeys.financialTransactions.tr,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    AppCustomText(
                      text:
                          '${wallet.transactions?.length} ${LangKeys.transactions.tr}',
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
                16.verticalSpace,
                // Transactions List
                if (wallet.transactions != null && wallet.transactions!.isEmpty)
                  AppEmptyState(message: LangKeys.noTransactionsAvailable.tr)
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: wallet.transactions?.length,
                    itemBuilder: (context, index) {
                      return TransactionCard(
                        transaction: wallet.transactions![index],
                        controller: controller,
                      );
                    },
                  ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }
}
