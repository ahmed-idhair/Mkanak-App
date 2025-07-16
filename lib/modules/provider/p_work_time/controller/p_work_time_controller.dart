import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mkanak/app/widgets/common/app_bottom_sheet.dart';
import 'package:mkanak/modules/base_controller.dart';

import '../../../../app/widgets/feedback/app_toast.dart';
import '../../../../core/api/api_constant.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/api/http_service.dart';
import '../../../../core/models/categories.dart';
import '../../../../core/models/working_times.dart';

class PWorkTimeController extends BaseController {
  final RxBool isLoading = false.obs;
  var workingTimesList = <WorkingTimes>[].obs;

  @override
  void onInit() {
    super.onInit();
    providerWorkingTimes();
  }

  Future<void> providerWorkingTimes() async {
    try {
      update(['updateList']);
      isLoading(true);
      // Map<String, dynamic> params = {
      //   "category_id": Get.arguments['categoryId'],
      // };
      final result = await httpService.request(
        url: ApiConstant.providerWorkingTimes,
        method: Method.GET,
        // params: params
      );
      // Process response
      if (result != null) {
        var response = ApiResponse.fromJsonList<WorkingTimes>(
          result.data,
          WorkingTimes.fromJson,
        );
        if (response.isSuccess && response.data != null) {
          workingTimesList.clear();
          workingTimesList.addAll(response.data!);
        } else {
          AppToast.error(response.message);
        }
      }
    } finally {
      // Hide loading indicator and update UI
      isLoading(false);
      update(['updateList']);
    }
  }

  Future<void> deleteService(int dayId) async {
    try {
      EasyLoading.show();
      // Map<String, dynamic> params = {"service_id": serviceId};
      final result = await httpService.request(
        url: "${ApiConstant.providerWorkingTimes}/$dayId",
        method: Method.DELETE,
        // params: params,
      );
      // Process response
      if (result != null) {
        var response = ApiResponse.fromJson(result.data);
        if (response.isSuccess) {
          workingTimesList.removeWhere((element) => element.id == dayId);
          update(['updateList']);
        } else {
          showErrorBottomSheet(response.message);
        }
      }
    } finally {
      // Hide loading indicator and update UI
      EasyLoading.dismiss();
    }
  }
}
