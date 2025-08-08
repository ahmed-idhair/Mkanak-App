import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/p_home_controller.dart';
import 'p_ustom_bottom_navbar.dart';

class PHome extends StatelessWidget {
  PHome({super.key});

  PHomeController controller = Get.put(PHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: CustomHomeAppBar(),
      body: SafeArea(
        child: Obx(() => controller.screens[controller.selectedIndex.value]),
      ),
      bottomNavigationBar: const PCustomBottomNavBar(),
    );
  }
}
