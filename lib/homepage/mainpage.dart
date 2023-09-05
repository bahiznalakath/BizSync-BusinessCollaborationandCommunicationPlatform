import 'package:bizsync/tabpages/calender.dart';
import 'package:bizsync/tabpages/chat.dart';
import 'package:bizsync/tabpages/contacts.dart';
import 'package:bizsync/tabpages/meethomepage.dart';
import 'package:bizsync/tabpages/settings.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MeetHomePage(),
    ChatHomePage(),
    Contacts(),
    CalenderPage(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: 14,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Meet",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page_sharp),
            label: "Contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
