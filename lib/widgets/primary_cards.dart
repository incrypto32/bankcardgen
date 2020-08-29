import 'dart:io';

import 'package:bankcardmaker/providers/state_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class PrimaryCard extends StatefulWidget {
  const PrimaryCard({
    Key key,
  }) : super(key: key);

  @override
  _PrimaryCardState createState() => _PrimaryCardState();
}

_getCard() async {
  var prefs = await SharedPreferences.getInstance();
  var path = prefs.getString("primaryCard");
  var fileExists = await File(path ?? 'adfad').exists();
  print("boom ><>" + fileExists.toString());
  if (fileExists) {
    return File(path);
  }
  return null;
}

shareSheet(context) {
  Scaffold.of(context).showBottomSheet(
    (context) => Material(
      color: Colors.white,
      child: Container(
        height: 150,
        child: Column(
          children: [
            Expanded(
              child: ListTile(
                onTap: () {
                  print("helo");
                  print(tapped.toString());
                  !tapped
                      // ? _share(pathList, index, false)
                      ? print("object")
                      : print("tapped");
                },
                leading: Icon(Icons.text_fields),
                title: Text('Share as Text'),
                trailing: Icon(Icons.chevron_right),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

var tapped = false;

class _PrimaryCardState extends State<PrimaryCard> {
  @override
  Widget build(BuildContext context) {
    Provider.of<StateProvider>(context, listen: true);
    return FutureBuilder(
      future: _getCard(),
      builder: (context, snapshot) {
        var error = Image.asset('assets/images/banktamlets/placeholder.png');
        var child = error;
        if (snapshot.hasData) {
          try {
            if ((snapshot.data != null)) {
              child = Image.file(
                snapshot.data ?? File(stateProvider.primaryCard),
              );
            }
          } catch (e) {
            print("__________error occured catched________");
            child = error;
          }
        } else if (snapshot.hasError) {
          print("__________error occured snapshot catched________");
          child = error;
        } else {
          child = error;
        }
        return InkWell(
          child: child,
          onTap: () {
            shareSheet(context);
          },
        );
      },
    );
  }
}
