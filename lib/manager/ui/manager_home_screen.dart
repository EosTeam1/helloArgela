import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hello/manager/ui/users_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../all/screen/start.dart';
import '../../all/screen/user_discouonts.dart';
import '../../customer/screen/profile.dart';
import '../../customer/screen/user_log.dart';
import '../../customer/widgets/user_item.dart';
import '../../primary_widgets.dart';
import '../../provider.dart';
import 'drivers_screen.dart';

class managerHome extends StatefulWidget {
  const managerHome({Key? key}) : super(key: key);

  @override
  _managerHomeState createState() => _managerHomeState();
}

class _managerHomeState extends State<managerHome> {
  bool isToggled = true;
  bool _isloading = false;
  void initState() {
    setState(() {
      _isloading = true;
    });
    fitchData().then((value) {
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

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
          appBar: myAppBar(context: context),
          body: _isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: fitchData,
                  child: GridView.builder(
                      itemCount: val,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              childAspectRatio: 1,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      itemBuilder: (BuildContext context, ind) {
                        return userItem(
                          price: 10000,
                          name: items[ind].get('name'),
                          id: items[ind].get('id'),
                          ismanager: true,
                          imageUrl: items[ind].get('imageUrl'),
                          fitchdata: fitchData(),
                        );
                      }),
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => FunkyOverlay(),
              ).then((value) => fitchData());
            },
            child: Icon(
              Icons.add,
              size: 40,
            ),
          ),
          drawer: Drawer(
            backgroundColor: Provider.of<myProvider>(context).isDark
                ? Color(0xff1e223a)
                : Color(0xfff5f5f5),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 183,
                    height: 183,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/logo/hooka.png'))),
                  ),
                  ListTile(
                    title: Text(
                      'الملف الشخصي',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'tawasul',
                          color: Provider.of<myProvider>(context).isDark
                              ? Color(0xfff5f5f5)
                              : Color(0xff1e223a)),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return profileScreen(
                          name: FirebaseAuth.instance.currentUser!.displayName,
                          phone: FirebaseAuth.instance.currentUser!.phoneNumber,
                          place: 'aa',
                          id: FirebaseAuth.instance.currentUser!.uid,
                        );
                      }));
                    },
                  ),
                  ListTile(
                    title: Text(
                      'الطلبات',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'tawasul',
                          color: Provider.of<myProvider>(context).isDark
                              ? Color(0xfff5f5f5)
                              : Color(0xff1e223a)),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return userLogScreen(
                          isManager: true,
                        );
                      }));
                    },
                  ),
                  ListTile(
                    title: Text(
                      'العروض',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'tawasul',
                          color: Provider.of<myProvider>(context).isDark
                              ? Color(0xfff5f5f5)
                              : Color(0xff1e223a)),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return userDiscountScreen(
                          ismanager: true,
                        );
                      }));
                    },
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return usersScreen();
                      }));
                    },
                    title: Text(
                      'المستخدمين',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'tawasul',
                          color: Provider.of<myProvider>(context).isDark
                              ? Color(0xfff5f5f5)
                              : Color(0xff1e223a)),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return driversScreen();
                      }));
                    },
                    title: Text(
                      'مندوبين التوصيل',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'tawasul',
                          color: Provider.of<myProvider>(context).isDark
                              ? Color(0xfff5f5f5)
                              : Color(0xff1e223a)),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 14,
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Text(
                          'الوضع الليلي',
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'tawasul',
                              color: Provider.of<myProvider>(context).isDark
                                  ? Color(0xfff5f5f5)
                                  : Color(0xff1e223a)),
                        ),
                      ),
                      Container(
                        width: 50,
                      ),
                      FlutterSwitch(
                        height: 20.0,
                        width: 40.0,
                        padding: 4.0,
                        toggleSize: 15.0,
                        borderRadius: 10.0,
                        activeColor: Provider.of<myProvider>(context).isDark
                            ? Color(0xfff5f5f5)
                            : Color(0xff1e223a),
                        value: isToggled,
                        onToggle: (value) {
                          setState(() {
                            isToggled = value;
                          });
                          Provider.of<myProvider>(context, listen: false)
                              .switchDark();
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text(
                      'تقييم',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'tawasul',
                          color: Provider.of<myProvider>(context).isDark
                              ? Color(0xfff5f5f5)
                              : Color(0xff1e223a)),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      FirebaseAuth.instance.signOut().then((value) =>
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return start();
                            }),
                          ));
                    },
                    title: Text(
                      'تسجيل خروج',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'tawasul',
                          color: Provider.of<myProvider>(context).isDark
                              ? Color(0xfff5f5f5)
                              : Color(0xff1e223a)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Query<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('items');
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> items;
  int? val;

  Future<void> fitchData() async {
    await ref.get().then((value) {
      setState(() {
        items = value.docs;
        val = value.docs.length;
      });
    });
  }
}

class FunkyOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  String place = '';
  int price = 0;
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    int rand = Random().nextInt(1000);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: 380,
            height: 360,
            decoration: ShapeDecoration(
                color: Color(0xaf1E223A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      uploadPhotop();
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xfff5f5f5)),
                      child:
                          pickedImage != null ? Image.file(pickedImage!) : null,
                    ),
                  ),
                  Container(
                      width: 210,
                      child: TextField(
                        style:
                            TextStyle(color: Color(0xfff5f5f5), fontSize: 18),
                        onChanged: (val) {
                          setState(() {
                            nam = val;
                          });
                        },
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            label: Center(
                              child: Text(
                                'اسم النكهه',
                                style: TextStyle(
                                    fontFamily: 'tawasul',
                                    color: Color(0xfff5f5f5),
                                    fontSize: 18),
                              ),
                            )),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        if (nam != 'a') {
                          FirebaseFirestore.instance
                              .collection('items')
                              .doc('$a')
                              .set({
                            'name': nam,
                            'id': a,
                            'imageUrl': imageUrl
                          }).then((value) => Navigator.of(context).pop());
                        }
                      },
                      child: Container(
                        width: 180,
                        height: 47,
                        child: Center(
                          child: Text(
                            'اضافة',
                            style:
                                TextStyle(fontSize: 32, fontFamily: 'tawasul'),
                          ),
                        ),
                      ))
                ]),
          ),
        ),
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  File? pickedImage;

  Future uploadPhotop() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value == null) {
        return;
      }
      try {
        pickedImage = File(value.path);
        final ref = FirebaseStorage.instance
            .ref()
            .child('item_mage')
            .child('p${Random().nextInt(100)}.jpg');
        ref
            .putFile(pickedImage!)
            .then((_) => ref.getDownloadURL().then((value) {
                  imageUrl = value;
                }));
      } catch (e) {
        return;
      }
    });
  }

  var imageUrl;

  String nam = 'a';

  int a = Random().nextInt(100);
}
