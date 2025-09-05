import 'package:get/get.dart';
import 'package:sellify/screens/account_screen.dart';
import 'package:sellify/screens/addProduct/adcommonpost.dart';
import 'package:sellify/screens/addProduct/addVehicle/addbikes.dart';
import 'package:sellify/screens/addProduct/addVehicle/addc_vehicle.dart';
import 'package:sellify/screens/addProduct/addVehicle/addcar_detail.dart';
import 'package:sellify/screens/addProduct/addimages.dart';
import 'package:sellify/screens/addProduct/addjob_detail.dart';
import 'package:sellify/screens/addProduct/addlocation_screen.dart';
import 'package:sellify/screens/addProduct/addmobiles.dart';
import 'package:sellify/screens/addProduct/addprice_screen.dart';
import 'package:sellify/screens/addProduct/addproduct_screen.dart';
import 'package:sellify/screens/addProduct/addproperties.dart';
import 'package:sellify/screens/addProduct/addservices.dart';
import 'package:sellify/screens/addProduct/reviewyourdetail.dart';
import 'package:sellify/screens/auth_screens/forgot_pass.dart';
import 'package:sellify/screens/auth_screens/otp_screen.dart';
import 'package:sellify/screens/bottombar_screen.dart';
import 'package:sellify/screens/categorylist_screen.dart';
import 'package:sellify/screens/categoryseeall_screen.dart';
import 'package:sellify/firebase/chat_screen.dart';
import 'package:sellify/screens/chooselocation.dart';
import 'package:sellify/screens/favourite_screen.dart';
import 'package:sellify/screens/favourite_view.dart';
import 'package:sellify/screens/featured_view.dart';
import 'package:sellify/screens/myads_screen.dart';
import 'package:sellify/screens/featuredseeall.dart';
import 'package:sellify/screens/home_screen.dart';
import 'package:sellify/screens/loginscreen.dart';
import 'package:sellify/screens/myads_view.dart';
import 'package:sellify/screens/CommonadsSeeall.dart';
import 'package:sellify/screens/onboardingscreen.dart';
import 'package:sellify/screens/profileposts_screen.dart';
import 'package:sellify/screens/resetpassword.dart';
import 'package:sellify/screens/selectelang_first.dart';
import 'package:sellify/screens/signupscreen.dart';
import 'package:sellify/screens/splesh_screen.dart';
import 'package:sellify/screens/subcategory_screen.dart';
import 'package:sellify/screens/viewdata_screen.dart';

import '../screens/paymentfail_screen.dart';
import '../screens/successful_screen.dart';

class Routes{
  static String initial = "/";
  static String onBoardingScreen = "/OnBoardingScreen";
  static String paymentfailScreen = "/PaymentfailScreen";
  static String loginScreen = "/Loginscreen";
  static String successfulScreen = "/SuccessfulScreen";
  static String signupScreen = "/Signupscreen";
  static String otpScreen = "/OtpScreen";
  static String forgotPassword = "/ForgotPassword";
  static String resetPassword = "/Resetpassword";
  static String selectLang = "/SelectelangFirst";
  static String chooseLocation = "/Chooselocation";
  static String pinLocationScreen = "/PinlocationScreen";
  static String chooseJobType = "/ChoosejobType";
  static String bottomBarScreen = "/BottombarScreen";
  static String homePage = "/HomePage";
  static String chatListScreen = "/ChatlistScreen";
  static String favouriteScreen = "/ChatlistScreen";
  static String accountScreen = "/AccountScreen";
  static String viewdataScreen = "/ViewdataScreen";
  static String categorylistScreen = "/CategorylistScreen";//
  static String categoryseeallScreen = "/CategoryseeallScreen";
  static String profilepostsScreen = "/ProfilepostsScreen";
  static String featuredseeall = "/Featuredseeall";
  static String addproductScreen = "/AddproductScreen";
  static String addcarDetail = "/AddcarDetail";
  static String addImages = "/AddImages";
  static String addpriceScreen = "/AddpriceScreen";
  static String reviewyourdetail = "/Reviewyourdetail";
  static String addjobDetail = "/AddjobDetail";
  static String addproperties = "/Addproperties";
  static String addmobiles = "/Addmobiles";
  static String addbikes = "/Addbikes";
  static String addcVehicle = "/AddcVehicle";
  static String adcommonpost = "/Adcommonpost";
  static String addservices = "/Addservices";
  static String myadsView = "/MyadsView";
  static String CommonadsSeeall = "/CommonadsSeeall";
  static String featuredView = "/FeaturedView";
  static String favouriteView = "/FavouriteView";
}

