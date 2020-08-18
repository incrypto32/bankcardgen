import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.centerLeft,
            // color: Colors.cyanAccent,
            margin: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Text(
              "Primary Card",
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                offset: Offset(10, 10),
                blurRadius: 40,
                color: Colors.grey,
                spreadRadius: 0,
              )
            ]),
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Image.asset('assets/images/banktamlets/yes.png'),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Material(
              color: Colors.transparent,
              child: Column(
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
                    onTap: () =>
                        Navigator.of(context).pushNamed('/form_screen'),
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
                  ),
                  ListTile(
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
            ),
          ),
        ),
      ],
    );
  }
}
