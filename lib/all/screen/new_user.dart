import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../customer/screen/home.dart';
import '../../primary_widgets.dart';

class newUserScreen extends StatefulWidget {
  const newUserScreen({Key? key}) : super(key: key);

  @override
  _newUserScreenState createState() => _newUserScreenState();
}

String name = '';
String place = '';

class _newUserScreenState extends State<newUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: 310,
            child: Image.asset(
              'assets/logo/smoke.jpg',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: myAppBar(context: context),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: primaryCard(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        color: Color(0xff1E223A),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: TextField(
                                style: TextStyle(
                                    color: Color(0xfff5f5f5), fontSize: 18),
                                onChanged: (val) {
                                  setState(() {
                                    name = val;
                                  });
                                },
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    label: Center(
                                        child: Text(
                                      'الاسم',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontFamily: 'tawasul',
                                        color: Colors.white,
                                      ),
                                    ))),
                              ),
                              padding: EdgeInsets.fromLTRB(55, 0, 55, 0),
                            ),
                            Container(
                              child: TextField(
                                style: TextStyle(
                                    color: Color(0xfff5f5f5), fontSize: 18),
                                onChanged: (val) {
                                  setState(() {
                                    place = val;
                                  });
                                },
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    label: Center(
                                        child: Text(
                                      'العنوان',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontFamily: 'tawasul',
                                        color: Colors.white,
                                      ),
                                    ))),
                              ),
                              padding: EdgeInsets.fromLTRB(55, 0, 55, 0),
                            ),
                            InkWell(
                              onTap: () {
                                uploadPhotop();
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xfff5f5f5),
                                    image: imageUrl == null
                                        ? DecorationImage(
                                            image: AssetImage(
                                              'assets/logo/cam.png',
                                            ),
                                            scale: 1.5)
                                        : DecorationImage(
                                            image: NetworkImage(imageUrl))),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: !_isLoadingImage &&
                                        name != '' &&
                                        place != ''
                                    ? () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        String? token;
                                        await OneSignal.shared
                                            .getDeviceState()
                                            .then((value) {
                                          token = value?.userId;
                                        });
                                        FirebaseAuth.instance.currentUser!
                                            .updateDisplayName('$name')
                                            .then((value) {
                                          FirebaseFirestore.instance
                                              .collection('user')
                                              .doc(
                                                  'a${FirebaseAuth.instance.currentUser!.uid}')
                                              .set({
                                            'name': name,
                                            'place': place,
                                            'phone': FirebaseAuth.instance
                                                .currentUser!.phoneNumber,
                                            'type': 'user',
                                            'id': FirebaseAuth
                                                .instance.currentUser!.uid,
                                            'token': '${token}'
                                          }).then((value) {
                                            FirebaseAuth.instance.currentUser!
                                                .updatePhotoURL('$imageUrl');
                                          }).then((value) =>
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                    return userHomeScreen();
                                                  })));
                                        }).then(
                                          (value) {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          },
                                        );
                                      }
                                    : null,
                                child: SizedBox(
                                  width: 187,
                                  height: 47,
                                  child: Center(
                                    child: Text(
                                      'تسجيل',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontFamily: 'tawasul',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      width: 293,
                      hight: 344),
                ),
        )
      ],
    );
  }

  final ImagePicker _picker = ImagePicker();
  File? pickedImage;
  bool _isLoading = false;
  bool _isLoadingImage = false;
  Future uploadPhotop() async {
    setState(() {
      _isLoadingImage = true;
    });
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value == null) {
        return;
      }
      try {
        pickedImage = File(value.path);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user')
            .child('p${Random().nextInt(100)}.jpg');
        ref
            .putFile(pickedImage!)
            .then((_) => ref.getDownloadURL().then((value) {
                  imageUrl = value;
                }))
            .then((value) {
          setState(() {
            _isLoadingImage = false;
          });
        });
      } catch (e) {
        return;
      }
    });
  }

  var imageUrl;
}
