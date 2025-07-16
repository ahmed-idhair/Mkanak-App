import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/extensions/color.dart';
import 'package:mkanak/app/routes/app_routes.dart';

import '../../../../app/translations/lang_keys.dart';
import '../../../../app/widgets/app_bar/custom_app_bar.dart';
import '../../../../app/widgets/common/app_empty_state.dart';
import '../../../../app/widgets/common/app_loading_view.dart';
import '../controller/p_orders_controller.dart';
import 'p_item_order.dart';

class POrders extends StatelessWidget {
  POrders({super.key});

  POrdersController controller = Get.put(POrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("FAFAFF"),
      appBar: CustomAppBar(title: LangKeys.orders.tr, isShowBack: false),
      body: GetBuilder<POrdersController>(
        id: "updateList",
        builder: (controller) {
          if (controller.isLoading.value) {
            return AppLoadingView();
          }
          if (controller.orderList.isEmpty) {
            return AppEmptyState(
              message: LangKeys.noData.tr,
              actionText: LangKeys.retry.tr,
              onActionPressed: () {
                controller.getOrders();
              },
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              controller.getOrders();
            },
            child: ListView.builder(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              itemCount: controller.orderList.length,
              itemBuilder: (context, index) {
                return PItemOrder(
                  order: controller.orderList[index],
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.pOrderDetails,
                      arguments: {"orderId": controller.orderList[index].id},
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
