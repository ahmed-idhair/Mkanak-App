import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/widgets/common/app_bottom_sheet.dart';
import '../../../base_controller.dart';
import '../../home_page/view/home_page.dart';
import '../../orders/view/orders.dart';
import '../../settings_page/view/settings_page.dart';

class HomeController extends BaseController {
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

  List<Widget> screens = [HomePage(), Orders(), SettingsPage()];
}
