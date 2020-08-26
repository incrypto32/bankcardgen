import 'package:bankcardmaker/services/database_service.dart';
import 'package:bankcardmaker/widgets/MainDrawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bankcardmaker/widgets/main_appbar.dart';
import 'package:bankcardmaker/widgets/main_column.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: MainDrawer(),
      ),
      backgroundColor: Theme.of(context).accentColor,
      appBar: MainAppBar(
        title: "Card Generater",
        color: Colors.transparent,
      ),
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
                child: FutureBuilder(future: () async {
                  var app = await Firebase.initializeApp().then((value) {
                    DatabaseService.getBanks();
                  });

                  return app;
                }(), builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return MainColumn();
                  }
                  return Text("Error");
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
