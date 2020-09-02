import 'package:bankcardmaker/services/database_service.dart';
import 'package:bankcardmaker/widgets/MainDrawer.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bankcardmaker/widgets/main_appbar.dart';
import 'package:bankcardmaker/widgets/main_column.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);
  Future<FirebaseApp> initialize(context) async {
    try {
      ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var banks = prefs.getString("banks");
      if (banks == null || banks == '[]') {
        if (connectivityResult == ConnectivityResult.none) {
          print("No Connection");
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
            "Please check your network connection",
            textAlign: TextAlign.center,
          )));
        }
      }
      print(connectivityResult);
      var app = await Firebase.initializeApp();

      // await DatabaseService.getBanks();
      DatabaseService.cacheUpdate(prefs);
      // DatabaseService.getAd("Federal Bank");
      return app;
    } catch (e) {
      print(e);
      return null;
    }
  }

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
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              height: constraints.maxHeight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                      child: FutureBuilder(
                          future: initialize(context),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Container(
                                  child: Text(
                                      "An Error occured please check your network connection."),
                                ),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return MainColumn();
                            }
                            return Center(
                              child: Container(
                                child: SpinKitCircle(
                                  color: Colors.blue,
                                  size: 45,
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
