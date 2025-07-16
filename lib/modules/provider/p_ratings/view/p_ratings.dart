import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/extensions/color.dart';

import '../../../../../app/translations/lang_keys.dart';
import '../../../../../app/widgets/app_bar/custom_app_bar.dart';
import '../../../../../app/widgets/common/app_empty_state.dart';
import '../../../../../app/widgets/common/app_loading_view.dart';
import '../controller/p_ratings_controller.dart';
import 'p_item_rating.dart';

class PRatings extends StatelessWidget {
  PRatings({super.key});

  PRatingsController controller = Get.put(PRatingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.ratings.tr),
      body: GetBuilder<PRatingsController>(
        id: "updateList",
        builder: (controller) {
          if (controller.isLoading.value) {
            return AppLoadingView();
          }
          if (controller.rateList.isEmpty) {
            return AppEmptyState(
              message: LangKeys.noData.tr,
              actionText: LangKeys.retry.tr,
              onActionPressed: () {
                controller.providerRatings();
              },
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              controller.providerRatings();
            },
            child: ListView.builder(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              itemCount: controller.rateList.length,
              itemBuilder: (context, index) {
                return PItemRating(
                  data: controller.rateList[index],
                  onTap: () {},
                );
              },
            ),
          );
        },
      ),
    );
  }
}
