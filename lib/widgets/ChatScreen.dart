import 'dart:developer';
import 'dart:io';
import 'package:bizsync/Api/api.dart';
import 'package:bizsync/auth/Viewprofile_screen.dart';
import 'package:bizsync/helper/my_date%20_util.dart';
import 'package:bizsync/models/Message.dart';
import 'package:bizsync/models/chat_user.dart';
import 'package:bizsync/widgets/message_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  final _textController = TextEditingController();
  bool _showEmoji = false, _isUploading = false;

  @override
  void initState() {
    super.initState();
    _list = []; // Initialize the list here.
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          //if search is on & back button is pressed then close search
          //or else simple close current screen on back button click
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.blue.shade100,
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    // stream: APIs.firestore.collection('users').snapshots(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();
                        // return const Center(child: CircularProgressIndicator());
                        // if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          // Specify the type of the list elements
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];
                          // final _list = ['hi','hello'];
                          // //
                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * .01),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  message: _list[index],
                                );
                              },
                            );
                          }
                          else {
                            return  const Center(
                                child: Text(
                              'Say Hai......!✌️',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ));
                          }
                      }
                    },
                  ),
                ),
                //progress indicator for showing uploading
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(strokeWidth: 2))),
                _chatInput(),
                if (_showEmoji)
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        bgColor: Colors.blue.shade100,
                        columns: 8,
                        // initCategory: Category.FOODS,
                        emojiSizeMax: 32 *
                            (Platform.isIOS
                                ? 1.30
                                : 1.0), // Use 1.0 for web, 1.30 for iOS
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewProfile_Page(
                        user: widget.user,
                      )));
        },
        child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              return Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      )),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.3),
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.width * 0.10,
                      height: MediaQuery.of(context).size.width * 0.10,
                      imageUrl:
                          list.isNotEmpty ? list[0].image : widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        list.isNotEmpty ? list[0].name : widget.user.name,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        list.isNotEmpty
                            ? list[0].isOnline
                                ? 'online'
                                : MyDateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: list[0].lastActive)
                            : MyDateUtil.getLastActiveTime(
                                context: context,
                                lastActive: widget.user.lastActive),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      )
                    ],
                  )
                ],
              );
            }));
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: Colors.blue,
                        size: 25,
                      )),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji)
                        setState(() {
                          _showEmoji = !_showEmoji;
                        });
                    },
                    decoration: const InputDecoration(
                        hintText: "type something",
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final List<XFile> images =
                        await picker.pickMultiImage(imageQuality: 70);
                        for (var i in images) {
                          log('Image Path: ${i.path}');
                          setState(() => _isUploading = true);
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: Icon(
                        Icons.image,
                        color: Colors.blue,
                        size: 26,
                      )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() => _isUploading = true);
                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.blue,
                        size: 26,
                      )),
                  SizedBox(
                    width: 4,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              //when this button is clicked  we need to message
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  //on first message (add user to my_user collection of chat user)
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                }
                else {
                  //simply send message
                  APIs.sendMessage(widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
