import 'package:bcard/providers/state_provider.dart';
import 'package:bcard/widgets/primary_cards.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../screens/saved_cards_screen.dart';
import 'package:bcard/screens/bank_request.dart';
import '../screens/info_screen.dart';

class MainColumn extends StatelessWidget {
  const MainColumn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listTileContentPadding =
        EdgeInsets.symmetric(vertical: 5, horizontal: 20);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(20),
          width: double.infinity,
          child: Text(
            "Primary Card",
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              offset: Offset(10, 10),
              blurRadius: 40,
              color: Colors.grey,
              spreadRadius: 0,
            )
          ]),
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: ChangeNotifierProvider.value(
            value: stateProvider,
            child: PrimaryCard(),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                ListTile(
                  enabled: true,
                  onTap: () => Navigator.of(context).pushNamed('/form_screen'),
                  contentPadding: listTileContentPadding,
                  leading: FaIcon(
                    FontAwesomeIcons.solidCreditCard,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: Text("Create New Card"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  contentPadding: listTileContentPadding,
                  leading: FaIcon(
                    FontAwesomeIcons.solidSave,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: Text("Saved Cards"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pushNamed(SavedCardsScreen.routeName);
                  },
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return BankRequestForm();
                    }));
                  },
                  contentPadding: listTileContentPadding,
                  leading: FaIcon(
                    Icons.account_balance,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: Text("Request a bank"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoScreen(),
                      ),
                    );
                  },
                  contentPadding: listTileContentPadding,
                  leading: FaIcon(
                    FontAwesomeIcons.infoCircle,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: Text("Info"),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
