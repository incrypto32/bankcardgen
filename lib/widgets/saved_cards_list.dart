import 'dart:io';

import 'package:bankcardmaker/providers/state_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedCardsList extends StatelessWidget {
  const SavedCardsList({
    Key key,
    @required this.pathList,
    @required this.shareSheet,
    @required this.deleteDialog,
  }) : super(key: key);

  final List pathList;
  final Function shareSheet;
  final Function deleteDialog;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                        shareSheet(pathList, index, context);
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
                        deleteDialog(pathList, index, context);
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
                                  print(pathList[index] + " insde onpressed");
                                  var prefs =
                                      await SharedPreferences.getInstance();
                                  bool val = await prefs.setString(
                                    "primaryCard",
                                    pathList[index],
                                  );
                                  val
                                      ? stateProvider
                                          .changePrimaryCard(pathList[index])
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
      },
    );
  }
}
