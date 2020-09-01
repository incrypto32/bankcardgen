import 'dart:convert';
import 'dart:math';

import 'package:bankcardmaker/models/ad.dart';
import 'package:bankcardmaker/models/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static CollectionReference banks = firestore.collection('banks');
  static CollectionReference requests = firestore.collection('requests');
  static CollectionReference bankAds = firestore.collection('bank_ads');
  static CollectionReference randomAds = firestore.collection('random_ads');
  static CollectionReference metadata = firestore.collection('metadata');
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

  static Future<DocumentReference> requestBank(BankRequest request) async {
    var doc = await banks.add(request.toMap());
    return doc;
  }

// Ads Driver whether be it bank or random
  static Future<Ad> getAd(String bank) async {
    print("_______________getAd called_________________");
    int rand(n, dn) {
      int r;
      var random = Random();
      do {
        r = random.nextInt(n);
      } while (r + 1 == dn);
      print("random number output: ${r + 1}");
      return r + 1;
    }

    print("Bank is $bank");

    var bankAdSnaps = await bankAds.where("name", isEqualTo: bank).get();
    print(bankAdSnaps.size);
    if (bankAdSnaps.size <= 0) {
      var noOfrandAdsDoc = await metadata.doc('nrandom').get();
      var numdata = noOfrandAdsDoc.data();

      if (numdata != null && numdata['nrandom'] != null) {
        var n = numdata['nrandom'];
        int dn = numdata['deleted_random'];

        var ad = await getRandomAd(rand(n, dn).toString());
        if (ad != null) {
          print("getAd output: ${ad.toString()}");
          return Ad(name: ad['name'], link: ad['link'], assetUrl: ad['asset']);
        }
        // randomAdSnaps !=null ? docs=randomAdSnaps.
      }
      // var n;
    } else {
      var doc = bankAdSnaps.docs[0];
      if (doc.exists) {
        //
        var ad = doc.data();
        print("Bank Exists");
        print(ad);
        return Ad(name: ad['name'], link: ad['link'], assetUrl: ad['asset']);
      } else {
        return null;
      }
    }
    return null;
  }

  // Gets a random ad from doc path
  static Future<Map<String, dynamic>> getRandomAd(String path) async {
    print("Random Ad called");
    var randomAdsDoc = randomAds.doc(path);
    var a = await randomAdsDoc.get().then((value) {
      if (value.exists) {
        return value.data();
      } else {
        return null;
      }
    }).catchError((e) {
      print(e);
      return null;
    });
    print("Random ad output : ${a.toString()}");
    return a;
  }

  // // Test functions
  // static Future test(String path) async {
  //   getAd("Federal");
  //   print("test");
  //   // var bankAdSnaps =
  //   //     bankAds.get(GetOptions(source: Source.server)).then((value) {
  //   //   print("then");
  //   //   print(value.docs);
  //   //   value.docs.forEach((element) {
  //   //     print(element.data());
  //   //   });
  //   // }).catchError((e) {
  //   //   print(e);
  //   // });
  // }
}
