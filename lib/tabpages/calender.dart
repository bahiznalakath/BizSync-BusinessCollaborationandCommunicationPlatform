import 'package:bizsync/Api/api.dart';
import 'package:bizsync/auth/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({Key? key}) : super(key: key);

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  String getDayName(int day) {
    List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[day - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calender',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {},
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
      body: content(),
    );
  }

  Widget content() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          "" + getDayName(today.weekday),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          "  ${today.day}/${today.month}/${today.year}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Container(
          child: TableCalendar(
            locale: "en_US",
            rowHeight: 43,
            headerStyle:
                HeaderStyle(formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, today),
            focusedDay: today,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            onDaySelected: _onDaySelected,
          ),
        )
      ],
    );
  }
}
