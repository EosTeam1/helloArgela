import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider.dart';

class cartItem extends StatefulWidget {
  cartItem(
      {Key? key,
      required this.name,
      required this.price,
      required this.num,
      required this.index,
      required this.context,
      required this.fin,
      required this.juice,
      required this.image})
      : super(key: key);
  final name;
  final price;
  int num;
  final int index;
  BuildContext context;
  final fin;
  final juice;
  final image;

  @override
  State<cartItem> createState() => _cartItemState();
}

class _cartItemState extends State<cartItem> {
  bool _all = false;
  bool _all2 = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      onEnd: () {
        if (_all) {
          setState(() {
            _all2 = !_all2;
          });
        }
      },
      duration: Duration(milliseconds: 200),
      width: 354,
      height: _all
          ? MediaQuery.of(context).size.height < 926
              ? 280
              : 320
          : MediaQuery.of(context).size.height < 926
              ? 153
              : 203,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        color: Color(0xc01E223A),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: MediaQuery.of(context).size.height < 926 ? 0 : 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 100,
                    height: 86,
                    child: widget.image == "assets/logo/hooka.png"
                        ? Image.asset('assets/logo/hooka.png')
                        : Image.network(
                            widget.image,
                          )),
                Container(
                  width: 5,
                ),
                Text(
                  '${widget.name}',
                  style: TextStyle(
                      color: Color(0xfff5f5f5),
                      fontSize:
                          MediaQuery.of(context).size.height < 926 ? 20 : 24,
                      fontFamily: 'tawasul'),
                ),
                Column(
                  children: [],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              Provider.of<myProvider>(context, listen: false)
                                  .minOne(index: widget.index);
                            },
                            icon: Icon(
                              Icons.remove,
                              color: Color(0xfffff660),
                            )),
                        Text(
                          '${widget.num}',
                          style: TextStyle(
                              color: Color(0xfff5f5f5),
                              fontSize: 20,
                              fontFamily: 'tawasul'),
                        ),
                        IconButton(
                            onPressed: () {
                              Provider.of<myProvider>(context, listen: false)
                                  .addOne(index: widget.index);
                            },
                            icon: Icon(
                              Icons.add,
                              color: Color(0xfffff669),
                            )),
                      ],
                    ),
                    Text(
                      '${widget.price} IQD',
                      style: TextStyle(
                          color: Color(0xfff5f5f5),
                          fontSize: 20,
                          fontFamily: 'tawasul'),
                    )
                  ],
                )
              ],
            ),
            _all2
                ? Column(
                    children: [],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> change() async {
    if (!_all) {
      setState(() {
        _all = !_all;
      });
    } else {
      setState(() {
        _all2 = !_all2;
        _all = !_all;
      });
    }
  }
}
