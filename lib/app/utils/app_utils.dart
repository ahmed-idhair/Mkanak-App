import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../translations/lang_keys.dart';

/// Flutter Utility functions
class AppUtils {
  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static String getImagePath(String name, {String format = 'png'}) {
    return 'assets/images/$name.$format';
  }

  static String getIconPath(String name, {String format = 'svg'}) {
    return 'assets/icons/$name.$format';
  }

  static String formatTimeTo12Hour(String time24) {
    try {
      // Handle both HH:mm and HH:mm:ss formats
      List<String> parts = time24.split(':');
      int hour = int.parse(parts[0]);
      String minute = parts[1];

      String period = hour >= 12 ? 'PM' : 'AM';
      int hour12 = hour % 12;
      if (hour12 == 0) hour12 = 12;

      return '$hour12:$minute $period';
    } catch (e) {
      return time24; // Return original if parsing fails
    }
  }

  static String formatDatedMMMMyyyy(String dateStr) {
    final DateTime date = DateTime.parse(dateStr);
    const List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    String day = date.day.toString().padLeft(2, '0');
    String month = monthNames[date.month - 1];
    String year = date.year.toString();

    return '$day $month $year';
  }

  static String timeAgo(String date) {
    final now = DateTime.now();
    DateTime dateTime = DateTime.parse(date);
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }


  static void shareAppLink(String textShare) {
    final String appName = 'Offers';
    final String appStoreLink = 'https://apps.apple.com/app/your-app-id';
    final String playStoreLink =
        'https://play.google.com/store/apps/details?id=your.package.name';
    final String message =
        '$appName\n\n'
        '$textShare\n\n'
        'Android: $playStoreLink\n\n'
        'iOS: $appStoreLink';

    Share.share(message);
  }


  static String getStatusText(String status) {
    switch (status) {
      case "0":
        return LangKeys.newO.tr;
      case "1":
        return LangKeys.accepted.tr;
      case "2":
        return LangKeys.complete.tr;
      case "3":
        return LangKeys.cancelled.tr;
      default:
        return 'غير محدد';
    }
  }

  // Get Status Color
  static Color getStatusColor(String status) {
    switch (status) {
      case "0":
        return Colors.blue; // جديد
      case "1":
        return Colors.orange; // مقبول
      case "2":
        return Colors.green; // مكتمل
      case "3":
        return Colors.red; // ملغى
      default:
        return Colors.grey;
    }
  }
}
