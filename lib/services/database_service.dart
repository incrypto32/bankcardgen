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

  Future<void> addBankRequest(BankRequest bankRequest) async {
    try {
      requests.add(bankRequest.toMap());
    } catch (e) {
      print('_________________$e _________________');
    }
  }

  // gets Banks from server and caches the data
  static Future<bool> getBanks({bool caching = false}) async {
    print("_______________________getBanks________________________");
    print("getBanks called with caching : $caching ");
    var getOption = GetOptions(
      source: caching ? Source.cache : Source.serverAndCache,
    );
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var bankSnapshots = await banks.get(getOption);
      List<Map<String, dynamic>> bankMapList = bankSnapshots.docs.map((e) {
        if (e.exists) {
          return e.data();
        }
      }).toList();

      var bankListJson = json.encode(bankMapList);

      print(json.decode(bankListJson).runtimeType);
      print(
        "----Caching to Shared Preferences----",
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
      print(
        "|_______________________getBanks ended successfully________________________|",
      );
      return true;
    } catch (e) {
      print(e);
      print(
        "|_______________________getBanks ended with error____________________________|",
      );
      return false;
    }
  }

  // Function which checks the tiemstamp of the latest data updates on server
  // And accordingly pull data from cache or from server using getBanks()
  static cacheUpdate(SharedPreferences prefs) async {
    print(
      '________________________cacheUpdateCheck called_________________________',
    );
    Map<String, dynamic> caching = await metadata
        .doc('caching')
        .get()
        .then((value) => value.exists ? value.data() : null);

    print(caching);

    if (caching['caching'] != null && caching['caching']) {
      print(
        "Caching is ${caching['caching']}",
      );

      Timestamp serverTimeStamp =
          caching['lud']; // The server time stamp from firebase
      String localTimeStamp =
          prefs.getString('lud'); // Local time stamp from cache

      // If there is a serverTimestamp check whether cache is upto date
      // If not then update cache from server (Done by cache=true in getBanks()))

      if (serverTimeStamp != null && serverTimeStamp.toString().trim() != '') {
        print(
          'lud available in server in utc it is ${caching['lud'].toDate().toUtc().toIso8601String()}',
        );

        print('ISO string timestamp from cache is $localTimeStamp');

        var localTimeStampParsed = localTimeStamp != null
            ? DateTime.parse(
                localTimeStamp) // Parse time stamp from sharedprefs
            : DateTime(2000).toUtc();

        print(
            'parsed local timestamp is ${localTimeStampParsed.toIso8601String()}');
        print(
            'parsed local timestamp in utc is ${localTimeStampParsed.toUtc().toIso8601String()}');

        DateTime serverTimeStampUtc = serverTimeStamp.toDate().toUtc();
        bool needCacheUpdate = serverTimeStampUtc.isAfter(localTimeStampParsed);
        print(needCacheUpdate
            ? 'cache needs update'
            : 'cache update not required');
        if (needCacheUpdate) {
          print('updating Cache');
          if (await getBanks()) {
            prefs.setString(
              "lud",
              serverTimeStampUtc.toIso8601String(),
            );
          }
        } else {
          print(
            "uncomment here if shared preferences need update from local cache",
          );
          // await getBanks(caching: true);
        }
      } else {
        print('serverTimestamp null :$serverTimeStamp');
      }
    } else {
      print('It seems the document dont exist');
      await getBanks();
    }
    print('|_______________________cache update end_________________________|');
  }

  static Future<DocumentReference> requestBank(BankRequest request) async {
    var doc = banks.add(request.toMap());
    return doc;
  }

// Ads Driver whether be it bank or random
  static Future<Ad> getAd(String bank) async {
    print("_______________getAd called_________________");

    int rand(n, dn) {
      print("-----random number func called-----");
      int r;
      var random = Random();
      do {
        r = random.nextInt(n);
      } while (r + 1 == dn);
      print("----random number output: ${r + 1}----");
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

  // Test functions
  static Future test(String path) async {
    for (var i = 0; i <= 10; i++) {
      banks.get(GetOptions(source: Source.server)).then((value) {
        value.docs.forEach((element) {
          print(element.data());
        });
      });
    }
  }
}
