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

class _PrimaryCardState extends State<PrimaryCard> {
  @override
  Widget build(BuildContext context) {
    Provider.of<StateProvider>(context, listen: true);
    return FutureBuilder(
      future: _getCard(),
      builder: (context, snapshot) {
        // var error = Container(
        //   height: double.infinity,
        //   alignment: Alignment.center,
        //   child:
        //       Text(stateProvider.primaryCard ?? "Set your Primary card now"),
        // );

        var error = Image.asset('assets/images/banktamlets/placeholder.png');
        if (snapshot.hasData) {
          try {
            if ((snapshot.data != null)) {
              return Image.file(
                snapshot.data ?? File(stateProvider.primaryCard),
              );
            }
            return error;
          } catch (e) {
            print("error occured catched");
            print(e);

            return error;
          }
        }
        if (snapshot.hasError) {
          print("error occured snapshot");
          return error;
        } else {
          return error;
        }
      },
    );
  }
}
