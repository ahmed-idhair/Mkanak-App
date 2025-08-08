import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';
import 'custom_bottom_navbar.dart';

class Home extends StatelessWidget {
  Home({super.key});

  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    print('Log controller.selectedIndex.value ${controller.selectedIndex.value}');
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: CustomHomeAppBar(),
      body: SafeArea(
        child: Obx(() => controller.screens[controller.selectedIndex.value]),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
