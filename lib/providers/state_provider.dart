import 'package:flutter/cupertino.dart';

class StateProvider with ChangeNotifier {
  String _primaryCard;

  String get primaryCard => _primaryCard;

  void changePrimaryCard(String card) {
    _primaryCard = card;

    notifyListeners();
  }
}

StateProvider stateProvider = StateProvider();
