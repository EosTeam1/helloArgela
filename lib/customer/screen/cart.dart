import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import '../../all/screen/user_discouonts.dart';
import '../../primary_widgets.dart';
import '../../provider.dart';
import '../widgets/cart_item.dart';

class cartScreen extends StatefulWidget {
  const cartScreen({Key? key}) : super(key: key);

  @override
  State<cartScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> {
  int carpon = 0;
  num total = 0;
  int carpPrice = 0;
  int finNum = 0;
  int finPrice = 0;
  List ind = [];
  late int Price;
  bool _adding = false;
  @override
  bool _writing = false;
  String finName = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var juiceName = Provider.of<myProvider>(context).juiceName;
    var juice = Provider.of<myProvider>(context).juice;

    if (juice != null) {
      Price = Provider.of<myProvider>(context, listen: true).total +
          carpPrice +
          juice +
          finPrice;
    } else {
      Price = Provider.of<myProvider>(context, listen: true).total +
          carpPrice +
          finPrice;
    }

    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Image.asset(
              'assets/logo/smoke.jpg',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Provider.of<myProvider>(context).isDark
              ? Colors.transparent
              : Color(0xfff5f5f5),
          appBar: myAppBar(context: context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height:
                        MediaQuery.of(context).size.height < 926.0 ? 374 : 474,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ...Provider.of<myProvider>(context)
                            .items
                            .asMap()
                            .entries
                            .map((e) {
                          ind.add({e.key});
                          total = Provider.of<myProvider>(context).total;
                          print(total);

                          return cartItem(
                              juice: e.value['juice'],
                              fin: e.value['fin'],
                              name: e.value['name'],
                              price: e.value['price'],
                              num: e.value['num'],
                              index: e.key,
                              image: e.value['image'],
                              context: context);
                        }),
                        _adding
                            ? AnimatedOpacity(
                                opacity: _adding ? 1 : 0,
                                duration: Duration(milliseconds: 200),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        width: 354,
                                        height: 72,
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          color: Color(0xc01E223A),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                'فناجين',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'tawasul',
                                                  color: Color(
                                                    0xfff5f5f5,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 150,
                                                child: TextField(
                                                  style: TextStyle(
                                                      color: Color(0xfff5f5f5),
                                                      fontSize: 18),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      finName = val;
                                                      _writing = true;
                                                    });
                                                  },
                                                  onSubmitted: (v) {
                                                    setState(() {
                                                      _writing = false;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                      label: Center(
                                                          child: _writing
                                                              ? Container()
                                                              : Text(
                                                                  'اسم الخبطه',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'tawasul',
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ))),
                                                ),
                                              ),
                                              Text(
                                                '5,000',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'tawasul',
                                                  color: Color(
                                                    0xfff5f5f5,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          if (finNum >= 1) {
                                                            finNum -= 1;
                                                            finPrice -= 5000;
                                                          }
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.remove,
                                                        color:
                                                            Color(0xfffff669),
                                                      )),
                                                  Text(
                                                    '$finNum',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'tawasul',
                                                      color: Color(
                                                        0xfff5f5f5,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          finNum += 1;
                                                          finPrice += 5000;
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.add,
                                                        color:
                                                            Color(0xfffff669),
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                    SizedBox(
                                      width: 354,
                                      height: 72,
                                      child: Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        color: Color(0xc01E223A),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'فحم',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'tawasul',
                                                color: Color(
                                                  0xfff5f5f5,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '1,500',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'tawasul',
                                                color: Color(
                                                  0xfff5f5f5,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    if (carpon != 0) {
                                                      setState(() {
                                                        carpon -= 8;
                                                        carpPrice -= 1500;
                                                      });
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.remove,
                                                    size: 35,
                                                    color: Color(0xfffff669),
                                                  ),
                                                ),
                                                Text(
                                                  '$carpon',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'tawasul',
                                                      color: Color(0xfff5f5f5)),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        carpon += 8;

                                                        carpPrice += 1500;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.add,
                                                      size: 35,
                                                      color: Color(0xfffff669),
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        SizedBox(
                          width: 354,
                          height: 89,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Color(0xc01E223A),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'اضافات',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'tawasul',
                                    color: Color(
                                      0xfff5f5f5,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _adding = !_adding;
                                    });
                                  },
                                  icon: ImageIcon(_adding
                                      ? AssetImage('assets/logo/up.png')
                                      : AssetImage('assets/logo/down.png')),
                                  color: Color(0xfffff669),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                juice != null
                    ? SizedBox(
                        width: 500,
                        height: 100,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Color(0xc01E223A),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      Provider.of<myProvider>(context,
                                              listen: false)
                                          .juice = null;

                                      Provider.of<myProvider>(context,
                                              listen: false)
                                          .juiceName = null;
                                    });
                                  },
                                  child: Text(
                                    'حذف',
                                    style: TextStyle(
                                        color: Color(0xfffff669),
                                        fontSize: 15,
                                        fontFamily: 'tawasul'),
                                  )),
                              Text(
                                '$juice',
                                style: TextStyle(
                                    color: Color(0xfff5f5f5),
                                    fontSize: 20,
                                    fontFamily: 'tawasul'),
                              ),
                              Text(
                                juice == 25000 ? 'نصف كيلو' : ' كيلو',
                                style: TextStyle(
                                    color: Color(0xfff5f5f5),
                                    fontSize: 20,
                                    fontFamily: 'tawasul'),
                              ),
                              Text(
                                '$juiceName',
                                style: TextStyle(
                                    color: Color(0xfff5f5f5),
                                    fontSize: 16,
                                    fontFamily: 'tawasul'),
                              )
                            ],
                          ),
                        ))
                    : Container(),
                SizedBox(
                  width: 500,
                  height: 100,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Color(0xc01E223A),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          child: TextField(
                            readOnly: true,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('coming soon')));
                            },
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                label: Center(
                                    child: Text(
                                  'قسيمة التخفيض',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'tawasul',
                                    color: Colors.white,
                                  ),
                                ))),
                          ),
                          width: 150,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('coming soon')));
                            },
                            child: Text('تطبيق',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'tawasul',
                                )))
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 414,
                  height: 100,
                  color: Color(0xc01E223A),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return userDiscountScreen(ismanager: false);
                            }));
                          },
                          child: Text(
                            'الذهاب للعروض',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'tawasul',
                            ),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'العروض',
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'tawasul',
                                color: Color(0xfff5f5f5)),
                          ),
                          Text('احصل على تخفيض من خلال العروض ',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'tawasul',
                                  color: Color(0xfff5f5f5))),
                          Text(
                            'اللتي نقدمها لك',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'tawasul',
                                color: Color(0xfff5f5f5)),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            height: 142,
            decoration: BoxDecoration(
                color: Color(0xc01E223A),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '$Price',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'tawasul',
                          color: Color(0xfff5f5f5)),
                    ),
                    Text(
                      ':المبلغ',
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'tawasul',
                          color: Color(0xfff5f5f5)),
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return FunkyOverlay(
                              Price: total,
                              finName: finName,
                              finNum: finNum,
                              carpon: carpon,
                              carpPrice: carpPrice,
                            );
                          });
                    },
                    child: SizedBox(
                      width: 187,
                      height: 47,
                      child: Center(
                        child: Text(
                          'تآكيد',
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'tawasul',
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FunkyOverlay extends StatefulWidget {
  const FunkyOverlay({
    Key? key,
    required this.carpPrice,
    required this.carpon,
    required this.Price,
    required this.finName,
    required this.finNum,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FunkyOverlayState();

  final carpPrice;
  final carpon;
  final Price;
  final finName;
  final finNum;
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  String place = '';
  int price = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fitchdata();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  String place1 = 'a';

  @override
  Widget build(BuildContext context) {
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
            child: isLoading
                ? CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'تآكيد الطلب؟',
                        style: TextStyle(
                            color: Color(0xfff5f5f5),
                            fontFamily: 'tawasul',
                            fontSize: 20),
                      ),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: TextField(
                            onChanged: (e) {
                              setState(() {
                                place1 = e;
                              });
                            },
                            style: TextStyle(
                                color: Color(0xfff5f5f5),
                                fontFamily: 'tawasul'),
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                label: Text(
                                  'المنطقة',
                                  style: TextStyle(
                                      color: Color(0xfff5f5f5),
                                      fontFamily: 'tawasul',
                                      fontSize: 18),
                                )),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                    },
                              child: Text(
                                'رجوع',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'tawasul',
                                    fontWeight: FontWeight.bold),
                              )),
                          ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      fitchdata().then((value) async {
                                        await getlocation().then((value) async {
                                          Navigator.pop(context);
                                          await makeOrder();
                                        });
                                      });
                                    },
                              child: Text(
                                'تآكيد',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'tawasul',
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> makeOrder() async {
    if (place1 != 'a') {
      if (lat != null && lng != null) {
        OneSignal.shared.postNotification(
          OSCreateNotification(
            playerIds: tokens,
            heading: 'طلب جديد',
            content: 'طلب جديد',
          ),
        );

        int ran = Random().nextInt(100000);
        FirebaseFirestore.instance.collection('orders').doc('a$ran').set({
          'driverLat': null,
          'driverLng': null,
          'name': FirebaseAuth.instance.currentUser!.displayName,
          'phone': FirebaseAuth.instance.currentUser!.phoneNumber,
          'order': Provider.of<myProvider>(context, listen: false).items,
          'carpon': widget.carpon,
          'carpPrice': widget.carpPrice,
          'id': FirebaseAuth.instance.currentUser!.uid,
          'total': widget.Price,
          'orderPOS': 'waiting',
          'date':
              '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().hour}:${DateTime.now().minute}',
          'orderId': 'a$ran',
          'place': place1,
          'lat': lat,
          'lng': lng,
          'token': myToken,
          'finName': widget.finName,
          'finNum': widget.finNum,
          'juiceName':
              Provider.of<myProvider>(context, listen: false).juiceName,
          'juiceNum': Provider.of<myProvider>(context, listen: false).juice,
          'image': Provider.of<myProvider>(context, listen: false)
              .items
              .first['image'],
          'driverToken': null,
          'managerToken': tokens,
        }).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('تم ارسال الطلب'),
            )));
      } else {
        print('lllllllllllllllllllll');
      }
    }
    Provider.of<myProvider>(context, listen: false).clear();
  }

  String? myToken;
  CollectionReference<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('user');
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? managers;
  int? li;
  List<String> tokens = [];
  Future<void> fitchdata() async {
    await ref.where('type', isEqualTo: 'manager').get().then((value) {
      for (var element in value.docs) {
        tokens.add(element['token']);
      }
      li = value.docs.length;
    });
    OneSignal.shared.getDeviceState().then((value) {
      myToken = value!.userId;
    });
    print('-------------');
    print(tokens);
    print('-------------');
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
}
