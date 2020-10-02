import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bcard/providers/state_provider.dart';
import 'package:bcard/widgets/saved_cards_list.dart';

class SavedCardsScreen extends StatefulWidget {
  static const String routeName = "/savedCardsScreen";

  @override
  _SavedCardsScreenState createState() => _SavedCardsScreenState();
}

class _SavedCardsScreenState extends State<SavedCardsScreen> {
  //
  // Share Image Function

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

  void onDelete(path) async {
    var prefs = await SharedPreferences.getInstance();
    var val = prefs.getString("primaryCard");
    setState(() {
      try {
        File(path).deleteSync();
      } catch (e) {
        print("couldnt delete");
      }
      if (val == path) {
        stateProvider.changePrimaryCard(null);
      }
      Navigator.of(context).pop();
    });
  }

// Dialog for Delete
  deleteDialog(path, context) {
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
                onPressed: () {
                  onDelete(path);
                },
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            ],
          );
        });
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
