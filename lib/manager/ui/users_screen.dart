import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../primary_widgets.dart';
import '../../provider.dart';
import '../widgets/users_widget.dart';

class usersScreen extends StatefulWidget {
  const usersScreen({Key? key}) : super(key: key);

  @override
  _usersScreenState createState() => _usersScreenState();
}

class _usersScreenState extends State<usersScreen> {
  bool isSearching = false;
  bool _isloading = false;
  FocusNode search = FocusNode();
  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    fitchData().then((value) {
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  String searchKey = '';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Image.asset(
            'assets/logo/smoke.jpg',
            fit: BoxFit.fitWidth,
          ),
        ),
        Scaffold(
          backgroundColor: Provider.of<myProvider>(context).isDark
              ? Colors.transparent
              : Color(0xfff5f5f5),
          appBar: myAppBar(context: context, actions: [
            AnimatedContainer(
              duration: Duration(microseconds: 800),
              width: isSearching ? 160 : 60,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                      });
                      isSearching
                          ? search.requestFocus()
                          : FocusScope.of(context).unfocus();
                    },
                    icon: isSearching
                        ? Icon(Icons.chevron_right_outlined)
                        : Text(
                            '$val',
                            style: TextStyle(color: Color(0xfffff669)),
                          ),
                  ),
                  AnimatedContainer(
                    duration: Duration(microseconds: 800),
                    child: TextField(
                      focusNode: search,
                      onChanged: (val) {
                        setState(() {
                          searchKey = val;
                        });
                        fitchData();
                      },
                    ),
                    width: isSearching ? 100 : 0,
                  )
                ],
              ),
            ),
          ]),
          body: _isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () {
                    return fitchData();
                  },
                  child: ListView.builder(
                      itemCount: val,
                      itemBuilder: (BuildContext context, ind) {
                        return userWidget(
                          name: items[ind].get('name'),
                          phone: items[ind].get('phone'),
                          place: items[ind].get('place'),
                          Type: 'user',
                          number: '4',
                          isDriver: false,
                          isUser: true,
                          id: items[ind].get('id'),
                        );
                      }),
                ),
        ),
      ],
    );
  }

  Query<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('user');
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> items;
  int? val;

  Future<void> fitchData() async {
    if (searchKey != '') {
      await ref
          .where('type', isEqualTo: 'user')
          .where('name', isGreaterThanOrEqualTo: searchKey)
          .where('name', isLessThan: searchKey + 'z')
          .get()
          .then((value) {
        setState(() {
          items = value.docs;
          val = value.docs.length;
        });
      });
    } else {
      await ref.where('type', isEqualTo: 'user').get().then((value) {
        setState(() {
          items = value.docs;
          val = value.docs.length;
        });
      });
    }
  }
}
