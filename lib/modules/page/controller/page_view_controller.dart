import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as d;
import 'package:mkanak/core/api/api_constant.dart';
import 'package:mkanak/core/models/page_data.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../../app/widgets/feedback/app_toast.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';

import '../../base_controller.dart';

class PageViewController extends BaseController {
  var isLoading = false.obs;
  var data = "".obs;
  var title = "";
  var key = "";
  late WebViewController webViewController;

  // ..loadHtmlString('''
  //   <!DOCTYPE html>
  //   <html>
  //   <body>
  //   ${data.value}
  //   </body>
  //   </html>
  // ''')
  @override
  void onInit() {
    super.onInit();
    webViewController = WebViewController();
    title = Get.arguments['title'];
    key = Get.arguments['key'];
    getPage();
  }

  Future<void> getPage() async {
    try {
      isLoading(true);
      final result = await httpService.request(
          url: "${ApiConstant.pages}/$key", method: Method.GET);
      if (result != null) {
        var response = ApiResponse.fromJsonModel(
            result.data, PageData.fromJson);
        if (response.isSuccess && response.data != null) {
          data.value = response.data?.content ?? "";
          if (data.value != "") {
            webViewController = WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setBackgroundColor(const Color(0x00000000))
              ..loadHtmlString(data.value)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onProgress: (int progress) {
                    // Update loading bar.
                  },
                  onPageStarted: (String url) {},
                  onPageFinished: (String url) {
                    webViewController.runJavaScript('''
          document.body.setAttribute("dir", "${storage.getLanguageCode() == "ar" ? "rtl" : "ltr"}");
          document.body.style.textAlign = "${storage.getLanguageCode() == "ar" ? "right" : "left"}";
        ''');
                  },
                  onWebResourceError: (WebResourceError error) {},
                ),
              );
          }

        } else {
          AppToast.error(response.message);
        }
      }
    } finally {
      isLoading(false);
    }
  }
}
