import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  Future<void> _shareImage(pathList, int index) async {
    try {
      // final tempDir = await getTemporaryDirectory();
      // await new File('assets${pathList[index]}').create();
      print("new file created");
      print('${pathList[index].toString()}');
      // final ByteData bytes = await rootBundle.load(pathList[index].toString());
      final Uint8List byteArray =
          await File(pathList[index].toString()).readAsBytes();
      await Share.file(
        'esys image',
        'esys.png',
        // bytes.buffer.asUint8List(),
        byteArray,
        'image/png',
      );
    } catch (e) {
      print('error: $e');
    }
  }
  //  Future<void> _shareImage(pathList,index) async {
  //   try {
  //     final ByteData bytes = await rootBundle.load(pathList[index]);
  //     final Uint8List list = bytes.buffer.asUint8List();

  //     // final tempDir = await getTemporaryDirectory();
  //     final file = await new File(pathList[index]).create();
  //     file.writeAsBytesSync(list);

  //     final channel = const MethodChannel('channel:me.albie.share/share');
  //     channel.invokeMethod('shareFile', 'image.jpg');

  //   } catch (e) {
  //     print('Share error: $e');
  //   }
  // }

  Future<Directory> _getImgs() async {
    Directory photoDir;
    try {
      if (await Permission.storage.request().isGranted) {
        final Directory imgDir = await getApplicationDocumentsDirectory();
        print(imgDir.path);
        final String imgDirPath = imgDir.path + '/saved_cards';
        print(imgDirPath);

        photoDir = Directory(imgDirPath);
        photoDir.createSync();
        print(photoDir);
      }
    } catch (e) {
      print("error caught");
      print(e);
      return null;
    }
    return photoDir;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Saved Cards'),
      ),
      body: FutureBuilder<Directory>(
          future: _getImgs(),
          builder: (context, snapshot) {
            var child;
            List pathList;

            try {
              pathList = snapshot.data
                  .listSync()
                  .map((e) => e.path)
                  .where((element) => element.endsWith(".png"))
                  .toList(growable: true);
              print(pathList);
            } catch (e) {
              return Center(
                child: Container(
                  child: Text("Error Loading Files Check Permission"),
                ),
              );
            }

            if (snapshot.hasData) {
              child = ListView.builder(
                itemCount: pathList.length,
                itemBuilder: (context, index) {
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
                            child: Image.file(
                              File(pathList[index]),
                              width: double.infinity,
                              height: 190,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _shareImage(pathList, index);
                                  });
                                },
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
                                    pathList.removeAt(index);
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
              );
              //   // child = ListView.builder(
              //   //     itemCount: pathList.length, itemBuilder: (context, index) {});
            } else {
              child = Container(
                child: Text("Error"),
              );
            }
            return child;
          }),
    );
  }
}
