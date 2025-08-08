import 'package:get/get.dart';

import '../../modules/language_controller.dart';



class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(LanguageController(), permanent: true);

  }
}
