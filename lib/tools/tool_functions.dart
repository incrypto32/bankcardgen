import 'dart:io';
import 'dart:typed_data';

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

  static shareSheet(List<String> pathList, int index, context) async {
    showModalBottomSheet(
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
                        // _share(pathList, index, false);
                        share(pathList[index], false);
                      },
                      leading: Icon(Icons.text_fields),
                      title: Text('Share as Text'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      onTap: () {
                        share(pathList[index], true);
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
}
