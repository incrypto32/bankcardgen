import 'package:bankcardmaker/widgets/primary_cards.dart';
import 'package:flutter/cupertino.dart';

class StateProvider with ChangeNotifier {
  String _primaryCard;

  String get primaryCard => _primaryCard;

  void changePrimaryCard(String card) {
    _primaryCard = card;
    print(card);
    print(_primaryCard);
    notifyListeners();
  }
}

StateProvider stateProvider = StateProvider();
