import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart' as intl_phone;
import 'package:mkanak/core/models/categories.dart';
import 'package:mkanak/core/models/user/user_data.dart';
import 'package:mkanak/modules/provider/p_services_page/controller/p_services_page_controller.dart';
import '../../../../app/translations/lang_keys.dart';
import '../../../../app/widgets/common/app_bottom_sheet.dart';
import '../../../../app/widgets/feedback/app_toast.dart';
import '../../../../app/widgets/forms/app_phone_input.dart';
import '../../../../core/api/api_constant.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/api/http_service.dart';
import '../../../../core/models/countries.dart';
import '../../../../core/models/user/user.dart';
import '../../../base_controller.dart';

class AddServiceController extends BaseController {
  final RxBool isLoading = false.obs;
  final RxBool isLoadingCategory = false.obs;
  var categoryList = <Categories>[].obs;
  Rx<Categories> selectCategory =
      Categories(title: LangKeys.category.tr, id: 0).obs;

  final RxBool isLoadingService = false.obs;
  var servicesList = <Categories>[].obs;
  Rx<Categories> selectService =
      Categories(title: LangKeys.services.tr, id: 0).obs;

  @override
  void onInit() {
    super.onInit();
    categories();
  }

  Future<void> validation() async {
    if (selectCategory.value.id == 0) {
      showErrorBottomSheet(LangKeys.category.tr);
      return;
    }
    if (selectService.value.id == 0) {
      showErrorBottomSheet(LangKeys.services.tr);
      return;
    }

    addService();
  }

  Future<void> addService() async {
    try {
      Map<String, dynamic> body = {
        "service_id": selectService.value.id,
        // "phone_number": fullMobile,
      };
      isLoading(true);

      final result = await httpService.request(
        url: ApiConstant.providerServices,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var data = ApiResponse.fromJson(result.data);
        if (data.isSuccess == true) {
          Get.find<PServicesPageController>().getServices();
          showSuccessBottomSheet(
            data.message ?? "",
            onClick: () {
              Get.back();
              Get.back();
            },
          );
          // AppToast.success(data.message ?? "");
        } else {
          showErrorBottomSheet(data.message ?? "");
        }
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> categories() async {
    try {
      // Show loading indicator
      isLoadingCategory(true);
      // Make API request
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

        // Update feedback reasons list if successful
        if (response.isSuccess && response.data != null) {
          categoryList.value = response.data!;
        } else {
          // Show error message
          AppToast.error(response.message);
        }
      }
    } finally {
      isLoadingCategory(false);
      update(['selectCategory']);
    }
  }

  Future<void> services(int catId) async {
    try {
      // Show loading indicator
      update(['selectService']);
      isLoadingService(true);
      // Make API request
      Map<String, dynamic> params = {"category_id": catId};
      final result = await httpService.request(
        url: ApiConstant.services,
        method: Method.GET,
        params: params,
      );
      // Process response
      if (result != null) {
        var response = ApiResponse.fromJsonList<Categories>(
          result.data,
          Categories.fromJson,
        );

        // Update feedback reasons list if successful
        if (response.isSuccess && response.data != null) {
          servicesList.value = response.data!;
        } else {
          // Show error message
          AppToast.error(response.message);
        }
      }
    } finally {
      isLoadingService(false);
      update(['selectService']);
    }
  }
}
