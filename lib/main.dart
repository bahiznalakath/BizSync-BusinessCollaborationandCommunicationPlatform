import 'package:bizsync/Splashscreen/splashScreen.dart';
import 'package:bizsync/ThemeMode/theme_constants.dart';
import 'package:bizsync/ThemeMode/theme_manager.dart';
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

ThemeManager _themeManager =ThemeManager();


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose(){
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState(){
    _themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener(){
    if(mounted){
      setState((){

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BizSync',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
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
