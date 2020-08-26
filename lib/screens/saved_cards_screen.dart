import 'dart:io';
import 'dart:typed_data';
import 'package:bankcardmaker/providers/state_provider.dart';
import 'package:bankcardmaker/widgets/saved_cards_list.dart';
import 'package:flutter/material.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

// Bottom Sheet fo sharing
  shareSheet(pathList, index, context) {
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
                        print(tapped.toString());
                        !tapped
                            ? _share(pathList, index, false)
                            : print("tapped");
                      },
                      leading: Icon(Icons.text_fields),
                      title: Text('Share as Text'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      onTap: () {
                        !tapped
                            ? _share(pathList, index, true)
                            : print("tapped");
                      },
                      leading: Icon(Icons.image),
                      title: Text('Share as Image'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

// Dialog for Delete
  deleteDialog(pathList, index, context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Do you want to delete this card ?"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              FlatButton(
                  onPressed: () async {
                    var prefs = await SharedPreferences.getInstance();
                    var val = prefs.getString("primaryCard");
                    setState(() {
                      try {
                        File(pathList[index]).deleteSync();
                      } catch (e) {
                        print("couldnt delete");
                      }
                      if (val == pathList[index]) {
                        stateProvider.changePrimaryCard(null);
                      }
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ))
            ],
          );
        });
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

          if (snapshot.hasData) {
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
            child = SavedCardsList(
              pathList: pathList,
              shareSheet: shareSheet,
              deleteDialog: deleteDialog,
            );
          } else {
            child = Center(
              child: Container(
                child: SpinKitCircle(
                  color: Colors.white,
                  size: 45,
                ),
              ),
            );
          }
          return child;
        },
      ),
    );
  }
}
