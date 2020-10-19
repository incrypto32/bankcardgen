import 'dart:convert';
import 'dart:math';

import 'package:bcard/models/ad.dart';
import 'package:bcard/models/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final CollectionReference banks = firestore.collection('banks');
  static final CollectionReference requests = firestore.collection('requests');
  static final CollectionReference bankAds = firestore.collection('bank_ads');
  static final CollectionReference randomAds =
      firestore.collection('random_ads');
  static final CollectionReference metadata = firestore.collection('metadata');

  Future<void> addBankRequest(BankRequest bankRequest) async {
    try {
      requests.add(bankRequest.toMap());
    } catch (e) {
      print('_________________$e _________________');
    }
  }

  // gets Banks from server and caches the data
  static Future<bool> getBanks({bool caching = false}) async {
    var getOption = GetOptions(
      source: caching ? Source.cache : Source.serverAndCache,
    );
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var bankSnapshots = await banks.orderBy("bank").get(getOption);
      List<Map<String, dynamic>> bankMapList = bankSnapshots.docs.map((e) {
        if (e.exists) {
          return e.data();
        }
      }).toList();
      var bankListJson = json.encode(bankMapList);
      if (!(bankListJson.toString().replaceAll(new RegExp(r"\s+"), '') ==
              '{}' ||
          bankListJson == null)) {
        await prefs.setString(
          "banks",
          bankListJson,
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Function which checks the tiemstamp of the latest data updates on server
  // And accordingly pull data from cache or from server using getBanks()
  static cacheUpdate(SharedPreferences prefs) async {
    Map<String, dynamic> caching = await metadata.doc('caching').get().then(
          (value) => value.exists ? value.data() : null,
        );

    if (caching['caching'] != null && caching['caching']) {
      // The server time stamp from firebase
      Timestamp serverTimeStamp = caching['lud'];

      // Local time stamp from cache
      String localTimeStamp = prefs.getString('lud');

      // If there is a serverTimestamp check whether cache is upto date
      // If not then update cache from server (Done by cache=true in getBanks()))

      if (serverTimeStamp != null && serverTimeStamp.toString().trim() != '') {
        var localTimeStampParsed = localTimeStamp != null
            ? DateTime.parse(
                localTimeStamp) // Parse time stamp from sharedprefs
            : DateTime(2000).toUtc();

        DateTime serverTimeStampUtc = serverTimeStamp.toDate().toUtc();
        bool needCacheUpdate = serverTimeStampUtc.isAfter(localTimeStampParsed);

        if (needCacheUpdate) {
          // Delete existing Cache
          (await getTemporaryDirectory()).delete(recursive: true);
          if (await getBanks()) {
            prefs.setString(
              "lud",
              serverTimeStampUtc.toIso8601String(),
            );
          }
        } else {
          print("cache update not required");
        }
      } else {
        print('serverTimestamp null :$serverTimeStamp');
      }
    } else {
      print('It seems the document dont exist');
      await getBanks();
    }
  }

  // Ads Driver whether be it bank or random
  static Future<Ad> adGetter(String bank) async {
    print("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
    var ads = await metadata.doc('metadata').get();
    if (!ads.data()["ads"] ?? false) {
      print("PRESHNAM IVIDE");
      print("no add");
      return null;
    }
    var bankAdSnaps = await bankAds.where("name", isEqualTo: bank).get();

    if (bankAdSnaps.size <= 0) {
      Ad ad = await getRandomAd();
      print("${ad.assetUrl} ||||||||");
      return ad;
    } else {
      var doc = bankAdSnaps.docs[0];
      if (doc.exists) {
        //
        var ad = doc.data();
        return Ad(name: ad['name'], link: ad['link'], assetUrl: ad['asset']);
      } else {
        return null;
      }
    }
  }

  // Gets a random ad from doc path
  static Future<Ad> getRandomAd() async {
    try {
      print("getRandomAd called");
      var randomAdsDoc = await randomAds.get();
      if (randomAdsDoc.docs.length == 0) {
        return null;
      }
      int n = rand(randomAdsDoc.docs.length - 1) - 1;

      var doc = randomAdsDoc.docs[n].data();
      print("1");
      print(doc["asset"]);
      return Ad(assetUrl: doc["asset"], link: doc["link"], name: doc["name"]);
    } catch (e) {
      print("2");
      return null;
    }
  }

  static int rand(int n) {
    if (n == 0) {
      return 0;
    }
    int r;
    var random = Random();
    r = random.nextInt(n);
    return r + 1;
  }
}
