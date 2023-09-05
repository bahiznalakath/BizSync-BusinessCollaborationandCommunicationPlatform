import 'dart:developer';
import 'dart:io';
import 'package:bizsync/Api/api.dart';
import 'package:bizsync/auth/login_screen.dart';
import 'package:bizsync/helper/dialogs.dart';
import 'package:bizsync/models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

//profile screen for sign in information
class Profile_Page extends StatefulWidget {
  final ChatUser user;

  const Profile_Page({super. key, required this.user}) ;

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  late Size mq;
  final formKey = GlobalKey<FormState>();
  String? _image;

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
        appBar: AppBar(
          title: const Text(
            'Profile Screen',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          backgroundColor: Colors.white,
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              Dialogs.showProgressBar(context);
              await APIs.updateActiveStatus(false);
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  //foe hiding progess dialog
                  Navigator.pop(context);
                  APIs.auth=FirebaseAuth.instance;
                  //for moving to home screen
                  Navigator.pop(context);
                  //replacing home screen with login screen
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const Loginscreen()));
                });
              });
            },
            icon: Icon(Icons.logout),
            label: const Text('LogOut'),
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Stack(children: [
                    //profile picture
                    _image != null
                        ?
                        //local image
                        ClipRRect(
                            borderRadius: BorderRadius.circular(mq.height * .1),
                            child: Image.file(File(_image!),
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.cover))
                        :

                        //image from server
                        ClipRRect(
                            borderRadius: BorderRadius.circular(mq.height * .1),
                            child: CachedNetworkImage(
                              width: mq.height * .2,
                              height: mq.height * .2,
                              fit: BoxFit.cover,
                              imageUrl: widget.user.image,
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                      child: Icon(CupertinoIcons.person)),
                            ),
                          ),

                    SizedBox(
                      height: 20,
                    ),
                    //edit image button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        onPressed: () {
                          _showBottomSheet();
                        },
                        elevation: 2,
                        shape: const CircleBorder(),
                        color: Colors.white,
                        child: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 8,
                  ),
                  //user email label
                  Text(
                    widget.user.email,
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required field",
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: "eg,Happy Singh",
                        label: Text('Name')),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required field",
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: "eg,feeling Happy",
                        label: Text('about')),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * .5,
                            MediaQuery.of(context).size.width * .06)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          Dialogs.showSnackbar(
                              context, "Profile Updated Successfully");
                        });
                      }
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 28,
                    ),
                    // Wrap Icons.edit with Icon widget
                    label: const Text(
                      "Update",
                      style: TextStyle(fontSize: 16),
                    ), // Specify the label using the label parameter
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
            EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              const Text('Pick a Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              SizedBox(height: mq.height * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.onPrimary,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/add_image.png')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.onPrimary,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}