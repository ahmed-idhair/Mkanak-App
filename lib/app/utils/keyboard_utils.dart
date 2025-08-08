import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Helper class للتعامل مع الكيبورد
class KeyboardUtils {
  /// إخفاء الكيبورد وإزالة الفوكس
  static Future<void> hideKeyboard(BuildContext context) async {
    // إزالة الفوكس من المجال الحالي
    FocusScope.of(context).unfocus();

    // إزالة الفوكس من المجال الأساسي (احتياطية)
    FocusManager.instance.primaryFocus?.unfocus();

    // إخفاء الكيبورد باستخدام SystemChannels
    try {
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
    } catch (e) {
      // في حالة فشل الـ system channel، لا نفعل شيء
      debugPrint('Failed to hide keyboard: $e');
    }
  }

  /// إخفاء الكيبورد مع تأخير
  static Future<void> hideKeyboardWithDelay(
      BuildContext context, {
        Duration delay = const Duration(milliseconds: 100),
      }) async {
    await hideKeyboard(context);
    await Future.delayed(delay);
  }

  /// التحقق من ظهور الكيبورد
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  /// الحصول على ارتفاع الكيبورد
  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }
}

/// Extension على BuildContext للاستخدام السهل
extension ContextKeyboardExtension on BuildContext {
  /// إخفاء الكيبورد
  Future<void> hideKeyboard() async {
    await KeyboardUtils.hideKeyboard(this);
  }

  /// إخفاء الكيبورد مع تأخير
  Future<void> hideKeyboardWithDelay([Duration? delay]) async {
    await KeyboardUtils.hideKeyboardWithDelay(
      this,
      delay: delay ?? const Duration(milliseconds: 100),
    );
  }

  /// التحقق من ظهور الكيبورد
  bool get isKeyboardVisible => KeyboardUtils.isKeyboardVisible(this);

  /// الحصول على ارتفاع الكيبورد
  double get keyboardHeight => KeyboardUtils.getKeyboardHeight(this);
}

/// Extension على Widget لإضافة إخفاء الكيبورد عند النقر
extension WidgetKeyboardExtension on Widget {
  /// إضافة إخفاء الكيبورد عند النقر خارج النص
  Widget dismissKeyboardOnTap() {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () => context.hideKeyboard(),
          child: this,
        );
      },
    );
  }
}