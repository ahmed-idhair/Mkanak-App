import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/extensions/color.dart';
import 'package:mkanak/app/routes/app_routes.dart';
import 'package:mkanak/modules/user/orders/controller/orders_controller.dart';
import 'package:mkanak/modules/user/orders/view/item_order.dart';

import '../../../../app/translations/lang_keys.dart';
import '../../../../app/widgets/app_bar/custom_app_bar.dart';
import '../../../../app/widgets/common/app_empty_state.dart';
import '../../../../app/widgets/common/app_loading_view.dart';

class Orders extends StatelessWidget {
  Orders({super.key});

  OrdersController controller = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("FAFAFF"),
      appBar: CustomAppBar(title: LangKeys.orders.tr, isShowBack: false),
      body: GetBuilder<OrdersController>(
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
                return ItemOrder(
                  order: controller.orderList[index],
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.orderDetails,
                      arguments: {'orderId': controller.orderList[index].id},
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
