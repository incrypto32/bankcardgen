import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);
  const MainAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 90,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text("Card Generater"),
      centerTitle: true,
      backgroundColor: Colors.black,
      elevation: 0,
    );
  }
}
