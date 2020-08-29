import 'dart:io';

import 'package:bankcardmaker/providers/state_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedCard extends StatelessWidget {
  SavedCard({
    Key key,
    @required this.path,
    @required this.shareSheet,
    @required this.deleteDialog,
  }) : super(key: key);

  final String path;
  final Function shareSheet;
  final Function deleteDialog;

  @override
  Widget build(BuildContext context) {
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
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: Image.file(
                File(path),
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ShareButton(shareSheet: shareSheet, path: path),
                InkWell(
                  onTap: () {
                    deleteDialog(path, context);
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
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text(
                            "Do you want to save this card as primary card ?"),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel"),
                          ),
                          FlatButton(
                            onPressed: () async {
                              print("boom");
                              print(path + " insde onpressed");
                              var prefs = await SharedPreferences.getInstance();
                              bool val = await prefs.setString(
                                "primaryCard",
                                path,
                              );
                              val
                                  ? stateProvider.changePrimaryCard(path)
                                  : print("error");
                              Navigator.of(context).pop();
                            },
                            child: Text("Yes"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Icon(Icons.more_vert),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ShareTapped extends ChangeNotifier {
  bool _value;

  bool get value => _value;

  changeValue(bool val) {
    _value = val;
    notifyListeners();
  }
}

class ShareButton extends StatelessWidget {
  ShareButton({
    Key key,
    @required this.shareSheet,
    @required this.path,
  }) : super(key: key);

  final Function shareSheet;

  final String path;

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await shareSheet(
          path,
          context,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: <Widget>[
            Icon(Icons.share),
            SizedBox(width: 6),
            Text("Share")
          ],
        ),
      ),
    );
  }
}
