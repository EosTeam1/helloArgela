import 'package:flutter/material.dart';

import '../../customer/screen/profile.dart';

class userWidget extends StatefulWidget {
  const userWidget({
    Key? key,
    required this.Type,
    required this.name,
    required this.place,
    required this.phone,
    required this.number,
    required this.isUser,
    required this.isDriver,
    required this.id,
  }) : super(key: key);
  final Type;
  final name;
  final place;
  final phone;
  final number;
  final isUser;
  final isDriver;
  final id;
  @override
  _userWidgetState createState() => _userWidgetState();
}

class _userWidgetState extends State<userWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return profileScreen(
            name: widget.name,
            phone: widget.phone,
            place: widget.place,
            isDriver: widget.isDriver,
            isUser: widget.isUser,
            id: widget.id,
          );
        }));
      },
      child: SizedBox(
        width: 254,
        height: 90,
        child: Card(
          color: Color(0xc01E223A),
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.0),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xfff5f5f5),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${widget.place}',
                  style: TextStyle(color: Color(0xfff5f5f5), fontSize: 20),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${widget.name}',
                  style: TextStyle(color: Color(0xfff5f5f5), fontSize: 20),
                ),
                Text(
                  '${widget.phone}',
                  style: TextStyle(color: Color(0xfff5f5f5), fontSize: 20),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
