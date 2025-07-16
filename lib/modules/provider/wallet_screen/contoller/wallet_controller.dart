import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:mkanak/core/models/wallet/wallet.dart';
import 'package:mkanak/modules/base_controller.dart';

import '../../../../app/widgets/common/app_bottom_sheet.dart';
import '../../../../core/api/api_constant.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/api/http_service.dart';

class WalletController extends BaseController {
  var isLoading = false.obs;
  var walletData = Rxn<Wallet>();

  @override
  void onInit() {
    super.onInit();
    getWallet();
  }

  Future<void> getWallet() async {
    try {
      // update(['updateList']);
      isLoading(true);
      final result = await httpService.request(
        url: ApiConstant.providerWallet,
        method: Method.GET,
      );
      // Process response
      if (result != null) {
        var response = ApiResponse.fromJsonModel( result.data, Wallet.fromJson);
        if (response.isSuccess && response.data != null) {
          walletData.value = response.data;
        } else {
          showErrorBottomSheet(response.message ?? "");
        }
      }
    } finally {
      // Hide loading indicator and update UI
      isLoading(false);
      // update(['updateList']);
    }
  }


  Future<void> refreshWallet() async {
    await getWallet();
  }


  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String formatTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
}
