import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../../app/widgets/feedback/app_toast.dart';
import '../../../../core/api/api_constant.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/api/http_service.dart';
import '../../../../core/models/order_statistics.dart';
import '../../../base_controller.dart';

class POrderStatisticsController extends BaseController {
  var isLoading = false.obs;
  var statistics = Rxn<OrderStatistics>();


  @override
  void onInit() {
    super.onInit();
    getStatistics();
  }

  // Get statistics from API
  Future<void> getStatistics() async {
    try {
      isLoading(true);
      final result = await httpService.request(
        url: ApiConstant.providerOrderStatistics,
        method: Method.GET,
      );
      if (result != null) {
        var response = ApiResponse.fromJsonModel(
          result.data,
          OrderStatistics.fromJson,
        );
        if (response.isSuccess && response.data != null) {
          statistics.value = response.data!;
        } else {
          AppToast.error(response.message);
        }
      }
    } catch (e) {
      print('Error loading statistics: $e');
    } finally {
      isLoading(false);
    }
  }

  // Refresh statistics
  Future<void> refreshStatistics() async {
    await getStatistics();
  }
}
