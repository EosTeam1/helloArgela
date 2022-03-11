import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hello/customer/screen/profile.dart';
import 'package:hello/customer/screen/user_log.dart';
import 'package:provider/provider.dart';

import '../../all/screen/start.dart';
import '../../all/screen/user_discouonts.dart';
import '../../primary_widgets.dart';
import '../../provider.dart';
import '../widgets/juices.dart';
import '../widgets/user_item.dart';
import 'cart.dart';

class userHomeScreen extends StatefulWidget {
  userHomeScreen({Key? key}) : super(key: key);

  @override
  State<userHomeScreen> createState() => _userHomeScreenState();
}

bool _isloading = false;
bool isToggled = true;

class _userHomeScreenState extends State<userHomeScreen> {
  int? discount;
  @override
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
          appBar: myAppBar(context: context, actions: [
            IconButton(
              iconSize: 45,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return cartScreen();
                }));
              },
              icon: ImageIcon(
                AssetImage('assets/logo/cart.png'),
              ),
            )
          ]),
          body: _isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  children: [
                    ...items.map((items) {
                      return userItem(
                        price: discount ?? 10000,
                        name: items.get('name'),
                        id: items.get('id'),
                        ismanager: false,
                        imageUrl: items.get('imageUrl'),
                        fitchdata: fitchData(),
                      );
                    }),
                    const juice()
                  ],
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
                      'السلة',
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
                        return cartScreen();
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
                          ismanager: false,
                        );
                      })).then((value) {
                        setState(() {
                          discount = value;
                        });
                      });
                    },
                  ),
                  ListTile(
                    title: Text(
                      'طلباتك',
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
                          isManager: false,
                        );
                      }));
                    },
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
                    onTap: () {
                      FlutterPhoneDirectCaller.callNumber('+9647729222633');
                    },
                    title: Text(
                      'تواصل معنا',
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
                      Geolocator.getPositionStream().listen((event) {
                        setState(() {
                          print('${event.latitude}');
                        });
                      });
                    },
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
        ),
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
