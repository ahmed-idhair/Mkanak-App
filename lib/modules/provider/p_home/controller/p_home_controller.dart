import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/widgets/common/app_bottom_sheet.dart';
import '../../../base_controller.dart';
import '../../../user/home_page/view/home_page.dart';
import '../../../user/orders/view/orders.dart';
import '../../../user/settings_page/view/settings_page.dart';
import '../../p_order_statistics/view/p_order_statistics.dart';
import '../../p_orders/view/p_orders.dart';
import '../../p_settings_page/view/p_settings_page.dart';

class PHomeController extends BaseController {
  // Current selected index
  final selectedIndex = 0.obs; // Start with Wishlist selected
  // Change selected index
  void changeIndex(int index) {
    if (index == 1) {
      if (storage.isAuth()) {
        selectedIndex.value = index;
      } else {
        confirmBottomSheet();
      }
    } else {
      selectedIndex.value = index;
    }
  }

  List<Widget> screens = [POrderStatistics(), POrders(), PSettingsPage()];
}
