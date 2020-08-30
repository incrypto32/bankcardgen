import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToolFunctions {
  static Future<void> share(String path, bool image) async {
    try {
      if (image) {
        final Uint8List byteArray = await File(path.toString()).readAsBytes();
        await Share.file(
          'esys image',
          'bank.png',
          byteArray,
          'image/png',
        );
      } else {
        var prefs = await SharedPreferences.getInstance();
        var id = path.split('/').reversed.toList()[0];
        String shareText = prefs.getString(id);
        Share.text("Account Details", shareText, "text/plain");
      }
    } catch (e) {
      print('error: $e');
    }
  }

  static shareSheet(String path, context, {bool primaryCard = false}) async {
    var active = !(path == null);
    var color = active ? Colors.black : Colors.grey;
    showModalBottomSheet(
      elevation: 5,
      context: context,
      builder: (context) {
        return Material(
          color: Colors.amber[50],
          child: Container(
            height: primaryCard ? 200 : 100,
            child: Column(
              children: [
                Expanded(
                  child: ListTile(
                    onTap: active
                        ? () {
                            share(path, false);
                          }
                        : null,
                    leading: Icon(Icons.text_fields, color: color),
                    title: Text(
                      'Share as Text',
                      style: TextStyle(color: color),
                    ),
                    trailing: Icon(Icons.chevron_right, color: color),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    onTap: () {
                      share(path, true);
                    },
                    leading: Icon(Icons.image, color: color),
                    title:
                        Text('Share as Image', style: TextStyle(color: color)),
                    trailing: Icon(Icons.chevron_right, color: color),
                  ),
                ),
                primaryCard
                    ? Expanded(
                        child: ListTile(
                          onTap: active
                              ? () {
                                  Navigator.of(context)
                                      .pushNamed('/savedCardsScreen');
                                }
                              : null,
                          leading: Icon(
                            Icons.swap_horiz,
                            color: Colors.black,
                          ),
                          title: Text(
                            'Change Primary card',
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing:
                              Icon(Icons.chevron_right, color: Colors.black),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }

  static checkConnectivity({BuildContext context}) async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    bool connection;
    if (connectivityResult == ConnectivityResult.none) {
      connection = false;
      if (context != null) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Please check your network connection",
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } else {
      connection = true;
    }
    return connection;
  }
}
