import 'package:get/get.dart';

import '../../modules/change_password/view/change_password.dart';
import '../../modules/contact_us/view/contact_us.dart';
import '../../modules/forgot_password/view/forgot_password.dart';
import '../../modules/help_support/view/help_support.dart';
import '../../modules/language/view/language_screen.dart';
import '../../modules/new_password/view/new_password.dart';
import '../../modules/page/view/page_view.dart';
import '../../modules/provider/add_service/view/add_service.dart';
import '../../modules/provider/add_work_time/view/add_work_time.dart';
import '../../modules/provider/p_home/view/p_home.dart';
import '../../modules/provider/p_order_details/view/p_order_details.dart';
import '../../modules/provider/p_ratings/view/p_ratings.dart';
import '../../modules/provider/p_services_page/view/p_services_page.dart';
import '../../modules/provider/p_work_time/view/p_work_time.dart';
import '../../modules/provider/wallet_screen/view/wallet_screen.dart';
import '../../modules/sign_in/view/sign_in.dart';
import '../../modules/sign_up/view/sign_up.dart';
import '../../modules/splash/view/splash.dart';
import '../../modules/user/edit_profile/view/edit_profile.dart';
import '../../modules/user/home/view/home.dart';
import '../../modules/user/new_order/view/new_order.dart';
import '../../modules/user/order_details/view/order_details.dart';
import '../../modules/user/profile/view/profile.dart';
import '../../modules/user/select_location/view/select_location.dart';
import '../../modules/user/services_page/view/services_page.dart';
import '../../modules/verification_code/view/verification_code.dart';
import 'app_routes.dart';

final appPages = [
  GetPage(name: AppRoutes.splash, page: () => const Splash()),
  GetPage(name: AppRoutes.signIn, page: () => SignIn()),
  GetPage(name: AppRoutes.signUp, page: () => SignUp()),
  GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPassword()),
  GetPage(name: AppRoutes.newPassword, page: () => NewPassword()),
  GetPage(name: AppRoutes.verificationCode, page: () => VerificationCode()),
  GetPage(name: AppRoutes.pageView, page: () => PageView()),
  GetPage(name: AppRoutes.contactUs, page: () => ContactUs()),
  GetPage(name: AppRoutes.helpSupport, page: () => HelpSupport()),
  GetPage(name: AppRoutes.home, page: () => Home()),
  GetPage(name: AppRoutes.servicesPage, page: () => ServicesPage()),
  GetPage(name: AppRoutes.profile, page: () => Profile()),
  GetPage(name: AppRoutes.editProfile, page: () => EditProfile()),
  GetPage(name: AppRoutes.changePassword, page: () => ChangePassword()),
  GetPage(name: AppRoutes.selectLocation, page: () => SelectLocation()),
  GetPage(name: AppRoutes.newOrder, page: () => NewOrder()),
  GetPage(name: AppRoutes.orderDetails, page: () => OrderDetails()),
  GetPage(name: AppRoutes.languageScreen, page: () => LanguageScreen()),


  ///////
  GetPage(name: AppRoutes.pHome, page: () => PHome()),
  GetPage(name: AppRoutes.pServicesPage, page: () => PServicesPage()),
  GetPage(name: AppRoutes.addService, page: () => AddService()),
  GetPage(name: AppRoutes.pWorkTime, page: () => PWorkTime()),
  GetPage(name: AppRoutes.addWorkTime, page: () => AddWorkTime()),
  GetPage(name: AppRoutes.pRatings, page: () => PRatings()),
  GetPage(name: AppRoutes.pOrderDetails, page: () => POrderDetails()),
  GetPage(name: AppRoutes.walletScreen, page: () => WalletScreen()),
];
