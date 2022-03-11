import 'package:flutter/material.dart';
import 'package:hello/provider.dart';
import 'package:provider/provider.dart';

class primaryCard extends StatelessWidget {
  final Widget? child;
  final double width;
  final double hight;

  const primaryCard({
    Key? key,
    required this.child,
    required this.width,
    required this.hight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: hight, child: child);
  }
}

AppBar myAppBar(
    {Widget? lead, List<Widget>? actions, required BuildContext context}) {
  return AppBar(
    iconTheme: IconThemeData(
        color: Provider.of<myProvider>(context).isDark
            ? Color(0xfffff669)
            : Color(0xff1e223a)),
    leading: lead,
    centerTitle: true,
    backgroundColor: Provider.of<myProvider>(context).isDark
        ? Color(0xff000000)
        : Color(0xfff5f5f5),
    elevation: 0,
    title: Image.asset(
      'assets/logo/hooka.png',
      width: 39,
      height: 39,
    ),
    actions: actions,
  );
}

Container myBackGround({required context}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height - 50,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          'assets/logo/smoke.jpg',
        ),
      ),
    ),
  );
}
