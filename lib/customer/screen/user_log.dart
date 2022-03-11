import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../primary_widgets.dart';
import '../../provider.dart';
import '../widgets/log_item.dart';

class userLogScreen extends StatefulWidget {
  const userLogScreen({Key? key, required this.isManager}) : super(key: key);
  final isManager;

  @override
  _userLogScreenState createState() => _userLogScreenState();
}

class _userLogScreenState extends State<userLogScreen> {
  List log = ['', 'a'];
  bool _isloading = false;
  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    if (!widget.isManager) {
      fitchData().then((value) => fitchData2()).then((value) {
        setState(() {
          _isloading = false;
        });
      });
    } else {
      fitchManagerData().then((value) => fitchManagerData2()).then((value) {
        setState(() {
          _isloading = false;
        });
      });
    }

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
              ? Center(child: CircularProgressIndicator())
              : StreamBuilder(
                  stream: widget.isManager
                      ? FirebaseFirestore.instance
                          .collection('orders')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('orders')
                          .where('id',
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
                                widget.isManager ? 'الطلبات' : 'طلبك الحالي',
                                style: TextStyle(color: Color(0xfff5f5f5)),
                              ),
                            ],
                          ),
                          ...snapshot.data!.docs.map((e) {
                            if (e['orderPOS'] == 'waiting') {
                              return userLogItem(
                                isDriver: false,
                                date: e['date'],
                                price: e['total'],
                                ismanager: widget.isManager,
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
                                widget.isManager
                                    ? 'الطلبات السابقة'
                                    : 'الطلبات السابقة',
                                style: TextStyle(color: Color(0xfff5f5f5)),
                              ),
                            ],
                          ),
                          ...snapshot.data!.docs.map((e) {
                            if (e['orderPOS'] != 'waiting') {
                              return userLogItem(
                                isDriver: false,
                                date: e['date'],
                                price: e['total'],
                                ismanager: widget.isManager,
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
        )
      ],
    );
  }

  Query<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('orders');
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> items;
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> items2;
  int? val;

  Future<void> fitchData() async {
    await ref
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('orderPOS', isNotEqualTo: 'done')
        .get()
        .then((value) {
      setState(() {
        items2 = value.docs;
        val = value.docs.length;
      });
    });
  }

  Future<void> fitchData2() async {
    await ref
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('orderPOS', isEqualTo: 'done')
        .get()
        .then((value) {
      setState(() {
        items = value.docs;
        val = value.docs.length;
      });
    });
  }

  Future<void> fitchManagerData() async {
    await ref.where('orderPOS', isEqualTo: 'waiting').get().then((value) {
      setState(() {
        items2 = value.docs;
        val = value.docs.length;
      });
    });
  }

  Future<void> fitchManagerData2() async {
    await ref.where('orderPOS', isNotEqualTo: 'waiting').get().then((value) {
      setState(() {
        items = value.docs;
        val = value.docs.length;
      });
    });
  }
}
