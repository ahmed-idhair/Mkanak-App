import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/widgets/app_bar/custom_app_bar.dart';
import 'package:mkanak/core/models/categories.dart';
import 'package:mkanak/modules/provider/add_service/controller/add_service_controller.dart';

import '../../../../app/widgets/buttons/app_button.dart';
import '../../../../app/widgets/common/app_loading_view.dart';
import '../../../../app/widgets/forms/app_drop_down.dart';

class AddService extends StatelessWidget {
  AddService({super.key});

  var controller = Get.put(AddServiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(title: LangKeys.add.tr),
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(16.r),
        child: Column(
          children: [
            GetBuilder<AddServiceController>(
              id: "selectCategory",
              builder: (controller) {
                if (controller.isLoadingCategory.isTrue) {
                  return const AppLoadingView();
                }
                return AppDropdown<Categories>(
                  label: LangKeys.category.tr,
                  items: controller.categoryList,
                  isRequired: true,
                  selectedItem: controller.selectCategory.value,
                  itemAsString: (country) => country.title ?? "",
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectCategory.value = value;
                      controller.update(['selectCategory']);
                      controller.servicesList.clear();
                      controller.services(
                        controller.selectCategory.value.id ?? 0,
                      );
                    }
                  },
                );
              },
            ),
            16.verticalSpace,
            GetBuilder<AddServiceController>(
              id: "selectService",
              builder: (controller) {
                if (controller.isLoadingService.isTrue) {
                  return const AppLoadingView();
                }
                if (controller.servicesList.isEmpty) {
                  return SizedBox();
                }
                return AppDropdown<Categories>(
                  label: LangKeys.services.tr,
                  items: controller.servicesList,
                  isRequired: true,
                  selectedItem: controller.selectService.value,
                  itemAsString: (country) => country.title ?? "",
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectService.value = value;
                      controller.update(['selectService']);
                    }
                  },
                );
              },
            ),
            31.verticalSpace,
            Obx(
              () => AppButton(
                text: LangKeys.save.tr,
                isLoading: controller.isLoading.value,
                onPressed: controller.validation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
