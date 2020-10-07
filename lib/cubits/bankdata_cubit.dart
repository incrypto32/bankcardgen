import 'dart:convert';

import 'package:bcard/models/card_item.dart';
import 'package:bcard/services/banks.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'bankdata_state.dart';

class BankdataCubit extends Cubit<BankdataState> {
  final CardItem cardItem;
  final SharedPreferences prefs;
  BankdataCubit(this.cardItem, this.prefs) : super(BankdataInitial());

  getCountries(BuildContext context) async {
    try {
      var banksString = await prefs.get("banks");
      var banksJson = json.decode(banksString);
      var _banks = ServerJsonResponse.decodeBankList(banksJson);
      var countries = _banks.map((e) => e.country).toSet().toList();
      emit(CountriesData(countries));
    } catch (e) {
      print(e);
      emit(BankDataError("Please check your network connection"));
    }
  }
}
