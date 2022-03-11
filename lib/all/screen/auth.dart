import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello/all/screen/start.dart';

import '../../customer/screen/home.dart';
import '../../manager/ui/manager_home_screen.dart';
import '../../primary_widgets.dart';
import 'new_user.dart';

class authScreen extends StatefulWidget {
  authScreen({
    Key? key,
    required this.phone2,
  }) : super(key: key);
  final phone2;

  @override
  State<authScreen> createState() => _authScreenState();
}

class _authScreenState extends State<authScreen> {
  late final String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: 310,
            child: Image.asset(
              'assets/logo/smoke.jpg',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: myAppBar(context: context),
          body: Stack(
            children: [
              Center(
                  child: primaryCard(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        color: const Color(0xff1E223A),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '${widget.phone2}',
                                style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.white,
                                    fontFamily: 'tawasul'),
                              ),
                              Text(
                                'تم ارسال رسالة لهذا الرقم',
                                style: TextStyle(
                                    fontSize: 27,
                                    color: Colors.white,
                                    fontFamily: 'tawasul'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return start();
                                  }));
                                },
                                child: SizedBox(
                                  width: 80,
                                  height: 35,
                                  child: Center(
                                    child: Text(
                                      'رجوع',
                                      style: TextStyle(
                                          fontSize: 27,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'tawasul'),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: TextField(
                                  style: TextStyle(color: Color(0xfff5f5f5)),
                                  keyboardType: TextInputType.number,
                                  controller: _pinPutController,
                                  focusNode: _pinPutFocusNode,
                                  onSubmitted: (pin) async {
                                    try {
                                      await FirebaseAuth.instance
                                          .signInWithCredential(
                                              PhoneAuthProvider.credential(
                                                  verificationId:
                                                      _verificationCode,
                                                  smsCode: pin))
                                          .then((value) async {
                                        if (value.user != null) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return const newUserScreen();
                                          }));
                                        }
                                      }).then((value) {
                                        setState(() {});
                                      });
                                    } catch (e) {
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      label: Center(
                                          child: Text(
                                        'رقم التأكيد',
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontFamily: 'tawasul',
                                          color: Colors.white,
                                        ),
                                      ))),
                                ),
                                padding: EdgeInsets.fromLTRB(55, 0, 55, 0),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await FirebaseAuth.instance
                                          .signInWithCredential(
                                              PhoneAuthProvider.credential(
                                                  verificationId:
                                                      _verificationCode,
                                                  smsCode:
                                                      _pinPutController.text))
                                          .then((value) async {
                                        if (value.user != null) {
                                          if (FirebaseAuth.instance.currentUser!
                                                  .displayName !=
                                              null) {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                              return userHomeScreen();
                                            }));
                                          } else {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                              return newUserScreen();
                                            }));
                                          }
                                        }
                                      }).then((value) {
                                        setState(() {});
                                      });
                                    } catch (e) {
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                  child: SizedBox(
                                    width: 187,
                                    height: 47,
                                    child: Center(
                                      child: Text(
                                        'تأكيد',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontFamily: 'tawasul'),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      width: 384,
                      hight: 310))
            ],
          ),
        ),
      ],
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+964${widget.phone2}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              if (FirebaseAuth.instance.currentUser!.displayName != null) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return userHomeScreen();
                }));
              } else {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return newUserScreen();
                }));
              }
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
          SnackBar(
              content: Text(
            'failed',
            style: TextStyle(color: Colors.black),
          ));
        },
        codeSent: (String verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
