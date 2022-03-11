// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../../provider.dart';
import '../screen/cart.dart';

class userItem extends StatelessWidget {
  const userItem(
      {Key? key,
      required this.name,
      required this.ismanager,
      required this.id,
      required this.price,
      required this.imageUrl,
      required this.fitchdata})
      : super(key: key);
  final name;
  final ismanager;
  final id;
  final price;
  final imageUrl;
  final Future<void> fitchdata;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ismanager
          ? null
          : () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return FunkyOverlay(
                      price: price,
                      name: name,
                      id: id,
                      image: imageUrl,
                    );
                  });
            },
      child: SizedBox(
        width: 120,
        height: 140,
        child: Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.0),
          ),
          color: const Color(0xc01E223A),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 10,
                  ),
                  Center(
                    child: SizedBox(
                        width: 120,
                        height: 98,
                        child: imageUrl == null
                            ? Image.asset('assets/logo/hooka.png')
                            : Image.network(imageUrl)),
                  ),
                  Container(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 10,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const ImageIcon(
                        AssetImage(
                          'assets/logo/hooka1.png',
                        ),
                        size: 40,
                        color: Color(0xfffff669),
                      ),
                      Container(
                        width: 16,
                      ),
                      Text(
                        '$name',
                        style: const TextStyle(
                            color: Color(0xfff5f5f5),
                            fontSize: 20,
                            fontFamily: 'tawasul'),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: LikeButton(
                  onTap: (_) async {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('coming soon')));
                  },
                  size: 25,
                ),
              ),
              ismanager
                  ? Positioned(
                      left: 5,
                      top: 5,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('هل تريد حذف العنصر؟'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('items')
                                              .doc('$id')
                                              .delete()
                                              .then((value) =>
                                                  Navigator.of(context).pop())
                                              .then((value) {
                                            fitchdata;
                                          });
                                        },
                                        child: const Text(
                                          'نعم',
                                          style: TextStyle(
                                              color: Color(0xff000000)),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'لا',
                                          style: TextStyle(
                                              color: Color(0xff000000)),
                                        ))
                                  ],
                                );
                              });
                        },
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(
                                0xfffff669,
                              )),
                          child: const Center(
                            child: Text(
                              'x',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

class FunkyOverlay extends StatefulWidget {
  const FunkyOverlay(
      {Key? key,
      required this.price,
      required this.id,
      required this.name,
      this.image})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
  final int price;
  final id;
  final name;
  final String? image;
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  String place = '';

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
    double price = widget.price * 1.5;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: 380,
            height: 360,
            decoration: ShapeDecoration(
                color: const Color(0xaf1E223A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Column(
              children: [
                Container(
                  height: 40,
                ),
                widget.image != null
                    ? Image.network(
                        "${widget.image}",
                      )
                    : Image.asset(
                        'assets/logo/hooka.png',
                        width: 200,
                        height: 135,
                      ),
                Container(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          Provider.of<myProvider>(context, listen: false)
                              .addItem(
                                  name: widget.name,
                                  price: int.parse(price.toStringAsFixed(0)),
                                  id: widget.id,
                                  image:
                                      widget.image ?? 'assets/logo/hooka.png',
                                  stuckPrice: price.toStringAsFixed(0));

                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor:
                                      Colors.black.withOpacity(0.80),
                                  content: Text(
                                    'تم الاضافة الى السلة',
                                    style: TextStyle(
                                        color: Color(0xfff5f5f5),
                                        fontSize: 18,
                                        fontFamily: 'tawasul'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return cartScreen();
                                        }));
                                      },
                                      child: Text(
                                        'الذهاب الى السلة',
                                        style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 15,
                                            fontFamily: 'tawasul'),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'رجوع',
                                        style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 15,
                                            fontFamily: 'tawasul'),
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                        child: Row(
                          children: [
                            Text(
                              '${int.parse(widget.price.toStringAsFixed(0)) * 1.5} IQD',
                              style: const TextStyle(
                                  color: Color(0xfffff660),
                                  fontSize: 22,
                                  fontFamily: 'tawasul'),
                            ),
                            const Text(
                              '       : طبيعي',
                              style: TextStyle(
                                  color: Color(0xfffff660),
                                  fontSize: 22,
                                  fontFamily: 'tawasul'),
                            ),
                          ],
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Provider.of<myProvider>(context, listen: false)
                              .addItem(
                                  name: widget.name,
                                  price: int.parse(
                                      widget.price.toStringAsFixed(0)),
                                  id: widget.id,
                                  image:
                                      widget.image ?? 'assets/logo/hooka.png',
                                  stuckPrice: widget.price.toStringAsFixed(0));

                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor:
                                      Colors.black.withOpacity(0.80),
                                  content: Text(
                                    'تم الاضافة الى السلة',
                                    style: TextStyle(
                                        color: Color(0xfff5f5f5),
                                        fontSize: 18,
                                        fontFamily: 'tawasul'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return cartScreen();
                                        }));
                                      },
                                      child: Text(
                                        'الذهاب الى السلة',
                                        style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 15,
                                            fontFamily: 'tawasul'),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'رجوع',
                                        style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 15,
                                            fontFamily: 'tawasul'),
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                        child: Row(
                          children: [
                            Text(
                              '${widget.price} IQD',
                              style: const TextStyle(
                                  color: Color(0xfffff660),
                                  fontSize: 22,
                                  fontFamily: 'tawasul'),
                            ),
                            const Text(
                              '       : حجري',
                              style: TextStyle(
                                  color: Color(0xfffff660),
                                  fontSize: 22,
                                  fontFamily: 'tawasul'),
                            ),
                          ],
                        )),
                  ],
                ),
                Container(
                  height: 40,
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
        ),
      ),
    );
  }
}
