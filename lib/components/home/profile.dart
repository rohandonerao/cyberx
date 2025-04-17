// profile_page.dart
// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ProfilePage extends StatefulWidget {
  final Function(String) onProfilePicUpdated;

  const ProfilePage({Key? key, required this.onProfilePicUpdated})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameC = TextEditingController();
  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  String? downloadUrl;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    getDate();
  }

  getDate() async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        setState(() {
          nameC.text = userSnapshot.docs.first['name'];
          id = userSnapshot.docs.first.id;
          profilePic = userSnapshot.docs.first['profilePic'];
        });
      } else {
        print('No user data found.');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSaving
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.pink,
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Center(
                  child: Form(
                    key: key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "UPDATE YOUR PROFILE",
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(height: 15),
                        GestureDetector(
                          onTap: () async {
                            final picker = ImagePicker();
                            final XFile? pickedImage = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Pick Image From"),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.camera),
                                          title: Text("Camera"),
                                          onTap: () async {
                                            Navigator.pop(
                                              context,
                                              await picker.pickImage(
                                                source: ImageSource.camera,
                                                imageQuality: 50,
                                              ),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.photo_library),
                                          title: Text("Gallery"),
                                          onTap: () async {
                                            Navigator.pop(
                                              context,
                                              await picker.pickImage(
                                                source: ImageSource.gallery,
                                                imageQuality: 50,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            if (pickedImage != null) {
                              setState(() {
                                profilePic = pickedImage.path;
                              });
                            }
                          },
                          child: Container(
                            child: profilePic == null
                                ? CircleAvatar(
                                    radius: 80,
                                    child: Center(
                                      child: Icon(Icons.add_photo_alternate,
                                          size: 80),
                                    ),
                                  )
                                : profilePic!.contains('http')
                                    ? CircleAvatar(
                                        radius: 80,
                                        backgroundImage:
                                            NetworkImage(profilePic!),
                                      )
                                    : CircleAvatar(
                                        radius: 80,
                                        backgroundImage:
                                            FileImage(File(profilePic!)),
                                      ),
                          ),
                        ),
                        TextFormField(
                          controller: nameC,
                          decoration: InputDecoration(
                            hintText: "Enter your name",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 50, left: 50, bottom: 50),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (key.currentState!.validate()) {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                                profilePic == null
                                    ? Fluttertoast.showToast(
                                        msg: 'Please select profile picture')
                                    : update();
                              }
                            },
                            child: Text("UPDATE"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<String?> uploadImage(String filePath) async {
    try {
      final filenName = Uuid().v4();
      final Reference fbStorage =
          FirebaseStorage.instance.ref('profile').child(filenName);
      final UploadTask uploadTask = fbStorage.putFile(File(filePath));
      final TaskSnapshot taskSnapshot = await uploadTask;
      if (taskSnapshot.state == TaskState.success) {
        downloadUrl = await fbStorage.getDownloadURL();
        return downloadUrl;
      } else {
        Fluttertoast.showToast(msg: 'Image upload failed');
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to upload image: $e');
      return null;
    }
  }

  update() async {
    setState(() {
      isSaving = true;
    });
    uploadImage(profilePic!).then((value) {
      if (value != null) {
        Map<String, dynamic> data = {
          'name': nameC.text,
          'profilePic': downloadUrl,
        };
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update(data)
            .then((_) {
          setState(() {
            isSaving = false;
          });
          widget.onProfilePicUpdated(downloadUrl!); // Call callback function
          Navigator.pop(context); // Navigate back to the previous page
        }).catchError((error) {
          setState(() {
            isSaving = false;
          });
          Fluttertoast.showToast(msg: 'Failed to update profile: $error');
        });
      } else {
        setState(() {
          isSaving = false;
        });
        Fluttertoast.showToast(msg: 'Failed to upload image');
      }
    });
  }
}
