import 'package:bankcardmaker/widgets/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bankcardmaker/accessories/constants.dart';

class bankRequestForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return formState();
  }
}

class formState extends State<bankRequestForm> {
  final _formKey = GlobalKey<FormState>();
  String _country;
  String _bankName;
  get getCountry => this._country;
  set setCountry(String value) {
    this._country = value;
  }

  var selectedCountry;
  final List<String> _countries = [
    "India",
    "Qatar",
    "Abu Dabi",
    "Kuwait",
    "Sharjah",
    "Muscat"
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: MainAppBar(
          color: Colors.transparent,
          textColor: Colors.white,
          title: 'Request bank details',
        ),
        backgroundColor: Colors.indigo,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
        //         Icon(
        //              Icons.account_balance,
        //              color: Colors.indigo[200],
        //             size: 150,
        //            ),
                Container(
                  height: 15,
                ),

                //Dropdown button selecting country
                buildDropdown(
                  displayText: 'Choose Your Country',
                  icon: (Icons.public),
                  list: _countries,
                  getter: () {
                    print("Getterreeey");
                    print(getCountry);
                    return getCountry;
                  },
                  setter: (v) => setCountry = v,
                ),
                Container(
                  height: 15,
                ),

                //textfield for entering bankname
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.centerLeft,
                  decoration: kBoxDecorationStyle,
                  height: 50.0,
                  child: TextFormField(
                    onSaved: (String value) {
                      this._bankName = value;
                    },
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "OpenSans",
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 14.0),
                      prefixIcon: Icon(
                        Icons.account_balance,
                        color: Colors.grey,
                      ),
                      hintText: "Enter your Bank name",
                      hintStyle: kHintTextStyle,
                    ),
                  ),
                ),
                Container(
                  height: 8,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: RaisedButton(
                    elevation: 10.0,
                    onPressed: () {
                      _formKey.currentState.save();
                      debugPrint("${this._bankName} in $getCountry");
                    },
                    padding: EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Colors.blue[900],
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.5,
                        fontSize: 15.0,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ),
            //   Icon(
            //          Icons.account_balance,
            //            color: Colors.indigo[200],
            //            size: 100,
            //        ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildDropdown({
    IconData icon,
    String displayText,
    List list,
    Function getter,
    Function setter,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.topCenter,
      decoration: kBoxDecorationStyle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              icon,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: DropdownButton(
              underline: Text(""),
              items: list
                  .map(
                    (value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black87),
                      ),
                      value: value,
                    ),
                  )
                  .toList(),
              onChanged: (selectedValue) {
                setState(() {
                  setter(selectedValue);
                });
              },
              value: getter(),
              isExpanded: false,
              hint: Text(displayText, style: kHintTextStyle),
            ),
          ),
        ],
      ),
    );
  }
}
