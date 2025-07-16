import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../base_controller.dart';

class SplashController extends BaseController {
  var hasInternet = false.obs; // Observable for internet status
  var isLoading = true.obs;
  var locationSheetShown = false.obs;

  // final fcmService = FCMService();

  // Update check variables
  var isCheckingUpdate = false.obs;
  var updateAvailable = false.obs;
  var forceUpdate = false.obs;

  // var appConfig = <AppConfig>[].obs;

  @override
  void onInit() {
    super.onInit();
    checkInternetConnection();
  }

  void checkAuth() async {
    // Initialize FCM service
    // await fcmService.init();
    // Check for app updates if internet is available
    if (hasInternet.value) {
      navigateToNextScreen();
    }
  }

  void navigateToNextScreen() {
    Future.delayed(Duration(milliseconds: 3000), () {
      // if (storage.isIntro()) {
      if (storage.isAuth()) {
        if (storage.getUser()?.type == "0") {
          Get.offAllNamed(AppRoutes.home);
        }else{
          Get.offAllNamed(AppRoutes.pHome);
        }
      } else {
        Get.offAllNamed(AppRoutes.signIn);
      }
      // } else {
      //   Get.offAllNamed(AppRoutes.onBoarding);
      // }
    });
  }

  Future<void> checkInternetConnection() async {
    isLoading.value = true; // Show splash screen
    final connectivityResults = await Connectivity().checkConnectivity();
    // Check if any result in the list indicates a connected state
    if (connectivityResults.contains(ConnectivityResult.mobile) ||
        connectivityResults.contains(ConnectivityResult.wifi)) {
      hasInternet.value = true;
    } else {
      hasInternet.value = false;
    }

    isLoading.value = false; // Hide splash screen when done
  }

  void retryConnection() {
    checkInternetConnection(); // Retry internet check
  }
}
