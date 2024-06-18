import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibapp/Util/style.dart';
import 'package:ibapp/loader.dart';
import 'HomePage.dart';
import 'nav.dart'; 
import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await Firebase.initializeApp();
  await Future.delayed(const Duration(seconds: 1));
  // FlutterNativeSplash.remove();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.teal,
      statusBarBrightness: Brightness.light,
    ),
  );
    OneSignal.shared.setAppId("c2f6248a-3c61-4381-a341-c6aa815cca8d");

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {});
  OneSignal.shared
      .promptUserForPushNotificationPermission()
      .then((accepted) {});
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: CouleurPrincipale,
        useMaterial3: false,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: CouleurPrincipale),
      ),
      debugShowCheckedModeBanner: false,
      home:  Loading(),
    );
  }
}
