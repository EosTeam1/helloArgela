import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../customer/screen/my_orders.dart';
import '../../primary_widgets.dart';

class mapScreen extends StatefulWidget {
  const mapScreen({Key? key, required this.id}) : super(key: key);
  final id;

  @override
  _mapScreenState createState() => _mapScreenState();
}

late BitmapDescriptor customIcon;

class _mapScreenState extends State<mapScreen> {
  GoogleMapController? _controller;
  @override
  void initState() {
    getmarker();

    setState(() {
      _isLoading = true;
    });

    fitchdata()
        .then((value) {
          print('${items}');
          print('${ref}');
        })
        .then((value) => _addMarker(items!['lat'], items!['lng']))
        .then((value) {
          setState(() {
            _isLoading = false;
          });
        });

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  getmarker() async {
    await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)),
      'assets/logo/marker.png',
    ).then((d) {
      customIcon = d;
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  late Uint8List icon;
  Future<void> _addMarker(tmp_lat, tmp_lng) async {
    final MarkerId markerId = MarkerId('markerIdVal');
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/logo/marker.png', 100);
    icon = await getBytesFromAsset('assets/logo/marker.png', 150);
    setState(() {});
    // creating a new MARKER
    final Marker marker = Marker(
      icon: BitmapDescriptor.fromBytes(markerIcon),
      markerId: markerId,
      position: LatLng(tmp_lat, tmp_lng),
      infoWindow: InfoWindow(title: 'marker', snippet: 'boop'),
    );

    setState(() {
      // adding a new marker to map
    });
  }

  var markers;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000000),
      appBar: myAppBar(context: context),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                    polylines: {
                      Polyline(
                          polylineId: PolylineId('value'),
                          visible: true,
                          color: Color.fromARGB(255, 105, 108, 255),
                          points: [
                            LatLng(
                              items!['lat'],
                              items!['lng'],
                            ),
                            LatLng(items!['lat'], items!['lng'])
                          ])
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(items!['lat'], items!['lng']), zoom: 14),
                    markers: {
                      Marker(
                          markerId: MarkerId('order'),
                          position: LatLng(items!['lat'], items!['lng']),
                          icon: BitmapDescriptor.fromBytes(icon))
                    },
                    onMapCreated: (controller) {
                      _controller = controller;
                    }),
                buildDr()
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String googleUrl =
              'https://www.google.com/maps/search/?api=1&query=${items!['lat']},${items!['lat']}';
          if (await canLaunch(googleUrl)) {
            await launch(googleUrl);
          } else {
            throw 'Could not open the map.';
          }
        },
        child: ImageIcon(
          AssetImage('assets/logo/marker.png'),
          color: Color(0xff000000),
        ),
      ),
    );
  }

  buildDr() {
    double width2 = 300;
    var init1 = 0.1;
    return Center(
      child: ClipRRect(
        child: DraggableScrollableSheet(
          builder: (BuildContext context, scroll) {
            return Container(
              decoration: BoxDecoration(
                  color: Color(0xBF1E223A),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                controller: scroll,
                child: Column(
                  children: [
                    Center(
                        child: ImageIcon(
                      AssetImage(
                        'assets/logo/up.png',
                      ),
                      color: Color(0xfffff669),
                    )),
                    Container(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            iconSize: 100,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return myOrdersScreen(
                                  finName: items!['finName'],
                                  finNum: items!['finNum'],
                                  juicePrice: items!['juiceNum'],
                                  juiceName: items!['juiceName'],
                                  order: items!['order'],
                                  carpon: items!['carpon'],
                                  total: items!['total'],
                                  lat: items!['lat'],
                                  lng: items!['lng'],
                                  ismanager: false,
                                  id: widget.id,
                                  isDriver: true,
                                  pos: items!['orderPOS'],
                                  token: items!['token'],
                                  driverToken: items!['driverToken'] ?? null,
                                );
                              })).then((value) => Navigator.of(context).pop());
                            },
                            icon: ImageIcon(
                              AssetImage('assets/logo/ordericon.png'),
                              color: Color(0xfffff669),
                              size: 100,
                            )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '${items!['name']}',
                              style: TextStyle(
                                  color: Color(0xfff5f5f5),
                                  fontSize: 24,
                                  fontFamily: 'tawasul'),
                            ),
                            Container(
                              height: 30,
                            ),
                            Text(
                              '${items!['total']} IQD',
                              style: TextStyle(
                                  color: Color(0xfff5f5f5),
                                  fontSize: 24,
                                  fontFamily: 'tawasul'),
                            ),
                            Container(
                              height: 30,
                            ),
                            TextButton(
                              onPressed: () {
                                FlutterPhoneDirectCaller.callNumber(
                                    items!['phone']);
                              },
                              child: Text(
                                '${items!['phone']}',
                                style: TextStyle(
                                    color: Color(0xfff5f5f5),
                                    fontSize: 24,
                                    fontFamily: 'tawasul'),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          initialChildSize: 0.05,
          minChildSize: 0.05,
          maxChildSize: 0.4,
        ),
      ),
    );
  }

  DocumentReference<Map<String, dynamic>>? ref;

  DocumentSnapshot<Map<String, dynamic>>? items;
  late List order;
  Future<void> fitchdata() async {
    ref = await FirebaseFirestore.instance.collection('orders').doc(widget.id);
    await ref!.get().then((value) {
      setState(() {
        items = value;
        order = value['order'];
      });
    });
  }

  goToMarker() {
    _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      zoom: 14,
      target: LatLng(
        items!['lat'],
        items!['lng'],
      ),
    )));
  }
}
