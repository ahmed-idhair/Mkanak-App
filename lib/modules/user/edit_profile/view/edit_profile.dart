import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../app/translations/lang_keys.dart';
import '../../../../app/widgets/app_bar/custom_app_bar.dart';
import '../../../../app/widgets/buttons/app_button.dart';
import '../../../../app/widgets/common/app_loading_view.dart';
import '../../../../app/widgets/forms/app_drop_down.dart';
import '../../../../app/widgets/forms/app_phone_input.dart';
import '../../../../app/widgets/forms/app_text_field.dart';
import '../../../../core/models/countries.dart';
import '../controller/edit_profile_controller.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.editPersonalDetails.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          child: Column(
            children: [
              AppTextField(
                label: LangKeys.fullName.tr,
                hintText: LangKeys.enterFullName.tr,
                controller: controller.fullNameController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              20.verticalSpace,
              AppTextField(
                label: LangKeys.email.tr,
                // enabled: false,
                hintText: LangKeys.enterEmail.tr,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              20.verticalSpace,
              GetBuilder<EditProfileController>(
                id: "selectCountry",
                builder: (controller) {
                  if (controller.isLoadingCountry.isTrue) {
                    return const AppLoadingView();
                  }
                  return AppDropdown<Countries>(
                    label: LangKeys.chooseCountry.tr,
                    items: controller.items,
                    isRequired: true,
                    selectedItem: controller.selectCountry.value,
                    itemAsString: (country) => country.name ?? "",
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectCountry.value = value;
                        controller.update(['selectCountry']);
                      }
                    },
                  );
                },
              ),
              20.verticalSpace,
              AppPhoneInput(
                controller: controller.phoneController,
                enabled: false,
                // hintText: 'Enter your phone number',
                labelText: LangKeys.mobileNumber.tr,
                initialPhoneNumber: controller.user?.phoneNumber,
                // Pass existing number here
                onPhoneChanged: controller.onPhoneChanged,
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
      ),
    );
  }
}
