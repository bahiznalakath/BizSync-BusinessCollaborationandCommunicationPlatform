import 'package:bizsync/Api/api.dart';
import 'package:bizsync/helper/my_date%20_util.dart';
import 'package:bizsync/models/Message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.message}) : super(key: key);
  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  Widget _blueMessage() {
    if (widget.message.read.isNotEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      print("message read updated ");
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                vertical: MediaQuery.of(context).size.width * .01),
            decoration: BoxDecoration(
                color: Colors.blue.shade100,
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * .1),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      imageUrl: widget.message.msg,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.55,
        ),
        //message time
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.04,
        )
      ],
    );
  }

//our or user messages
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 5,
            ),
            if (widget.message.read.isNotEmpty)
              Icon(
                Icons.done_all_outlined,
                color: Colors.blue,
                size: 20,
              ),
            SizedBox(
              width: 2,
            ),
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.55,
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                vertical: MediaQuery.of(context).size.width * .01),
            decoration: BoxDecoration(
                color: Colors.green.shade100,
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.height * .1),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.04,
        ),
      ],
    );
  }
}
