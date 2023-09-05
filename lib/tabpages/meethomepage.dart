import 'package:bizsync/Api/api.dart';
import 'package:bizsync/auth/profile_screen.dart';
import 'package:bizsync/helper/customButtons/MeetingButton.dart';
import 'package:flutter/material.dart';

class MeetHomePage extends StatelessWidget {
  MeetHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meet Page',
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 18,
              ),
              //   const CircleAvatar(
              //     radius: 34,
              //     child: Icon(
              //       Icons.supervised_user_circle_outlined,
              //       size: 70,
              //     ),
              //   ),
              //   const Text(
              //     'Start or Join a Meeting',
              //     style:
              //         const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              //   ),
              //   const SizedBox(
              //     height: 12,
              //   ),
              //   Text('Good Morning '),
              //   const SizedBox(
              //     height: 12,
              //   ),
              //   SizedBox(
              //     width: 350,
              //     height: 60,
              //     child: ElevatedButton(
              //       onPressed: () {},
              //       style: ButtonStyle(
              //         backgroundColor:
              //             MaterialStateProperty.all<Color>(Colors.white),
              //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //           RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(6),
              //             side: const BorderSide(
              //                 color: Colors.blue, width: 2), // Add blue border
              //           ),
              //         ),
              //       ),
              //       child: const Text(
              //         "START MEETING",
              //         style: TextStyle(color: Colors.black, fontSize: 18),
              //       ),
              //     ),
              //   ),
              //   const SizedBox(
              //     height: 12,
              //   ),
              //   SizedBox(
              //     width: 350,
              //     height: 60,
              //     child: ElevatedButton(
              //       onPressed: () {},
              //       style: ButtonStyle(
              //         backgroundColor:
              //             MaterialStateProperty.all<Color>(Colors.white),
              //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //           RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(6),
              //             side: const BorderSide(
              //                 color: Colors.blue, width: 2), // Add blue border
              //           ),
              //         ),
              //       ),
              //       child: const Text(
              //         "JOIN MEETING",
              //         style: TextStyle(color: Colors.black, fontSize: 18),
              //       ),
              //     ),
              //   ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HomeMeetingButton(
                      onPressed: () {
                        // Show a dialog to input the room ID
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            TextEditingController roomIdController =
                                TextEditingController();
                            return AlertDialog(
                              title: Text('Create  Room ID'),
                              // content: TextField(
                              //   controller: roomIdController,
                              //   decoration: InputDecoration(
                              //     hintText: 'Enter Room ID',
                              //   ),
                              // ),
                              actions: <Widget>[
                                Row(
                                  children: [
                                    TextButton(
                                      child: Text('Create New Meeting'),
                                      onPressed: () {
                                        // Get the room ID and do something with it
                                        String roomId = roomIdController.text;
                                        // You can now use the roomId for your meeting logic
                                        print('Room ID: $roomId');
                                        // Close the dialog
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    Column(
                                      children: [
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icons.videocam,
                      text: 'New meeting'),
                  HomeMeetingButton(
                      onPressed: () {
                        // Show a dialog to input the meeting ID
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            TextEditingController meetingIdController =
                                TextEditingController();
                            return AlertDialog(
                              title: Text('Join Meeting'),
                              content: TextField(
                                controller: meetingIdController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Meeting ID',
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Join'),
                                  onPressed: () {
                                    // Get the meeting ID and perform the join meeting logic
                                    String meetingId = meetingIdController.text;
                                    // Implement the logic to join the meeting using the meetingId
                                    print(
                                        'Joining meeting with ID: $meetingId');
                                    // Close the dialog
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icons.add_box_outlined,
                      text: 'Join meeting'),
                  HomeMeetingButton(
                      onPressed: () {},
                      icon: Icons.arrow_upward_rounded,
                      text: 'Share Screen'),
                ],
              ),
              SizedBox(
                height: 220,
              ),
              Center(
                child: Text(
                  'Create/Join Meetings with just a click!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
