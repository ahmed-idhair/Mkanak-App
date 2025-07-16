import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mkanak/app/translations/lang_keys.dart';
import 'package:mkanak/app/widgets/app_bar/custom_app_bar.dart';
import 'package:mkanak/app/widgets/buttons/app_button.dart';
import 'package:mkanak/app/widgets/forms/app_custom_text.dart';
import 'package:mkanak/modules/user/select_location/controller/select_location_controller.dart';

class SelectLocation extends StatelessWidget {
  SelectLocation({super.key});

  final SelectLocationController controller = Get.put(
    SelectLocationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: LangKeys.selectLocation.tr),
      body: SafeArea(
        child: Column(
          children: [Expanded(child: _buildMap()), _buildBottomButton()],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        textAlign: TextAlign.right,
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'ابحث عن مكان',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16.sp),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 24.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          clipBehavior: Clip.hardEdge,
          child: Obx(
            () => GoogleMap(
              onMapCreated: controller.onMapCreated,
              onCameraMove: controller.onCameraMove,
              onCameraIdle: controller.onCameraIdle,
              initialCameraPosition: CameraPosition(
                target: controller.currentLocation.value,
                zoom: 15.0,
              ),
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              buildingsEnabled: true,
              trafficEnabled: false,
            ),
          ),
        ),
        _buildCenterMarker(),
        PositionedDirectional(
          bottom: 25.h,
          end: 20.w,
          child: _buildLocationButton(),
        ),
        // _buildMapInstructions(),
      ],
    );
  }

  Widget _buildCenterMarker() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: controller.markerAnimationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -controller.markerBounceAnimation.value),
                child: Transform.scale(
                  scale: controller.markerScaleAnimation.value,
                  child: Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(Icons.place, color: Colors.white, size: 35.sp),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: controller.markerAnimationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  -controller.markerBounceAnimation.value * 0.3,
                ),
                child: Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationButton() {
    return Obx(
      () => GestureDetector(
        onTap: controller.onLocationTap,
        child: Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child:
              controller.isLoading.value
                  ? Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  )
                  : Icon(
                    Icons.my_location,
                    color: const Color(0xFF6366F1),
                    size: 24.sp,
                  ),
        ),
      ),
    );
  }

  Widget _buildMapInstructions() {
    return Positioned(
      top: 16.h,
      left: 20.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pan_tool, color: Colors.white, size: 16.sp),
            SizedBox(width: 6.w),
            Text(
              'اسحب الخريطة لتحديد الموقع',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 12.h, start: 12.w, end: 12.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selected location info card
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: const Color(0xFFFF6B35),
                          size: 20.r,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppCustomText(
                              text: LangKeys.specificLocation.tr,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600]!,
                            ),
                            SizedBox(height: 4.h),
                            if (controller.isLoadingAddress.value)
                              Row(
                                children: [
                                  SizedBox(
                                    width: 12.w,
                                    height: 12.h,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFFFF6B35),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  AppCustomText(
                                    text: LangKeys.addressIsBeingDetermined.tr,
                                    fontSize: 12.sp,
                                    color: Colors.grey[500]!,
                                  ),
                                ],
                              )
                            else
                              AppCustomText(
                                text: controller.selectedLocationAddress.value,
                                fontSize: 13.sp,
                                color: Colors.grey[800]!,
                                maxLines: 2,
                                fontWeight: FontWeight.w600,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  /*
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.my_location,
                          color: Colors.grey[500],
                          size: 14.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'خط العرض: ${controller.selectedLocation.value.latitude.toStringAsFixed(6)}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey[600],
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_searching,
                          color: Colors.grey[500],
                          size: 14.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'خط الطول: ${controller.selectedLocation.value.longitude.toStringAsFixed(6)}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey[600],
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                   */
                ],
              ),
            ),
          ),

          AppButton(
            text: LangKeys.save.tr,
            onPressed: controller.onSaveAndFollow,
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
