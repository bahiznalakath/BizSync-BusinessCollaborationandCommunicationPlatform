import 'package:bizsync/Api/api.dart';
import 'package:bizsync/helper/my_date%20_util.dart';
import 'package:bizsync/helper/profile_dialog.dart';
import 'package:bizsync/models/Message.dart';
import 'package:bizsync/models/chat_user.dart';
import 'package:bizsync/widgets/ChatScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chat_User_Card extends StatefulWidget {
  final ChatUser user;

  const Chat_User_Card({Key? key, required this.user}) : super(key: key);

  @override
  State<Chat_User_Card> createState() => _Chat_User_CardState();
}

class _Chat_User_CardState extends State<Chat_User_Card> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: .04, vertical: 4),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) {
                _message = list[0];
              }
              return ListTile(
                leading: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => ProfileDialog(
                              user: widget.user,
                            ));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.3),
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.width * 0.055,
                      height: MediaQuery.of(context).size.width * 0.055,
                      imageUrl: widget.user.image,
                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                ),
                // leading: const CircleAvatar(child: ),
                title: Text(widget.user.name),
                // last message
                subtitle: Text(
                  _message != null
                      ? _message!.type == Type.image
                          ? "image"
                          : _message!.msg
                      : widget.user.about,
                  maxLines: 1,
                ),
                trailing: _message == null
                    ? null //show nothing when no messages is sent
                    : _message!.read.isEmpty &&
                            _message!.fromId != APIs.user.uid
                        ?
                        //show for unreaded message
                        Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.lightGreenAccent.shade400,
                            ),
                          )
                        //message sent time
                        : Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: TextStyle(color: Colors.black54),
                          ),
              );
            },
          )),
    );
  }
}
