import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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
      banks: _decodeBankList(json["banks"]),
      delete: _decodeBankList(json["delete"]),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'banks': _encodeBankList(banks),
      'delete': _encodeBankList(delete),
    };
  }

  List<Map<String, dynamic>> _encodeBankList(List<Bank> banks) {
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
    final encodedBankList = _encodeBankList(banks);
    final value = await prefs.setString(
      "banks",
      json.encode(encodedBankList),
    );
    print("saved : " + value.toString());
    print("value : " + encodedBankList.toString());
    return value;
  }

  static List<Bank> _decodeBankList(List<dynamic> banksJson) {
    List<Bank> banks = [];
    banksJson.forEach((element) {
      banks.add(Bank.fromJson(element));
    });
    return banks;
  }
}
