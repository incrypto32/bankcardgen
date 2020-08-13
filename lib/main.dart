import 'dart:typed_data';
import 'package:bankcardmaker/imageGen/imageGen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screen/form_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      routes: {
       FormScreen.routeName:(context)=>FormScreen()
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
        return Scaffold(
          
        body: Column(
          children: [
             Center(
      child: FutureBuilder<ByteData>(
          future: ImgFromTempelate.generateBankCard({
            "bank":"yes",
            "Ac No":"784598656889635",
            "Name" : "Rajesh Perigodath Manuman",
            "IFSC" :"FDL54865",
            "Branch":"Thrissur",
            "Ph No":"7032415896",
            "Gpay":"45786455685"
          }),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var buf = snapshot.data.buffer;
              return Container(
                child: Image.memory(Uint8List.view(buf)),
                // child: Container(),
              );
            }
            return Container();
          }),
    ),
    RaisedButton(onPressed: (){ Navigator.of(context).pushNamed(FormScreen.routeName);},
    child: Text('go to form'),)

          ],
        )
        
        
       );
  }
}