final getPages = [
  GetPage(
      name: Routes.initial,
      page: () => const SpleshScreen(),
  ),
  GetPage(
      name: Routes.paymentfailScreen,
      page: () => const PaymentfailScreen(),
  ),
  GetPage(
      name: Routes.onBoardingScreen,
      page: () => const OnBoardingscreen(),
  ),
  GetPage(
    name: Routes.loginScreen,
    page: () => const Loginscreen(),
  ),
  GetPage(
    name: Routes.signupScreen,
    page: () => const Signupscreen(),
  ),
  GetPage(
    name: Routes.otpScreen,
    page: () => const OtpScreen(),
  ),
  GetPage(
    name: Routes.forgotPassword,
    page: () => const ForgotPassword(),
  ),
  GetPage(
    name: Routes.resetPassword,
    page: () => const Resetpassword(),
  ),
  GetPage(
    name: Routes.selectLang,
    page: () => const SelectelangFirst(),
  ),
  GetPage(
    name: Routes.chooseLocation,
    page: () => const Chooselocation(),
  ),
  GetPage(
    name: Routes.bottomBarScreen,
    page: () => const BottombarScreen(),
  ),
  GetPage(
    name: Routes.homePage,
    page: () => const HomePage(),
  ),
  GetPage(
    name: Routes.favouriteScreen,
    page: () => const FavouriteScreen(),
  ),
  GetPage(
    name: Routes.accountScreen,
    page: () => const AccountScreen(),
  ),
  GetPage(
    name: Routes.categoryseeallScreen,
    page: () => const CategoryseeallScreen(),
  ),
  GetPage(
    name: Routes.profilepostsScreen,
    page: () => const ProfilepostsScreen(),
  ),
  GetPage(
    name: Routes.featuredseeall,
    page: () => const Featuredseeall(),
  ),
  GetPage(
    name: Routes.addproductScreen,
    page: () => const AddproductScreen(),
  ),
  GetPage(
    name: Routes.addcarDetail,
    page: () => const AddcarDetail(),
  ),
  GetPage(
    name: Routes.addImages,
    page: () => const AddImages(),
  ),
  GetPage(
    name: Routes.addpriceScreen,
    page: () => const AddpriceScreen(),
  ),
  GetPage(
    name: Routes.reviewyourdetail,
    page: () => const Reviewyourdetail(),
  ),
  GetPage(
    name: Routes.addjobDetail,
    page: () => const AddjobDetail(),
  ),
  GetPage(
    name: Routes.addproperties,
    page: () => const Addproperties(),
  ),
  GetPage(
    name: Routes.addmobiles,
    page: () => const Addmobiles(),
  ),
  GetPage(
    name: Routes.addbikes,
    page: () => const Addbikes(),
  ),
  GetPage(
    name: Routes.addcVehicle,
    page: () => const AddcVehicle(),
  ),
  GetPage(
    name: Routes.adcommonpost,
    page: () => const Adcommonpost(),
  ),
  GetPage(
    name: Routes.addservices,
    page: () => const Addservices(),
  ),
  GetPage(
    name: Routes.myadsView,
    page: () => const MyadsView(),
  ),
  GetPage(
    name: Routes.CommonadsSeeall,
    page: () => const CommonadsSeeall(),
  ),
  GetPage(
    name: Routes.favouriteView,
    page: () => const FavouriteView(),
  ),
  GetPage(
    name: Routes.successfulScreen,
    page: () => const SuccessfulScreen(),
  ),
];