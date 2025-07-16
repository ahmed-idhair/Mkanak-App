// Model for tab item
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../forms/app_custom_text.dart';

class TabItem {
  final String title;
  final String? count;

  TabItem({required this.title, this.count});
}

// Custom Tab Bar Widget
class CustomTabBar extends StatelessWidget {
  final List<TabItem> tabs;
  final Function(int)? onTabChanged;
  final int selectedIndex;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final Color? backgroundColor;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.onTabChanged,
    required this.selectedIndex,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor ?? Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children:
            tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    onTabChanged?.call(index);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    margin: EdgeInsetsDirectional.only(end: 8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x0d000000),
                          offset: Offset(0, 5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tab Text with Count
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppCustomText(
                              text: tab.title,
                              fontSize: 14.sp,
                              fontWeight:
                                  selectedIndex == index
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                              color:
                                  selectedIndex == index
                                      ? (selectedColor ?? Color(0xFFFFB800))
                                      : (unselectedColor ??
                                          Colors.grey.shade600),
                            ),
                            if (tab.count != null) ...[
                              SizedBox(width: 4.w),
                              AppCustomText(
                                text: tab.count!,
                                fontSize: 14.sp,
                                fontWeight:
                                    selectedIndex == index
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                color:
                                    selectedIndex == index
                                        ? (selectedColor ?? Color(0xFFFFB800))
                                        : (unselectedColor ??
                                            Colors.grey.shade600),
                              ),
                            ],
                          ],
                        ),

                        SizedBox(height: 8.h),

                        // Indicator Line
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: selectedIndex == index ? 60.w : 0,
                          height: 3.h,
                          decoration: BoxDecoration(
                            color:
                                selectedIndex == index
                                    ? (indicatorColor ?? Color(0xFFFFB800))
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
