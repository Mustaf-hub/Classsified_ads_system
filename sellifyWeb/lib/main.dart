
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/store_data.dart';
import 'package:sellify/firebase/chat_service.dart';
import 'package:sellify/language/language.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/screens/home_screen.dart';
import 'package:sellify/screens/splesh_screen.dart';
import 'package:sellify/utils/dark_lightMode.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'api_config/config.dart';
import 'firebase/chat_screen.dart';
import 'firebase_options.dart';
import 'helper/get_init.dart' as di;
import 'helper/scrollbehavior.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future<void> main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  paymentCheck();
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

  await GetStorage.init();
  await di.init();
  Permission.notification;
  WebViewPlatform.instance = WebWebViewPlatform();
  if(!kIsWeb) {
  MobileAds.instance.initialize();
  initPlatformState();
  await Permission.phone.request();
  await locationPermission();
  await requestStoragePermission();
  requestPermission();
  }
  listenFCM();
  loadFCM();
  initializeNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ColorNotifire()),
        ChangeNotifierProvider(create: (_) => ChatServices()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollerBehavior(),
        title: "Sellify",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          dividerColor: Colors.transparent,
          primaryColor: const Color(0xff3D5BF6),
          fontFamily: "Gilroy",
        ),
        locale: Locale(getData.read("lCode") ?? 'en' , 'US'),
        initialRoute: Routes.initial,
        getPages: getPages,
        translations: LocaleString(),
      ),
    );
  }

}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
}

void paymentCheck() {

}
Future<void> initPlatformState() async {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(Config.onesignalKey);
  OneSignal.Notifications.requestPermission(true).then((value) {
  },);
}