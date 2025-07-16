import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/config/app_theme.dart';
import 'package:mkanak/app/extensions/color.dart';
import 'package:mkanak/app/routes/app_routes.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/widgets/app_bar/custom_app_bar.dart';
import 'package:mkanak/app/widgets/common/app_bottom_sheet.dart';
import 'package:mkanak/app/widgets/common/app_empty_state.dart';
import 'package:mkanak/app/widgets/common/app_loading_view.dart';
import 'package:mkanak/app/widgets/common/app_network_image.dart';
import 'package:mkanak/app/widgets/forms/app_custom_text.dart';
import 'package:mkanak/core/models/categories.dart';

import '../../../../app/widgets/forms/app_search_field.dart';
import '../controller/p_services_page_controller.dart';

class PServicesPage extends StatelessWidget {
  PServicesPage({super.key});

  PServicesPageController controller = Get.put(PServicesPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.addService.tr),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          Get.toNamed(AppRoutes.addService);
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: GetBuilder<PServicesPageController>(
          id: "updateList",
          builder: (controller) {
            if (controller.isLoading.value) {
              return AppLoadingView();
            }
            if (controller.categoriesList.isEmpty) {
              return AppEmptyState(
                message: LangKeys.noData.tr,
                actionText: LangKeys.retry.tr,
                onActionPressed: () {
                  controller.getServices();
                },
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                controller.getServices();
              },
              child: ListView.builder(
                itemCount: controller.categoriesList.length,
                itemBuilder: (context, index) {
                  return _buildServiceItem(controller.categoriesList[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildServiceItem(Categories category) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: HexColor("F5F6FF").withValues(alpha: 0.53),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          AppNetworkImage(
            imageUrl: category.image ?? "",
            fit: BoxFit.contain,
            width: 50.w,
            height: 50.h,
            borderRadius: 0,
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCustomText(
                  text: category.title ?? "",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                4.verticalSpace,
                AppCustomText(
                  text: category.description ?? "",
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
                  controller.deleteService(category.id ?? 0);
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
