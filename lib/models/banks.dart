import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:bankcardmaker/constants/constants.dart';

import 'package:http/http.dart' as http;

class Bank {
  final String bank;
  final String country;

  Bank({this.bank, this.country});
  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      bank: json['bank'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() => {
        'bank': bank,
        'country': country,
      };
}

class ServerJsonResponse {
  final List<Bank> banks;
  final List<Bank> delete;

  ServerJsonResponse({this.banks, this.delete});
  factory ServerJsonResponse.fromJson(Map<String, dynamic> json) {
    return ServerJsonResponse(
      banks: decodeBankList(json["banks"]),
      delete: decodeBankList(json["delete"]),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'banks': encodeBankList(banks),
      'delete': encodeBankList(delete),
    };
  }

  static List<Map<String, dynamic>> encodeBankList(List<Bank> banks) {
    List<Map<String, dynamic>> bankListMap = [];

    banks.forEach(
      (element) {
        bankListMap.add(
          element.toJson(),
        );
      },
    );

    return bankListMap;
  }

  Future<bool> saveToSharePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedBankList = encodeBankList(banks);
    final value = await prefs.setString(
      "banks",
      json.encode(encodedBankList),
    );
    print("saved : " + value.toString());
    print("value : " + encodedBankList.toString());
    return value;
  }

  static List<Bank> decodeBankList(List<dynamic> banksJson) {
    List<Bank> banks = [];
    banksJson.forEach((element) {
      banks.add(Bank.fromJson(element));
    });
    return banks;
  }
}

void downloadAndCaching() async {
  http.get(backendDataUrl).then((response) {
    ServerJsonResponse serverJsonResponse;
    if (response.statusCode == 200) {
      serverJsonResponse = ServerJsonResponse.fromJson(
        json.decode(response.body),
      );
    } else {
      print("Error fetching data");
    }
    serverJsonResponse.saveToSharePrefs();
  }).catchError((e) {
    print(e);
  });
}
