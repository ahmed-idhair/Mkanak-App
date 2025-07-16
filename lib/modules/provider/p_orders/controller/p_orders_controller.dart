import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mkanak/app/widgets/common/app_bottom_sheet.dart';
import 'package:mkanak/core/models/order/order.dart';
import 'package:mkanak/modules/base_controller.dart';

import '../../../../app/widgets/feedback/app_toast.dart';
import '../../../../core/api/api_constant.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/api/http_service.dart';

class POrdersController extends BaseController {
  final RxBool isLoading = false.obs;
  var orderList = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (storage.isAuth()) {
      getOrders();
    }
  }

  Future<void> getOrders() async {
    try {
      update(['updateList']);
      isLoading(true);
      final result = await httpService.request(
        url: ApiConstant.providerOrders,
        method: Method.GET,
      );
      // Process response
      if (result != null) {
        var response = ApiResponse.fromJsonList<Order>(
          result.data,
          Order.fromJson,
        );
        if (response.isSuccess && response.data != null) {
          orderList.clear();
          orderList.addAll(response.data!);
        } else {
          showErrorBottomSheet(response.message ?? "");
        }
      }
    } finally {
      // Hide loading indicator and update UI
      isLoading(false);
      update(['updateList']);
    }
  }
}
