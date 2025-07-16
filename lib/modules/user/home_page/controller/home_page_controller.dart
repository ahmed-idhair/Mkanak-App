import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mkanak/modules/base_controller.dart';

import '../../../../app/widgets/feedback/app_toast.dart';
import '../../../../core/api/api_constant.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/api/http_service.dart';
import '../../../../core/models/categories.dart';

class HomePageController extends BaseController {
  final searchController = TextEditingController();
  final RxBool isLoading = false.obs;
  var categoriesList = <Categories>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCategories();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> getCategories() async {
    try {
      update(['updateList']);
      isLoading(true);
      final result = await httpService.request(
        url: ApiConstant.categories,
        method: Method.GET,
      );
      // Process response
      if (result != null) {
        var response = ApiResponse.fromJsonList<Categories>(
          result.data,
          Categories.fromJson,
        );
        if (response.isSuccess && response.data != null) {
          categoriesList.clear();
          categoriesList.addAll(response.data!);
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
}
