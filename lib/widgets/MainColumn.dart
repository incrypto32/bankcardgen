import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainColumn extends StatelessWidget {
  const MainColumn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(40),
          width: double.infinity,
          child: Text(
            "Create Card",
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontSize: 25,
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
          child: Image.asset('assets/images/banktamlets/yes.png'),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  leading: FaIcon(
                    FontAwesomeIcons.solidCreditCard,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: Text("Create New Card"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  leading: FaIcon(
                    FontAwesomeIcons.solidSave,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: Text("Saved Cards"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  leading: FaIcon(
                    FontAwesomeIcons.infoCircle,
                    color: Colors.black,
                    size: 30,
                  ),
                  title: Text("Request a bank"),
                  trailing: Icon(Icons.chevron_right),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
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
      ],
    );
  }
}
