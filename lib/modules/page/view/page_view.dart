import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/widgets/common/app_loading_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../app/widgets/app_bar/custom_app_bar.dart';
import '../controller/page_view_controller.dart';

class PageView extends StatelessWidget {
  PageView({super.key});

  PageViewController controller = Get.put(PageViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: controller.title),
      body: SafeArea(
        child: Obx(
          () =>
              controller.isLoading.isFalse
                  ? Padding(
                    padding: EdgeInsets.all(5.0.r),
                    child: WebViewWidget(
                      controller: controller.webViewController,
                    ),
                  )
                  : const AppLoadingView(),
        ),
      ),
    );
  }
}
