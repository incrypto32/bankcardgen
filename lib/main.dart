import 'dart:convert';

import 'package:bankcardmaker/models/banks.dart';
import 'package:flutter/material.dart';
import 'package:bankcardmaker/constants/constants.dart';
import 'package:http/http.dart' as http;

import 'package:bankcardmaker/screens/form_screen.dart';
import 'package:bankcardmaker/screens/home_screen.dart';
import 'package:bankcardmaker/screens/saved_cards_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cardora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // is not restarted.
        accentColor: Colors.indigo,
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      routes: {
        FormScreen.routeName: (context) => FormScreen(),
        SavedCardsScreen.routeName: (context) => SavedCardsScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

void downloadAndCaching() async {
  http.get(backendDataUrl).then((response) {
    ServerJsonResponse serverJsonResponse;
    if (response.statusCode == 200) {
      serverJsonResponse = ServerJsonResponse.fromJson(
        json.decode(response.body),
      );
    } else {
      print("Error fetching data");
    }
    serverJsonResponse.saveToSharePrefs();
  }).catchError((e) {
    print(e);
  });
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Initalize caching
    downloadAndCaching();
    return HomeScreen();
  }
}
