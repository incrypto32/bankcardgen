import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedCardsScreen extends StatefulWidget {
  static const String routeName = "/savedCardsScreen";

  @override
  _SavedCardsScreenState createState() => _SavedCardsScreenState();
}

class _SavedCardsScreenState extends State<SavedCardsScreen> {
  //
  // Share Image Function
  bool tapped = false;
  Future<void> _share(pathList, int index, bool image) async {
    tapped = true;

    try {
      if (image) {
        final Uint8List byteArray =
            await File(pathList[index].toString()).readAsBytes();
        await Share.file(
          'esys image',
          'bank.png',
          byteArray,
          'image/png',
        );
      } else {
        var prefs = await SharedPreferences.getInstance();
        var id = pathList[index].split('/').reversed.toList()[0];

        String shareText = prefs.getString(id);
        Share.text("Account Details", shareText, "text/plain");
      }
      tapped = false;
    } catch (e) {
      print('error: $e');
      tapped = false;
    }
    tapped = false;
  }

  // get Images from filesystem
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
    print(tapped);
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
                              fit: BoxFit.fill,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    showBottomSheet(
                                        elevation: 5,
                                        context: context,
                                        builder: (context) {
                                          return Material(
                                            color: Colors.amber[50],
                                            child: Container(
                                              height: 100,
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: ListTile(
                                                      onTap: () {
                                                        print("helo");
                                                        print(
                                                            tapped.toString());
                                                        !tapped
                                                            ? _share(pathList,
                                                                index, false)
                                                            : print("tapped");
                                                      },
                                                      leading: Icon(
                                                          Icons.text_fields),
                                                      title:
                                                          Text('Share as Text'),
                                                      trailing: Icon(
                                                          Icons.chevron_right),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ListTile(
                                                      onTap: () {
                                                        !tapped
                                                            ? _share(pathList,
                                                                index, true)
                                                            : print("tapped");
                                                      },
                                                      leading:
                                                          Icon(Icons.image),
                                                      title: Text(
                                                          'Share as Image'),
                                                      trailing: Icon(
                                                          Icons.chevron_right),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                    // _share(pathList, index);
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
                                    try {
                                      File(pathList[index]).deleteSync();
                                    } catch (e) {
                                      print(e);
                                    }
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
