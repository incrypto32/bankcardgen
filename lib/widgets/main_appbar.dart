import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);
  final Color color;
  final String title;
  final Color textColor;
  MainAppBar({Key key, this.color, this.title, this.textColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 90,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      centerTitle: true,
      backgroundColor: color,
      elevation: 0,
    );
  }
}
