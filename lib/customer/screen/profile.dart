import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../primary_widgets.dart';
import '../../provider.dart';

class profileScreen extends StatefulWidget {
  const profileScreen(
      {Key? key,
      required this.name,
      required this.phone,
      required this.place,
      required this.id,
      this.isDriver,
      this.isUser})
      : super(key: key);
  final name;
  final phone;
  final place;
  final bool? isDriver;
  final bool? isUser;
  final id;
  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  bool editting = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Image.asset(
            'assets/logo/smoke.jpg',
            fit: BoxFit.fitWidth,
          ),
        ),
        Scaffold(
          backgroundColor: Provider.of<myProvider>(context).isDark
              ? Colors.transparent
              : Color(0xfff5f5f5),
          appBar: myAppBar(context: context, actions: [
            widget.isDriver == null
                ? editting
                    ? TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.currentUser!
                              .updatePhotoURL('$imageUrl')
                              .then((value) {
                            setState(() {
                              editting = false;
                            });
                          });
                        },
                        child: Text(
                          'تمت',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xfffff669),
                              fontFamily: 'tawasul'),
                        ))
                    : Container()
                : TextButton(
                    onPressed: () async {
                      if (widget.isDriver!) {
                        await FirebaseFirestore.instance
                            .collection('user')
                            .doc('a${widget.id}')
                            .update({'type': 'user'});
                      } else if (widget.isUser!) {
                        await FirebaseFirestore.instance
                            .collection('user')
                            .doc('a${widget.id}')
                            .update({'type': 'driver'});
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      widget.isDriver! ? 'تنزيل الى مستخدم' : 'ترقية الى سائق',
                      style: TextStyle(
                          color: Color(0xfffff669),
                          fontSize: 18,
                          fontFamily: 'tawasul'),
                    ))
          ]),
          body: _isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () async {
                            await uploadPhotop();
                          },
                          child: CircleAvatar(
                            backgroundImage: FirebaseAuth
                                        .instance.currentUser!.photoURL ==
                                    null
                                ? null
                                : NetworkImage(
                                    '${FirebaseAuth.instance.currentUser!.photoURL}'),
                            backgroundColor:
                                Provider.of<myProvider>(context).isDark
                                    ? Colors.white
                                    : Color(0xff1e223a),
                            radius: 75,
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${widget.name}',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color:
                                        Provider.of<myProvider>(context).isDark
                                            ? Colors.white
                                            : Color(0xff1e223a),
                                  ),
                                ),
                                Container(
                                  width: 12,
                                ),
                                Text(
                                  ':الاسم',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color:
                                        Provider.of<myProvider>(context).isDark
                                            ? Colors.white
                                            : Color(0xff1e223a),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${items}",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color:
                                        Provider.of<myProvider>(context).isDark
                                            ? Colors.white
                                            : Color(0xff1e223a),
                                  ),
                                ),
                                Text(
                                  ':العنوان',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color:
                                        Provider.of<myProvider>(context).isDark
                                            ? Colors.white
                                            : Color(0xff1e223a),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.phone}',
                          style: TextStyle(
                            fontSize: 30,
                            color: Provider.of<myProvider>(context).isDark
                                ? Colors.white
                                : Color(0xff1e223a),
                          ),
                        ),
                        Text(
                          ':رقم الهاتف',
                          style: TextStyle(
                            fontSize: 30,
                            color: Provider.of<myProvider>(context).isDark
                                ? Colors.white
                                : Color(0xff1e223a),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 15,
                    ),
                    Container(
                      width: 323,
                      height: 323,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: LatLng(lat!, lng!), zoom: 14),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          zoomControlsEnabled: false,
                        ),
                      ),
                    )
                  ],
                ),
        )
      ],
    );
  }

  Query<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('user');

  var items;

  int? val;
  var Image1;
  Future<void> fitchData() async {
    await ref
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        items = value.docs.single['place'];

        val = value.docs.length;
      });
    });
  }

  double? lat;
  double? lng;
  Future<void> getlocation() async {
    await GeolocatorPlatform.instance.requestPermission();
    await GeolocatorPlatform.instance.getCurrentPosition().then((value) {
      setState(() {
        lng = value.longitude;
        lat = value.latitude;
      });
    });
  }

  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    fitchData().then((value) => getlocation()).then((value) {
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  bool _isloading = false;
  final ImagePicker _picker = ImagePicker();
  File? pickedImage;

  Future uploadPhotop() async {
    setState(() {
      _isloading = true;
    });
    final XFile? image = await _picker
        .pickImage(source: ImageSource.gallery)
        .then((value) async {
      if (value == null) {
        return;
      }
      try {
        pickedImage = File(value.path);
        final ref = await FirebaseStorage.instance
            .ref()
            .child('user')
            .child('p${Random().nextInt(100)}.jpg');
        ref
            .putFile(pickedImage!)
            .then((_) => ref.getDownloadURL().then((value) {
                  imageUrl = value;
                }).then((value) {
                  setState(() {
                    _isloading = false;
                    editting = true;
                  });
                }));
      } catch (e) {
        return;
      }
    });
  }

  var imageUrl;
}
