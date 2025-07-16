import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/config/app_theme.dart';
import 'package:mkanak/app/extensions/color.dart';
import 'package:mkanak/app/routes/app_routes.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/widgets/app_bar/custom_app_bar.dart';
import 'package:mkanak/app/widgets/common/app_empty_state.dart';
import 'package:mkanak/app/widgets/common/app_loading_view.dart';
import 'package:mkanak/app/widgets/common/app_network_image.dart';
import 'package:mkanak/app/widgets/forms/app_custom_text.dart';
import 'package:mkanak/core/models/categories.dart';
import 'package:mkanak/modules/user/home_page/controller/home_page_controller.dart';

import '../../../../app/widgets/forms/app_search_field.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  HomePageController controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.home.tr, isShowBack: false),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSearchField(
              showActionButton: false,
              hintText: LangKeys.search.tr,
              controller: controller.searchController,
              actionIconPath: "ic_refresh",
              onActionButtonPressed: () {
                controller.searchController.text = "";
                // controller.getHome();
              },
              onChanged: (value) {
                // if (value.isEmpty && controller.searchQuery.isNotEmpty) {
                //   controller.clearSearch();
                // }
              },
              onSubmitted: () {
                print('Log zada');
                // if (controller.searchController.text.isNotEmpty) {
                //   Get.toNamed(
                //     AppRoutes.searchProducts,
                //     arguments: {
                //       "search": controller.searchController.text,
                //     },
                //   );
                //   controller.searchController.text = "";
                // }
              },
              height: 48.h,
            ),
            30.verticalSpace,
            AppCustomText(
              text: LangKeys.categories.tr,
              color: HexColor("3A3A3A"),
              fontWeight: FontWeight.w800,
            ),
            16.verticalSpace,
            Expanded(
              child: GetBuilder<HomePageController>(
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
                        controller.getCategories();
                      },
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.getCategories();
                    },
                    child: ListView.builder(
                      itemCount: controller.categoriesList.length,
                      itemBuilder: (context, index) {
                        return _buildServiceItem(
                          controller.categoriesList[index],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(Categories category) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.servicesPage,
          arguments: {"categoryId": category.id},
        );
      },
      child: Container(
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
          ],
        ),
      ),
    );
  }
}
