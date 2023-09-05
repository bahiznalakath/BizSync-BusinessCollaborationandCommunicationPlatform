import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  late UserCredential _userCredential;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _createAccount() async {
    try {
      _userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: 'your_password', // Replace with actual password
      );

      if (_userCredential.user != null) {
        await _uploadImageAndSaveData();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Account Created"),
              content: Text("Your account has been created successfully."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      print("Error: ${e.message}");
    }
  }

  Future<void> _uploadImageAndSaveData() async {
    if (_image != null) {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${_userCredential.user!.uid}.jpg');

      final UploadTask uploadTask = storageReference.putFile(_image!);
      final TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() {});
      final String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userCredential.user!.uid)
          .set({
        'username': _usernameController.text,
        'email': _emailController.text,
        'about': _aboutController.text,
        'profileImageUrl': downloadUrl,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Account",
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: _image == null
                      ? CircleAvatar(
                          radius: 50.0,
                          child: Icon(Icons.add_a_photo),
                        )
                      : CircleAvatar(
                          radius: 50.0,
                          backgroundImage: FileImage(_image!),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.supervised_user_circle_outlined),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a username.";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an email address.";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _aboutController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.info),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "About",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please provide some information about yourself.";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an email address.";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an email address.";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an email address.";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _createAccount();
                    }
                  },
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
