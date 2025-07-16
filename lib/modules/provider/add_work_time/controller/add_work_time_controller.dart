import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/widgets/common/app_bottom_sheet.dart';
import 'package:mkanak/modules/provider/p_work_time/controller/p_work_time_controller.dart';

import '../../../../core/api/api_constant.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/api/http_service.dart';
import '../../../base_controller.dart';

class DayModel {
  final int value;
  final String name;

  DayModel({required this.value, required this.name});

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DayModel && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

// Controller for managing work time state
class AddWorkTimeController extends BaseController {
  final selectedDay = Rxn<DayModel>();
  final fromTime = '12:00'.obs;
  final toTime = '20:00'.obs;
  final isLoading = false.obs;

  final List<DayModel> daysOfWeek = [
    DayModel(value: 0, name: 'Sunday'),
    DayModel(value: 1, name: 'Monday'),
    DayModel(value: 2, name: 'Tuesday'),
    DayModel(value: 3, name: 'Wednesday'),
    DayModel(value: 4, name: 'Thursday'),
    DayModel(value: 5, name: 'Friday'),
    DayModel(value: 6, name: 'Saturday'),
  ];

  @override
  void onInit() {
    super.onInit();
    // Set default to Wednesday
    selectedDay.value = daysOfWeek[0];
  }

  void updateDay(DayModel? day) {
    selectedDay.value = day;
  }

  void updateFromTime(String time) {
    fromTime.value = time;
  }

  void updateToTime(String time) {
    toTime.value = time;
  }

  Future<void> selectTime(BuildContext context, bool isFromTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade600,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      if (isFromTime) {
        updateFromTime(formattedTime);
      } else {
        updateToTime(formattedTime);
      }
    }
  }

  void validation() async {
    if (selectedDay.value == null) {
      showErrorBottomSheet(LangKeys.selectDay.tr);
      return;
    }
    addDay();
  }

  Future<void> addDay() async {
    try {
      isLoading(true);
      Map<String, dynamic> body = {
        "day": selectedDay.value?.value ?? 0,
        "from_time": fromTime.value,
        "to_time": toTime.value,
      };
      final result = await httpService.request(
        url: ApiConstant.providerWorkingTimes,
        method: Method.POST,
        params: body,
      );
      if (result != null) {
        var data = ApiResponse.fromJson(result.data);
        if (data.isSuccess == true) {
          Get.find<PWorkTimeController>().providerWorkingTimes();
          showSuccessBottomSheet(
            data.message ?? "",
            onClick: () {
              Get.back();
              Get.back();
            },
          );
        } else {
          showErrorBottomSheet(data.message ?? "");
        }
      }
    } finally {
      isLoading(false);
    }
  }
}
