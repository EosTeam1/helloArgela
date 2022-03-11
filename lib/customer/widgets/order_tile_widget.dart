import 'package:flutter/material.dart';

class orderTile extends StatelessWidget {
  const orderTile(
      {Key? key,
      required this.name,
      required this.price,
      required this.num3,
      required this.fin,
      required this.juice,
      required this.image})
      : super(key: key);
  final name;
  final price;
  final num3;
  final juice;
  final fin;
  final image;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            image == 'assets/logo/hooka.png'
                ? Image.asset(
                    image,
                    height: 40,
                    width: 40,
                  )
                : Image.network(
                    image,
                    width: 40,
                    height: 40,
                  ),
            Text(
              '$name',
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'tawasul',
                  color: Color(0xfff5f5f5)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '$num3',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'tawasul',
                      color: Color(0xfff5f5f5)),
                ),
                Container(
                  height: 20,
                ),
                Text(
                  '$price IQD',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'tawasul',
                      color: Color(0xfff5f5f5)),
                ),
              ],
            )
          ],
        ),
        Container(
          height: 20,
        ),
        Container(
          height: 20,
        ),
        Container(
          height: 1,
          width: 1200,
          color: Colors.white,
        ),
      ],
    );
  }
}
