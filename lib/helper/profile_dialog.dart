import 'package:bizsync/models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: 8,
        height: 245,
        child: Stack(
          children: [
            Positioned(
              top:3 ,
              right: 130,

              child: Text(
                user.name,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: CachedNetworkImage(
                  width: 190,
                  height: 190,
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
            ),
            Positioned(
              // right: .1,
              top: .1,
                left: 210,
                child: MaterialButton(
                  onPressed: (){},
                  padding: EdgeInsets.all(0),
                  shape:CircleBorder(),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
