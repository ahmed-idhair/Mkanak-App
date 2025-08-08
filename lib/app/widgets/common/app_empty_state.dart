import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../config/app_theme.dart';
import '../../extensions/color.dart';
import '../../utils/app_utils.dart';
import '../buttons/app_button.dart';
import '../forms/app_custom_text.dart';
import 'app_loading_view.dart';

/// Empty state widget
class AppEmptyState extends StatelessWidget {
  final String? title;
  final String message;
  final String? icon;
  final VoidCallback? onActionPressed;
  final String? actionText;

  const AppEmptyState({
    super.key,
    this.title,
    required this.message,
    this.icon,
    this.onActionPressed,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // تحديد الأحجام بناءً على المساحة المتاحة
        final availableHeight = constraints.maxHeight;
        final iconSize = availableHeight > 300 ? 100.0 : 60.0;
        final fontSize = availableHeight > 300 ? 14.0 : 12.0;
        final spacing = availableHeight > 300 ? 20.0 : 12.0;

        return Center(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: SvgPicture.asset(
                    AppUtils.getIconPath(icon ?? "ic_empty"),
                    width: iconSize.w,
                    height: iconSize.h,
                    placeholderBuilder: (BuildContext context) => SizedBox(
                      width: iconSize.w,
                      height: iconSize.h,
                      child: AppLoadingView(),
                    ),
                  ),
                ),
                SizedBox(height: spacing.h),
                Flexible(
                  child: AppCustomText(
                    text: message,
                    fontWeight: FontWeight.w500,
                    color: HexColor("404040"),
                    fontSize: fontSize.sp,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onActionPressed != null && actionText != null) ...[
                  SizedBox(height: spacing.h),
                  AppButton(
                    text: actionText!,
                    variant: ButtonVariant.primary,
                    onPressed: onActionPressed!,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}