import 'package:bizsync/Splashscreen/splashScreen.dart';
import 'package:bizsync/auth/login_screen.dart';
import 'package:bizsync/helper/utilis/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'homepage/mainpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BizSync',
      // theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: backgroundColor),
      routes: {
        '/': (context)=>  SplashScreen(),
        '/login': (context) => const Loginscreen(),
        '/main': (context) =>  MainPage(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,

    );
  }
}
