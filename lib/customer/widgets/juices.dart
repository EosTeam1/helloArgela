import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider.dart';

class juice extends StatelessWidget {
  const juice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return FunkyOverlay();
            });
      },
      child: Container(
        width: 120,
        height: 140,
        child: Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.0),
          ),
          color: Color(0xc01E223A),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                        width: 120,
                        height: 98,
                        child: Image.asset('assets/logo/hooka.png')),
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
                      Container(
                        child: ImageIcon(
                          AssetImage(
                            'assets/logo/hooka1.png',
                          ),
                          size: 40,
                          color: Color(0xfffff669),
                        ),
                      ),
                      Container(
                        width: 16,
                      ),
                      const Text(
                        'الخلطات',
                        style: TextStyle(
                            color: Color(0xfff5f5f5),
                            fontSize: 20,
                            fontFamily: 'tawasul'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FunkyOverlay extends StatefulWidget {
  const FunkyOverlay({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  String name = '';

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
              children: [
                Container(),
                SizedBox(
                  width: 250,
                  child: TextField(
                    style: TextStyle(color: Color(0xfff5f5f5), fontSize: 18),
                    onChanged: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        label: Center(
                            child: Text(
                          'اسم الخلطه',
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'tawasul',
                            color: Colors.white,
                          ),
                        ))),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Provider.of<myProvider>(context, listen: false)
                              .setJuice(juicePrice: 25000, juiceName: name);
                          setState(() {
                            Provider.of<myProvider>(context, listen: false)
                                .juiceName = name;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: const [
                            Text(
                              '25,000 IQD',
                              style: TextStyle(
                                  color: Color(0xfffff660),
                                  fontSize: 22,
                                  fontFamily: 'tawasul'),
                            ),
                            Text(
                              '    : نصف كيلو',
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
                        onPressed: () async {
                          await Provider.of<myProvider>(context, listen: false)
                              .setJuice(juicePrice: 40000, juiceName: name);
                          setState(() {
                            Provider.of<myProvider>(context, listen: false)
                                .juiceName = name;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: const [
                            Text(
                              '40,000 IQD',
                              style: TextStyle(
                                  color: Color(0xfffff660),
                                  fontSize: 22,
                                  fontFamily: 'tawasul'),
                            ),
                            Text(
                              '    : كيلو',
                              style: TextStyle(
                                  color: Color(0xfffff660),
                                  fontSize: 22,
                                  fontFamily: 'tawasul'),
                            ),
                          ],
                        )),
                  ],
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ),
        ),
      ),
    );
  }
}
