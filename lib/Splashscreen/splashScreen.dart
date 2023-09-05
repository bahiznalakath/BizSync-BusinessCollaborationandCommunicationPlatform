import 'package:bizsync/Api/api.dart';
import 'package:bizsync/auth/login_screen.dart';
import 'package:bizsync/homepage/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  // void initState() {
  //   super.initState();
  //
  //   // Simulate a delay to display the splash screen
  //   Future.delayed(Duration(seconds: 2), () {
  //     if (isLoggedIn) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => MainPage()),
  //       );
  //     } else {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => Loginscreen()),
  //       );
  //     }
  //   });
  // }


  // void initState() {
  //   super.initState();
  //   checkLoginStatus();
  // }

  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (APIs.auth.currentUser != null) {
        print('User:${APIs.auth.currentUser}');
        // print('UserAdditionalInfo: ${FirebaseAuth.instance.currentUser.additionalUserInfo}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Loginscreen()),
        );
      }
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blueAccent],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage("assets/images/logo.png"),
              ),
              SizedBox(height: 200),
              Center(
                child: SpinKitFadingCircle(
                  color: Colors.red,
                  size: 50.0,
                ),
              ),
              SizedBox(height: 130),
              Text(
                'Made By Indian ❤️',
                style: TextStyle(fontSize: 10,),
              )
            ],
          ),
        ),
      ),
    );
    // }
    // void checkLoginStatus() async {
    //   // Get the user's login status from the database.
    //   var isLoggedIn = await getUserLoginStatus();
    //
    //   // If the user is logged in, navigate them to the main page.
    //   if (isLoggedIn) {
    //     Navigator.pushReplacementNamed(context, '/main');
    //   } else {
    //     // Otherwise, navigate them to the login screen.
    //     Navigator.pushReplacementNamed(context, '/login');
    //   }
    // }
    // Future<bool> getUserLoginStatus() async {
    //   // Get the user's id from the shared preferences.
    //   var userId = await SharedPreferences.getInstance().getString('User');
    //
    //   // If the user id is not null, then the user is logged in.
    //   if (userId != null) {
    //     // Get the user's login status from the database.
    //     var isLoggedIn = await DatabaseHelper.getUserLoginStatus(userId);
    //
    //     return isLoggedIn;
    //   } else {
    //     // The user is not logged in.
    //     return false;
    //   }
  }
}
