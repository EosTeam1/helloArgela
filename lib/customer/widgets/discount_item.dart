import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class userDiscountItem extends StatefulWidget {
  const userDiscountItem(
      {Key? key,
      required this.isManager,
      required this.place,
      required this.price,
      required this.date,
      required this.id})
      : super(key: key);
  final place;
  final price;
  final id;
  final bool isManager;
  final date;
  @override
  _userDiscountItemState createState() => _userDiscountItemState();
}

class _userDiscountItemState extends State<userDiscountItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.isManager) {
        } else {
          Navigator.of(context).pop(widget.price);
        }
      },
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
                              .collection('discount')
                              .doc('${widget.id}')
                              .delete()
                              .then((value) => Navigator.of(context).pop());
                        },
                        child: Text(
                          'نعم',
                          style: TextStyle(color: Color(0xff000000)),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'لا',
                          style: TextStyle(color: Color(0xff000000)),
                        ))
                  ],
                );
              });
        },
        child: Container(
          width: 394,
          height: 90,
          child: Card(
            color: Color(0xc01E223A),
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/logo/hooka.png'),
                Row(
                  children: [
                    Text(
                      '${(10000 - widget.price) / 10000 * 100}%',
                      style: TextStyle(
                          color: Color(0xfff5f5f5),
                          fontSize: 20,
                          fontFamily: 'tawasul'),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${widget.place}',
                      style: TextStyle(
                          color: Color(0xfff5f5f5),
                          fontSize: 20,
                          fontFamily: 'tawasul'),
                    ),
                    Text(
                      '${widget.date}',
                      style: TextStyle(
                          color: Color(0xfff5f5f5),
                          fontSize: 20,
                          fontFamily: 'tawasul'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
