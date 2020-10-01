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
      actionsIconTheme: IconTheme.of(context).copyWith(color: Colors.black),
      // iconTheme: IconThemeData(color: Colors.black),
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
