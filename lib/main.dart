import 'package:bcard/providers/state_provider.dart';
import 'package:bcard/screens/bank_request.dart';
import 'package:bcard/screens/card_screen.dart';
import 'package:bcard/screens/info_screen.dart';
import 'package:flutter/material.dart';
import 'package:bcard/screens/form_screen.dart';
import 'package:bcard/screens/home_screen.dart';
import 'package:bcard/screens/saved_cards_screen.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StateProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
        SavedCardsScreen.routeName: (context) => SavedCardsScreen(),
        BankRequestForm.routeName: (context) => BankRequestForm(),
        InfoScreen.routeName: (context) => InfoScreen(),
        '/card_screen': (context) => CardScreen()
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Initalize caching

    return HomeScreen();
  }
}
