import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/config/app_theme.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/widgets/app_bar/custom_app_bar.dart';
import 'package:mkanak/app/widgets/common/app_empty_state.dart';
import 'package:mkanak/app/widgets/common/app_loading_view.dart';
import 'package:mkanak/app/widgets/forms/app_custom_text.dart';
import 'package:mkanak/modules/provider/p_order_statistics/controller/p_order_statistics_controller.dart';
import 'package:mkanak/modules/provider/p_order_statistics/view/widget/statistic_card.dart';

class POrderStatistics extends StatelessWidget {
  POrderStatistics({super.key});

  final controller = Get.put(POrderStatisticsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.home.tr, isShowBack: false),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: AppLoadingView());
        }

        if (controller.statistics.value == null) {
          return AppEmptyState(
            message: LangKeys.noData.tr,
            actionText: LangKeys.retry.tr,
            onActionPressed: () {
              controller.getStatistics();
            },
          );
        }
        final stats = controller.statistics.value!;
        return RefreshIndicator(
          onRefresh: controller.refreshStatistics,
          color: AppTheme.primaryColor,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                /*
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.analytics,
                            color: Colors.white,
                            size: 28.w,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'نظرة عامة على أدائك',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'تتبع طلباتك وأرباحك بشكل مفصل',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                 */

                // SizedBox(height: 24.h),

                // Total Earnings Card (Featured)

                /*
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF63CB5B), Color(0xFF4CAF50)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF63CB5B).withOpacity(0.3),
                        blurRadius: 12.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 32.w,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${stats.totalEarnings!.toStringAsFixed(2)} ش',
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'إجمالي الأرباح',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                 */

                // SizedBox(height: 24.h),
                AppCustomText(
                  text: LangKeys.orderStatistics.tr,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                16.verticalSpace,
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.1,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    StatisticCard(
                      title: LangKeys.availableOrders.tr,
                      value: '${stats.availableOrders}',
                      icon: Icons.assignment_outlined,
                      color: Color(0xFF4A90E2),
                      backgroundColor: Color(0xFF4A90E2).withOpacity(0.1),
                      onTap: () {
                        // Navigate to available orders
                        // Get.snackbar('التنقل', 'الانتقال إلى الطلبات المتاحة');
                      },
                    ),
                    StatisticCard(
                      title: LangKeys.assignedOrders.tr,
                      value: '${stats.assignedOrders}',
                      icon: Icons.assignment_ind,
                      color: Color(0xFFFFB800),
                      backgroundColor: Color(0xFFFFB800).withOpacity(0.1),
                      onTap: () {
                        // Navigate to assigned orders
                        // Get.snackbar('التنقل', 'الانتقال إلى الطلبات المعينة');
                      },
                    ),
                    StatisticCard(
                      title: LangKeys.pendingApproval.tr,
                      value: '${stats.pendingApproval}',
                      icon: Icons.pending_actions,
                      color: Color(0xFFFF9800),
                      backgroundColor: Color(0xFFFF9800).withOpacity(0.1),
                      onTap: () {
                        // Navigate to pending orders
                        // Get.snackbar('التنقل', 'الانتقال إلى الطلبات المعلقة');
                      },
                    ),
                    StatisticCard(
                      title: LangKeys.completedOrders.tr,
                      value: '${stats.completedOrders}',
                      icon: Icons.check_circle_outline,
                      color: Color(0xFF4CAF50),
                      backgroundColor: Color(0xFF4CAF50).withOpacity(0.1),
                      onTap: () {
                        // Navigate to completed orders
                        // Get.snackbar('التنقل', 'الانتقال إلى الطلبات المكتملة');
                      },
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                AppCustomText(
                  text: LangKeys.quickActions.tr,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 16.h),

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
                            controller.refreshStatistics();
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Column(
                            children: [
                              Icon(
                                Icons.refresh,
                                color: Color(0xFF4A90E2),
                                size: 32.w,
                              ),
                              SizedBox(height: 8.h),
                              AppCustomText(
                                text: LangKeys.refreshData.tr,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    /*
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
                            Get.snackbar('تقرير', 'عرض التقرير المفصل');
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Column(
                            children: [
                              Icon(
                                Icons.bar_chart,
                                color: Color(0xFF63CB5B),
                                size: 32.w,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'تقرير مفصل',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                     */
                  ],
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
