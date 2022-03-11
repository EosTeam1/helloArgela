import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello/customer/screen/user_log.dart';
import 'package:hello/primary_widgets.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'all/screen/start.dart';
import 'customer/screen/home.dart';
import 'driver/ui/home_driver.dart';
import 'manager/ui/manager_home_screen.dart';
import 'provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(
      create: (_) => myProvider(), child: const MyApp()));
  await initPlatform();
}

const String appKey = '416a7067-dcbd-4c16-9508-95f5c0258148';

Future<void> initPlatform() async {
  OneSignal.shared.setAppId(appKey);
  OneSignal.shared.getDeviceState().then((value) {});
}

class MyApp extends StatelessWidget {
  MaterialColor buildMaterialColor(Color color) {
    List<double> strengths = [.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'الو اركيلة',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: buildMaterialColor(const Color(0xfff5f5f5)),
        ),
        home: const myappful());
  }
}

class myappful extends StatefulWidget {
  const myappful({Key? key}) : super(key: key);

  @override
  _myappfulState createState() => _myappfulState();
}

class _myappfulState extends State<myappful> {
  bool _isLoading = false;
  Query<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('user');
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> items;
  int? val;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    fitchData().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      not(message: event.notification.title);

      event.complete(event.notification);
    });
    if (FirebaseAuth.instance.currentUser != null) {
      OneSignal.shared.getDeviceState().then((value) {
        FirebaseFirestore.instance
            .collection('user')
            .doc('a${FirebaseAuth.instance.currentUser!.uid}')
            .update({'token': value!.userId});
      });
    }

    return _isLoading
        ? Scaffold(
            backgroundColor: Colors.transparent,
            appBar: myAppBar(context: context),
            body: const Center(child: CircularProgressIndicator()),
          )
        : FirebaseAuth.instance.currentUser != null
            ? items.any((element) => element['type'] == 'manager')
                ? const managerHome()
                : items.any((element) => element['type'] == 'driver')
                    ? const driverHomeScreen()
                    : userHomeScreen()
            : const start();
  }

  Future<void> fitchData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await ref
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        items = value.docs;
        val = value.docs.length;
      });
    }
  }

  not({required message}) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 60,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/logo/hooka.png',
                        width: 30,
                        height: 30,
                      ),
                      Text(
                        '$message',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'tawasul'),
                      )
                    ],
                  ),
                  items.any((element) => element['type'] != 'driver')
                      ? TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return userLogScreen(
                                  isManager: items.any((element) =>
                                          element['type'] == 'manager')
                                      ? true
                                      : false);
                            }));
                          },
                          child: const Text(
                            'الطلبات',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'tawasul'),
                          ))
                      : Container()
                ],
              ),
            ),
          );
        });
  }
}
