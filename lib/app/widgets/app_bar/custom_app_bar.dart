import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/app_theme.dart';
import '../../extensions/color.dart';
import '../forms/app_custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  bool? isShowBack;
  bool? centerTitle;
  Color bgColor;
  Color titleColor;
  final List<Widget>? actions;

  CustomAppBar({
    required this.title,
    this.isShowBack = true,
    this.bgColor = AppTheme.primaryColor,
    this.titleColor = Colors.white,
    this.centerTitle = true,
    super.key,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        backgroundColor: bgColor,
        centerTitle: centerTitle,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        leading:
            isShowBack == true
                ? IconButton(
                  padding: EdgeInsetsDirectional.zero,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20.0.r,
                    color: titleColor,
                  ),
                  onPressed: () async {
                    Get.back();
                  },
                )
                : null,
        titleSpacing: 0,
        title: AppCustomText(
          text: title,
          fontSize: 16.sp,
          color: titleColor,
          fontWeight: FontWeight.w500,
        ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
