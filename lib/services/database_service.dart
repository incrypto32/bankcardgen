import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference banks = firestore.collection('banks');

class DatabaseService {
  Future<void> addBank() {
    return banks.add({});
  }

  static Future<void> getBanks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(banks);
      var bankSnapshots = await banks.get();
      List<Map<String, dynamic>> bankMapList = bankSnapshots.docs.map((e) {
        if (e.exists) {
          return e.data();
        }
      }).toList();

      var bankListJson = json.encode(bankMapList);

      print(json.decode(bankListJson).runtimeType);
      print(
        "__________________Caching to Shared Preferences___________________",
      );
      bool value;
      if (!(bankListJson.toString().replaceAll(new RegExp(r"\s+"), '') ==
              '{}' ||
          bankListJson == null)) {
        value = await prefs.setString(
          "banks",
          bankListJson,
        );
      }
      print("saved : " + value.toString());
      print("value : " + bankListJson.toString());
    } catch (e) {
      print(e);
    }
  }
}
