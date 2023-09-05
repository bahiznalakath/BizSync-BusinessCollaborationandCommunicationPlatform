import 'package:bizsync/Api/api.dart';
import 'package:bizsync/helper/my_date%20_util.dart';
import 'package:bizsync/models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// view profile screen for sign in information
class ViewProfile_Page extends StatefulWidget {
  final ChatUser user;

  const ViewProfile_Page({super.key, required this.user});

  @override
  State<ViewProfile_Page> createState() => _ViewProfile_PageState();
}

class _ViewProfile_PageState extends State<ViewProfile_Page> {
  late Size mq;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the mq variable with the screen size
    mq = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //hiding for keyboared
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(title: Text(widget.user.name,style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
          ),
        backgroundColor: Colors.white,
          ),
          floatingActionButton: //user about
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined On: ',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              Text(
                  MyDateUtil.getLastMessageTime(
                      context: context,
                      time: widget.user.createdAt,
                      showYear: true),
                  style: const TextStyle(color: Colors.black54, fontSize: 15)),
            ],
          ),

          //body
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // for adding some space
                  SizedBox(width: mq.width, height: mq.height * .03),

                  //user profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  // for adding some space
                  SizedBox(height: mq.height * .03),

                  // user email label
                  Text(widget.user.email,
                      style:
                      const TextStyle(color: Colors.black87, fontSize: 16)),

                  // for adding some space
                  SizedBox(height: mq.height * .02),

                  //user about
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'About: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Text(widget.user.about,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}