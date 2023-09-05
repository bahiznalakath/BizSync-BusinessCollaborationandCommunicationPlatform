import 'package:bizsync/Api/api.dart';
import 'package:bizsync/auth/login_screen.dart';
import 'package:bizsync/auth/profile_screen.dart';
import 'package:bizsync/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../ThemeMode/theme_manager.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<ChatUser> list = [];
  ThemeManager _themeManager =ThemeManager();
  bool varNotify1 = true;
  bool varNotify2 = false;
  bool varNotify3 = false;

  // for storing search status
  bool _isSearching = false;

  onchangeFuction1(bool newValue1) {
    setState(() {
     Switch(value:_themeManager.themeMode== ThemeMode.dark,onChanged: _themeManager.toggleTheme(varNotify2));

    });
  }

  onchangeFuction2(bool newValue2) {
    setState(() {
      varNotify2 = newValue2;
    });
  }

  onchangeFuction3(bool newValue3) {
    setState(() {
      varNotify3 = newValue3;
    });
  }

  void _exitApp() {
    SystemNavigator.pop(); // Exit the app
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
            //if search is on & back button is pressed then close search
            //or else simple close current screen on back button click
            onWillPop: () {
              if (_isSearching) {
                setState(() {
                  _isSearching = !_isSearching;
                });
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: Scaffold(
                appBar: AppBar(
                  title:_isSearching
                      ? TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Change Password ,Account Settings'),
                    autofocus: true,
                    style: TextStyle(fontSize: 16, letterSpacing: 1),
                    onChanged: (val) {

                    },
                  )
                      :  Text(
                    'Settings',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  backgroundColor: Colors.white,
                  actions: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                          });
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        )),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Profile_Page(
                                        user: APIs.me,
                                      )));
                        },
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: Colors.black,
                        )),
                  ],
                ),
                body: Container(
                  padding: const EdgeInsets.all(10),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Profile_Page(
                                            user: APIs.me,
                                          )));
                            },
                            child: Text(
                              "Account",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 20,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildAccountOption(context, "Change Password"),
                      buildAccountOption(context, "Content Settings"),
                      buildAccountOption(context, "Social"),
                      buildAccountOption(context, "Language"),
                      buildAccountOption(context, "Privacy and Security "),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.volume_up_outlined,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Notifications",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Divider(
                        height: 20,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      buildNotification(
                          'Theme Dark', varNotify1, onchangeFuction1),
                      buildNotification(
                          'Account active ', varNotify2, onchangeFuction2),
                      buildNotification(
                          'Opportunity', varNotify3, onchangeFuction3),
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: _exitApp,
                        child: Text('Exit from application'),
                      ),
                      Center(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () async {
                            await APIs.auth.signOut();
                            await GoogleSignIn().signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => Loginscreen()),
                            );
                          },
                          child: Text(
                            "SIGN OUT",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.2,
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ))));
  }

  Padding buildNotification(String title, bool value, Function onchangeMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),
          ),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Colors.blue,
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue) {
                onchangeMethod(newValue);
              },
            ),
          )
        ],
      ),
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Option 1"),
                    Text("option 2"),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("close"))
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.grey[600]),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[600])
          ],
        ),
      ),
    );
  }
}
