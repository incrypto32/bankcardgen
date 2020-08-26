import 'package:bankcardmaker/screens/bank_request.dart';
import 'package:bankcardmaker/screens/info_screen.dart';
import 'package:bankcardmaker/screens/saved_cards_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final listTileContentPadding =
        EdgeInsets.symmetric(vertical: 5, horizontal: 20);
    return ListView(
      children: [
        DrawerHeader(
          child: Center(
            child: Text(
              "Card Generator",
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        Column(
          children: [
            // Row(
            //   children: [
            //     Expanded(
            //         child: Column(
            //       children: [
            //         FaIcon(
            //           FontAwesomeIcons.idCard,
            //           size: 40,
            //         ),
            //         Divider(
            //           indent: 5,
            //           endIndent: 5,
            //         ),
            //         Text("Add New Card")
            //       ],
            //     )),
            //     Expanded(
            //         child: Column(
            //       children: [
            //         FaIcon(
            //           FontAwesomeIcons.save,
            //           size: 40,
            //         ),
            //         Divider(
            //           indent: 5,
            //           endIndent: 5,
            //         ),
            //         Text("Saved Cards")
            //       ],
            //     ))
            //   ],
            // ),
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
              onTap: () =>
                  Navigator.of(context).pushNamed(SavedCardsScreen.routeName),
              contentPadding: listTileContentPadding,
              leading: FaIcon(
                FontAwesomeIcons.solidSave,
                color: Colors.black,
                size: 30,
              ),
              title: Text("Saved Cards"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () =>
                  Navigator.of(context).pushNamed(BankRequestForm.routeName),
              contentPadding: listTileContentPadding,
              leading: FaIcon(
                FontAwesomeIcons.infoCircle,
                color: Colors.black,
                size: 30,
              ),
              title: Text("Request a bank"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () =>
                  Navigator.of(context).pushNamed(InfoScreen.routeName),
              contentPadding: listTileContentPadding,
              leading: FaIcon(
                Icons.settings,
                color: Colors.black,
                size: 30,
              ),
              title: Text("Settings"),
              trailing: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ],
    );
  }
}
