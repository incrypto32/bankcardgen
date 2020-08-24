import 'package:bankcardmaker/cache_manager/custom_cache_manager.dart';
import 'package:bankcardmaker/screens/form_screen.dart';
import 'package:bankcardmaker/screens/home_screen.dart';
import 'package:bankcardmaker/screens/saved_cards_screen.dart';
import 'package:flutter/material.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
