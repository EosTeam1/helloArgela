import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class myProvider with ChangeNotifier {
  List items = [];
  int? juice;
  var juiceName;
  setJuice({required juicePrice, required juiceName}) {
    juiceName = juiceName;
    juice = juicePrice;

    notifyListeners();
  }

  addItem(
      {required name,
      required price,
      required id,
      required stuckPrice,
      required image}) {
    items.add({
      'name': name,
      'price': price,
      'num': 1,
      'id': id,
      'stuckPrice': stuckPrice,
      'carpon': 8,
      'fin': 2,
      'juice': 0,
      'image': image
    });
    total = items.sumBy((element) => element['price']);
    notifyListeners();
  }

  int total = 0;

  addFin({required index}) {
    items[index]['fin'] += 1;
    items[index]['price'] += 5000;
    total = items.sumBy((element) => element['price']);

    notifyListeners();
  }

  addjuice({required index}) {
    items[index]['juice'] += 0.25;
    items[index]['price'] += 13000;
    total = items.sumBy((element) => element['price']);

    notifyListeners();
  }

  minFin({required index}) {
    if (items[index]['fin'] > 2) {
      items[index]['fin'] -= 1;
      items[index]['price'] -= 5000;
      total = items.sumBy((element) => element['price']);

      notifyListeners();
    }
  }

  minjuice({required index}) {
    if (items[index]['juice'] > 0) {
      items[index]['juice'] -= 0.25;
      items[index]['price'] -= 13000;
      total = items.sumBy((element) => element['price']);

      notifyListeners();
    }
  }

  addOne({required index}) async {
    items[index]['num'] += 1;
    items[index]['price'] += int.parse(items[index]['stuckPrice']);
    total = items.sumBy((element) => element['price']);

    notifyListeners();
  }

  minOne({required index}) {
    if (items[index]['num'] == 1) {
      items.clear();
    } else {
      items[index]['num'] -= 1;
      items[index]['price'] -= int.parse(items[index]['stuckPrice']);
    }
    total = items.sumBy((element) => element['price']);

    notifyListeners();
  }

  var apiKey = 'AIzaSyDlACxhJzp4XkhriVDKWzEWE94FQOnbs64';
  void direction(LatLng start, LatLng end) {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?destination=${end.latitude},${end.longitude}&origin=${start.latitude},${start.longitude}&key=$apiKey';
    var res = http.get(Uri.parse(url));
  }

  bool isDark = true;
  switchDark() {
    isDark = !isDark;
    notifyListeners();
  }

  clear() {
    items.clear();
    notifyListeners();
  }
}
