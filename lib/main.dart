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
    //     return Scaffold(
    //     body: Center(
    //   child: FutureBuilder<ByteData>(
    //       future: ImgFromTempelate.generateBankCard({
    //         "bank":"yes",
    //         "Ac No":"784598656889635",
    //         "Name" : "John Doe",
    //         "IFSC" :"FDL54865",
    //         "Branch":"Thrissur",
    //         "Ph No":"7032415896",
    //         // "Email" : "johndoe@gmail.com",
    //         // "Gpay":"45786455685"
    //       }),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           var buf = snapshot.data.buffer;
    //           return Container(
    //             child: Image.memory(Uint8List.view(buf)),
    //             // child: Container(),
    //           );
    //         }
    //         return Container();
    //       }),
    // ));
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              color: widget.parseColor("#F8B195"),
              child: Container(
                
                alignment: Alignment.center,
                color: Colors.white,
                width: 50,
                child: Text(
                  'heeellloo',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              color: widget.parseColor("#F67280"),
            ),
          ),
          Flexible(
            child: Container(
              color: widget.parseColor("#C06C84"),
            ),
          ),
          Flexible(
            child: Container(
              color: widget.parseColor("#6C5B7B"),
            ),
          ),
          Flexible(
            child: Container(
              color: widget.parseColor("#355C7D"),
            ),
          ),
        ],
      ),
    );
  }
}
