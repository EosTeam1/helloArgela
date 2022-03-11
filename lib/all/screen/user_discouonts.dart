import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../customer/widgets/discount_item.dart';
import '../../primary_widgets.dart';
import '../../provider.dart';

class userDiscountScreen extends StatefulWidget {
  final ismanager;

  userDiscountScreen({Key? key, required this.ismanager}) : super(key: key);

  @override
  State<userDiscountScreen> createState() => _userDiscountScreenState();
}

class _userDiscountScreenState extends State<userDiscountScreen> {
  bool _isloading = false;
  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    fitchData().then((value) {
      fitchdata();
    }).then((value) {
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
                  onRefresh: () {
                    return fitchData();
                  },
                  child: ListView(
                    children: [
                      ...items.map((e) {
                        if (e['year'] >= DateTime.now().year) {
                          if (e['month'] >= DateTime.now().month) {
                            if (e['day'] >= DateTime.now().day) {
                              print(e.get('place'));
                              print(placee);
                              return !widget.ismanager
                                  ? placee == e.data()['place']
                                      ? userDiscountItem(
                                          date:
                                              '${e['day']}/${e['month']}/${e['year']}',
                                          isManager: false,
                                          place: e.data()['place'],
                                          price: int.parse(e.data()['price']),
                                          id: e.data()['id'],
                                        )
                                      : Container()
                                  : userDiscountItem(
                                      date:
                                          '${e['day']}/${e['month']}/${e['year']}',
                                      isManager: true,
                                      place: e.data()['place'],
                                      price: int.parse(e.data()['price']),
                                      id: e.data()['id'],
                                    );
                            }
                          }
                        } else {
                          return Container();
                        }
                        return Container();
                      }),
                    ],
                  ),
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: widget.ismanager
              ? FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => FunkyOverlay(),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    size: 40,
                  ))
              : null,
        )
      ],
    );
  }

  Query<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('discount');

  late List<QueryDocumentSnapshot<Map<String, dynamic>>> items;

  late List<QueryDocumentSnapshot<Map<String, dynamic>>> items2;

  int? val;

  int? val2;

  Future<void> fitchData() async {
    await ref.get().then((value) {
      setState(() {
        items = value.docs;
        val = value.docs.length;
      });
    });
  }

  var ref2 = FirebaseFirestore.instance.collection('user');
  var placee;
  Future<void> fitchdata() async {
    ref2
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        placee = value.docs.single['place'];
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
  DateTime? _selected;
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
                    showDatePicker(
                            builder: (BuildContext context, child) {
                              return Theme(
                                  data: ThemeData.light().copyWith(
                                    primaryColor: const Color(0xFFfff669),
                                    accentColor: const Color(0xFFfff669),
                                    colorScheme: ColorScheme.light(
                                        primary: const Color(0xFFfff669)),
                                    buttonTheme: ButtonThemeData(
                                        textTheme: ButtonTextTheme.primary),
                                  ),
                                  child: DatePickerDialog(
                                      initialDate: DateTime.now(),
                                      lastDate: DateTime(2024),
                                      firstDate: DateTime.now()));
                            },
                            context: context,
                            initialDate: DateTime.now(),
                            lastDate: DateTime(2024),
                            firstDate: DateTime.now())
                        .then((value) {
                      setState(() {
                        _selected = value;
                      });
                    });
                  },
                  child: Image.asset(
                    'assets/logo/hooka.png',
                    width: 140,
                    height: 126,
                  ),
                ),
                Container(
                  width: 200,
                  child: TextField(
                    onChanged: (val) {
                      setState(() {
                        place = val;
                      });
                    },
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        label: Center(
                            child: Text(
                          'المنطقة',
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'tawasul',
                            color: Colors.white,
                          ),
                        ))),
                  ),
                ),
                Container(
                  width: 200,
                  child: TextField(
                    onChanged: (val) {
                      setState(() {
                        price = int.parse(val);
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        label: Center(
                            child: Text(
                          'السعر',
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'tawasul',
                            color: Colors.white,
                          ),
                        ))),
                  ),
                ),
                ElevatedButton(
                  onPressed: _selected == null
                      ? null
                      : () {
                          FirebaseFirestore.instance
                              .collection('discount')
                              .doc('$rand')
                              .set(
                            {
                              'place': place,
                              'price': '$price',
                              'id': rand,
                              'day': _selected!.day,
                              'month': _selected!.month,
                              'year': _selected!.year
                            },
                          ).then((value) => Navigator.of(context).pop());
                        },
                  child: Container(
                    width: 187,
                    height: 47,
                    child: Center(
                      child: Text(
                        'اضافة',
                        style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'tawasul',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
