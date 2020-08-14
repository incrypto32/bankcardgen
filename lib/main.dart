import 'package:bankcardmaker/screen/form_screen.dart';
import 'package:flutter/material.dart';

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

  Color parseColor(String color) {
    String hex = color.replaceAll("#", "");
    if (hex.isEmpty) hex = "ffffff";
    if (hex.length == 3) {
      hex =
          '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
    }
    Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
    return col;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    // body: Center(
    // child: FutureBuilder<ByteData>(
    // future: ImgFromTempelate.generateBankCard({
    // "bank":"yes",
    // "Ac No":"784598656889635",
    // "Name" : "John Doe",
    // "IFSC" :"FDL54865",
    // "Branch":"Thrissur",
    // "Ph No":"7032415896",
    // "Email" : "johndoe@gmail.com",
    // "Gpay":"45786455685"
    // }),
    // builder: (context, snapshot) {
    // if (snapshot.hasData) {
    // var buf = snapshot.data.buffer;
    // return Container(
    // child: Image.memory(Uint8List.view(buf)),
    // child: Container(),
    // );
    // }
    // return Container();
    // }),
    // ));
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Card Maker",
                      style: Theme.of(context).textTheme.headline5.apply(
                            fontWeightDelta: 5,
                          ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.notification_important),
                      onPressed: null,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Container(
                // width: double.infinity,
                
                child: Container(
                  
                  
                  margin: EdgeInsets.all(0),
                  child: Image.asset(
                    'assets/images/banktamlets/yes.png',
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.blueGrey,
                      margin: EdgeInsets.all(20),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.blueGrey,
                      margin: EdgeInsets.all(20),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.blueGrey,
                      margin: EdgeInsets.all(20),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.blueGrey,
                      margin: EdgeInsets.all(20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
