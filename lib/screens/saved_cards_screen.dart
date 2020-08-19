import 'package:flutter/material.dart';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/services.dart';

class SavedCardsScreen extends StatefulWidget {
  static const String routeName = "/savedCardsScreen";

  @override
  _SavedCardsScreenState createState() => _SavedCardsScreenState();
}

class _SavedCardsScreenState extends State<SavedCardsScreen> {
  List savedCards = [
    "axis.png",
    "canara.png",
    "federal.png",
    "hdfc.png",
    "hsbc.png",
    "indiapost.png",
    "sbi.png",
    "southindian.png",
    "union.png",
    "yes.png"
  ];
//   void _onImageShareButtonPressed() async {

// var response = await http.get('https://mlltgcn1axte.i.optimole.com/h081bd0-Ho6YTIMz/w:auto/h:auto/q:74/https://codesearchonline.com/wp-content/uploads/2020/01/social-media-management-8.png');
//     filePath = await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
//     print(filePath);

//   BASE64_IMAGE = filePath;

//     final ByteData bytes = await rootBundle.load(BASE64_IMAGE);
//     await EsysFlutterShare.shareImage('myImageTest.png', bytes, 'my image title');
//     }
  Future<void> _shareImage(int index) async {
    try {
      final ByteData bytes = await rootBundle
          .load("assets/images/banktamlets/${savedCards[index]}");
      await Share.file(
        'esys image',
        'esys.png',
        bytes.buffer.asUint8List(),
        'image/png',
      );
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Saved Cards'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          // return Column(

          //   children: [
          //     Container(
          //       height:200,
          //       padding: EdgeInsets.symmetric(horizontal:20,vertical:5),
          //       child: Image.asset("assets/images/banktamlets/${savedCards[index]}"),
          //     ),
          return Card(
            margin: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    child: Image.asset(
                      "assets/images/banktamlets/${savedCards[index]}",
                      width: double.infinity,
                      height: 190,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () async => await _shareImage(index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.share),
                              SizedBox(width: 6),
                              Text("Share")
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            savedCards.removeAt(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.delete),
                              SizedBox(width: 6),
                              Text("Delete")
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
        itemCount: savedCards.length,
      ),
    );
  }
}
