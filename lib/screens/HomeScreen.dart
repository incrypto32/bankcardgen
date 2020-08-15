import 'package:flutter/material.dart';
import 'package:bankcardmaker/widgets/MainAppBar.dart';
import 'package:bankcardmaker/widgets/MainColumn.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      backgroundColor: Theme.of(context).accentColor,
      appBar: MainAppBar(),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                // margin: EdgeInsets.only(top: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                      // top: Radius.circular(40),
                      ),
                ),
                child: MainColumn(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
