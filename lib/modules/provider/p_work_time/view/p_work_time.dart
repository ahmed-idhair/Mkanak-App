import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/config/app_theme.dart';
import 'package:mkanak/app/extensions/color.dart';
import 'package:mkanak/app/routes/app_routes.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/utils/app_utils.dart';
import 'package:mkanak/app/widgets/app_bar/custom_app_bar.dart';
import 'package:mkanak/app/widgets/common/app_bottom_sheet.dart';
import 'package:mkanak/app/widgets/common/app_empty_state.dart';
import 'package:mkanak/app/widgets/common/app_loading_view.dart';
import 'package:mkanak/app/widgets/common/app_network_image.dart';
import 'package:mkanak/app/widgets/forms/app_custom_text.dart';
import 'package:mkanak/core/models/categories.dart';
import 'package:mkanak/core/models/working_times.dart';

import '../../../../app/widgets/forms/app_search_field.dart';
import '../controller/p_work_time_controller.dart';

class PWorkTime extends StatelessWidget {
  PWorkTime({super.key});

  PWorkTimeController controller = Get.put(PWorkTimeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.addWorkTime.tr),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          Get.toNamed(AppRoutes.addWorkTime);
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: GetBuilder<PWorkTimeController>(
          id: "updateList",
          builder: (controller) {
            if (controller.isLoading.value) {
              return AppLoadingView();
            }
            if (controller.workingTimesList.isEmpty) {
              return AppEmptyState(
                message: LangKeys.noData.tr,
                actionText: LangKeys.retry.tr,
                onActionPressed: () {
                  controller.providerWorkingTimes();
                },
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                controller.providerWorkingTimes();
              },
              child: ListView.builder(
                itemCount: controller.workingTimesList.length,
                itemBuilder: (context, index) {
                  return _buildServiceItem(controller.workingTimesList[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildServiceItem(WorkingTimes times) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: HexColor("F5F6FF").withValues(alpha: 0.53),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCustomText(
                  text: times.dayName ?? "",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                ),
                4.verticalSpace,
                AppCustomText(
                  text:
                      "${AppUtils.formatTimeTo12Hour(times.fromTime ?? "")} - ${AppUtils.formatTimeTo12Hour(times.toTime ?? "")}",
                  fontSize: 12.sp,
                  color: HexColor("8F95A6"),
                ),
              ],
            ),
          ),
          6.horizontalSpace,
          InkWell(
            onTap: () {
              confirmDeleteBottomSheet(
                LangKeys.delete.tr,
                LangKeys.deleteService.tr,
                () {
                  Get.back();
                  controller.deleteService(times.id ?? 0);
                },
              );
            },
            splashColor: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.all(Radius.circular(25.r)),
            child: Padding(
              padding: EdgeInsets.all(2.0.r),
              child: Icon(Icons.delete_outline, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
