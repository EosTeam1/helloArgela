import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../all/screen/start.dart';

import '../../customer/screen/profile.dart';

import '../../customer/widgets/log_item.dart';
import '../../primary_widgets.dart';

class driverHomeScreen extends StatefulWidget {
  const driverHomeScreen({Key? key}) : super(key: key);

  @override
  _driverHomeScreenState createState() => _driverHomeScreenState();
}

class _driverHomeScreenState extends State<driverHomeScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    fitchdata().then((value) {
      setState(() {
        _isLoading = false;
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
          backgroundColor: Colors.transparent,
          appBar: myAppBar(context: context),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('driverId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else {
                  return ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'الطلبات',
                            style: TextStyle(color: Color(0xfff5f5f5)),
                          ),
                        ],
                      ),
                      ...snapshot.data!.docs.map((e) {
                        if (e['orderPOS'] == 'waiting') {
                          return userLogItem(
                            isDriver: true,
                            date: e['date'],
                            price: e['total'],
                            ismanager: false,
                            id: e['orderId'],
                            order: e['order'],
                            total: e['total'],
                            carpon: e['carpon'],
                            pos: e['orderPOS'],
                            lat: e['lat'],
                            lng: e['lng'],
                            token: e['token'],
                            image: e['image'],
                            finName: e['finName'],
                            finNum: e['finNum'],
                            juicePrice: e['juiceNum'],
                            juiseName: e['juiceName'],
                            driverToken: e['driverToken'] ?? null,
                          );
                        } else {
                          return Container();
                        }
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'الطلبات السابقة',
                            style: TextStyle(color: Color(0xfff5f5f5)),
                          ),
                        ],
                      ),
                      ...snapshot.data!.docs.map((e) {
                        if (e['orderPOS'] != 'waiting') {
                          return userLogItem(
                            isDriver: true,
                            date: e['date'],
                            price: e['total'],
                            ismanager: false,
                            id: e['orderId'],
                            order: e['order'],
                            total: e['total'],
                            carpon: e['carpon'],
                            pos: e['orderPOS'],
                            lat: e['lat'],
                            lng: e['lng'],
                            token: e['token'],
                            image: e['image'],
                            finName: e['finName'],
                            finNum: e['finNum'],
                            juicePrice: e['juiceNum'],
                            juiseName: e['juiceName'],
                            driverToken: e['driverToken'] ?? null,
                          );
                        } else {
                          return Container();
                        }
                      }),
                    ],
                  );
                }
              })),
          drawer: Drawer(
            backgroundColor: Color(0xff1e223a),
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
                          color: Color(0xfff5f5f5)),
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
                      'تقييم',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'tawasul',
                          color: Color(0xfff5f5f5)),
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
                          color: Color(0xfff5f5f5)),
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
      FirebaseFirestore.instance.collection('orders');
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> items;

  int? val;

  Future<void> fitchdata() async {
    await ref
        .where('orderPOS', isEqualTo: 'waiating2')
        .where('driverId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        items = value.docs;
        val = value.docs.length;
      });
    });
    if (val! > 0) {
      return;
    }
    await ref
        .where('orderPOS', isEqualTo: 'waiating3')
        .where('driverId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        items = value.docs;
        val = value.docs.length;
      });
      if (val == 0) {
        return;
      }
    });
    await ref
        .where('orderPOS', isEqualTo: 'done1')
        .where('driverId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        items = value.docs;
        val = value.docs.length;
      });
      if (val == 0) {
        return;
      }
    });
    print(val);
  }
}
