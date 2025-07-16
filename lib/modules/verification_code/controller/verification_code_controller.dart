import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/translations/lang_keys.dart';
import '../../../app/widgets/common/app_bottom_sheet.dart';
import '../../../app/widgets/feedback/app_toast.dart';
import '../../../core/api/api_constant.dart';
import '../../../core/api/api_response.dart';
import '../../../core/api/http_service.dart';
import '../../../core/models/user/user_data.dart';
import '../../base_controller.dart';

class VerificationCodeController extends BaseController {
  var pinController = TextEditingController();
  late Timer _timer;
  final RxInt start = 60.obs;
  var timeStr = "00:00".obs;
  String? from;
  String? token;
  String? phoneNumber;
  var isLoadingVerify = false.obs;
  var isLoadingResend = false.obs;

  // final FCMService _fcmService = FCMService();

  @override
  onInit() {
    super.onInit();
    from = Get.arguments['from'];
    phoneNumber = Get.arguments['phone_number'];
    token = Get.arguments['token'];
    // token = Get.arguments['token'] ?? "";
    startTimer();
  }

  Future<void> verifyMobile() async {
    try {
      Map<String, dynamic> body = {
        'phone_number': Get.arguments['phone_number'],
        "code": pinController.text,
        "is_signUp": from == AppRoutes.signUp || from == AppRoutes.signIn,
      };
      isLoadingVerify(true);
      final result = await httpService.request(
        url: ApiConstant.verify,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var data = ApiResponse.fromJsonModel(result.data, UserData.fromJson);
        if (data.isSuccess == true) {
          if (Get.arguments['from'] == AppRoutes.signUp ||
              Get.arguments['from'] == AppRoutes.signIn) {
            // var data = UserModel.fromJson(result.data);
            if (data.data != null) {
              // await _fcmService.subscribeToUsers();
              // await _fcmService.subscribeToUser(data.data!.user!.id!);
              showSuccessBottomSheet(
                data.message ?? "",
                textBtn: LangKeys.continueText.tr,
                onClick: () {
                  // storage.setUserToken(data.data!.token!);
                  // storage.setUser(data.data!.user!);
                  Get.back();
                  Get.offAllNamed(AppRoutes.signIn);
                },
              );
            } else {
              showErrorBottomSheet(data.message ?? "");
            }
          } else if (Get.arguments['from'] == AppRoutes.forgotPassword) {
            Get.toNamed(
              AppRoutes.newPassword,
              arguments: {
                "phone_number": Get.arguments['phone_number'],
                "code": pinController.text,
              },
            );
          }
        } else {
          showErrorBottomSheet(data.message);
          // UiErrorUtils.customSnackbar(
          //     title: LangKeys.error.tr, msg: data.message ?? "");
        }
      }
    } finally {
      isLoadingVerify(false);
    }
  }

  void startTimer() {
    start.value = 60;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (start.value == 0) {
        timer.cancel();
      } else {
        start.value == start.value--;
      }
      timeStr.value = intToTimeLeft(start.value);
    });
  }

  String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);
    //
    // String hourLeft = h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft = m.toString().length < 2 ? "0$m" : m.toString();

    String secondsLeft = s.toString().length < 2 ? "0$s" : s.toString();

    String result = "$minuteLeft:$secondsLeft";

    return result;
  }

  Future<void> sendVerificationCode() async {
    try {
      Map<String, String> body = {
        "phone_number": Get.arguments['phone_number'],
      };
      isLoadingResend(true);
      final result = await httpService.request(
        url: ApiConstant.resendOtp,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var data = ApiResponse.fromJsonModel(result.data, UserData.fromJson);
        if (data.isSuccess == true) {
          AppToast.success(data.message ?? "");
          // if (data.data != null &&
          //     data.data?.verification != null &&
          //     data.data?.verification?.token != null &&
          //     data.data?.verification?.token != "") {
          //   token = data.data?.verification?.token;
          startTimer();
          // }
        } else {
          AppToast.error(data.message ?? "");
        }
      }
    } finally {
      isLoadingResend(false);
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    _timer.cancel();
    super.dispose();
  }
}
