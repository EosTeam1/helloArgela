import 'package:flutter/material.dart';

import '../../primary_widgets.dart';
import 'auth.dart';

// ignore: camel_case_types
class start extends StatefulWidget {
  const start({Key? key}) : super(key: key);

  @override
  State<start> createState() => _startState();
}

// ignore: camel_case_types
class _startState extends State<start> with TickerProviderStateMixin {
  TextEditingController _controller = TextEditingController();
  double? width2 = 310;
  double _visible = 1;
  double _visible2 = 0;
  String? id = '';
  var phone3;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            width: width2,
            child: Image.asset(
              'assets/logo/smoke.jpg',
              fit: BoxFit.fitWidth,
            ),
            onEnd: () {
              setState(() {
                if (width2 == 200) {
                  _visible2 = 1;
                } else {
                  _visible = 1;
                }
              });
            },
          ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: myAppBar(
                context: context,
                lead: _visible2 == 1
                    ? AnimatedOpacity(
                        opacity: _visible2,
                        duration: Duration(seconds: 1),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                _visible2 == 1 ? _visible2 = 0 : null;
                                width2 = 310;
                              });
                            },
                            icon: Icon(Icons.chevron_left_sharp)),
                      )
                    : null),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: AnimatedOpacity(
                        onEnd: () {
                          setState(() {
                            if (_visible2 == 0) {}
                          });
                        },
                        opacity: _visible2,
                        duration: const Duration(milliseconds: 2000),
                        child: primaryCard(
                          child: _visible2 == 1
                              ? Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  color: Color(0xff1E223A),
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextField(
                                          keyboardType: TextInputType.phone,
                                          style: TextStyle(
                                              color: Color(0xfff5f5f5),
                                              fontSize: 18),
                                          controller: _controller,
                                          onChanged: (vl) {
                                            setState(() {
                                              phone3 = vl;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white)),
                                              label: Center(
                                                  child: Text(
                                                'رقم الهاتف',
                                                style: TextStyle(
                                                  fontSize: 32,
                                                  fontFamily: 'tawasul',
                                                  color: Colors.white,
                                                ),
                                              ))),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              if (_controller.text.length >=
                                                  10) {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                  return authScreen(
                                                      phone2: _controller.text);
                                                }));
                                              }
                                            },
                                            child: Container(
                                              width: 187,
                                              height: 47,
                                              child: Center(
                                                child: Text(
                                                  'تأكيد',
                                                  style: TextStyle(
                                                      fontFamily: 'tawasul',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 30),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                )
                              : null,
                          width: 310,
                          hight: 180,
                        ),
                      ),
                    ),
                    Center(
                      child: AnimatedOpacity(
                        opacity: _visible,
                        duration: const Duration(milliseconds: 500),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              width2 = 200;
                              _visible == 1 ? _visible = 0 : null;
                            });
                          },
                          child: SizedBox(
                            width: 220,
                            height: 50,
                            child: Center(
                              child: const Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                    fontSize: 30, fontFamily: 'tawasul'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ))
      ],
    );
  }
}
