import 'dart:convert';

import 'package:bankcardmaker/services/banks.dart';
import 'package:bankcardmaker/services/database_service.dart';
import 'package:bankcardmaker/models/card_item.dart';
import 'package:bankcardmaker/widgets/create_button.dart';
import 'package:bankcardmaker/widgets/main_appbar.dart';
import 'package:bankcardmaker/widgets/my_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../accessories/constants.dart';
import 'package:flutter/services.dart';
// import '../animations/faded_animation.dart';

class FormScreen extends StatefulWidget {
  static const routeName = "/form_screen";

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  CardItem _cardItem = CardItem();

  List<Bank> _banks;
  List<String> _bankOptions = [];

  Future<List<String>> _getCountryList() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var banksString = await prefs.get("banks");
      var banksJson = json.decode(banksString);
      _banks = ServerJsonResponse.decodeBankList(banksJson);
      var countries = _banks.map((e) => e.country).toSet().toList();
      return countries;
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<String> _getBankList(String country) {
    var list = _banks ?? [];
    return list.where((e) => e.country == country).map((e) => e.bank).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: MainAppBar(
        //   color: Colors.transparent,
        //   textColor: Colors.white,
        //   title: 'Enter Your Details',
        // ),
        backgroundColor: Colors.indigo,
        body: FutureBuilder<List<String>>(
            future: _getCountryList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //  Divider(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 40, 0, 30),
                              child: Text("Enter Your Details",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(color: Colors.white)),
                            ),
                            MyTextBox(
                              title: "Name",
                              hint: "Enter your Name",
                              icon: Icons.account_circle,
                              input: TextInputType.name,
                              setter: (v) => _cardItem.setName = v,
                            ),

                            MyDropDown(
                              displayText: 'Choose Your Country',
                              icon: (Icons.public),
                              list: snapshot.data,
                              getter: () => _cardItem.getCountry,
                              setter: (v) => _cardItem.setCountry = v,
                              setState: (Function func) {
                                setState(() {
                                  func();
                                  _bankOptions =
                                      _getBankList(_cardItem.getCountry);
                                });
                              },
                            ),
                            MyDropDown(
                              displayText: 'Choose Your Bank',
                              icon: (Icons.account_balance),
                              list: _bankOptions ?? [],
                              getter: () => _cardItem.getBank,
                              setter: (v) => _cardItem.setBank = v,
                              setState: (Function func) {
                                setState(() {
                                  func();
                                });
                              },
                            ),

                            MyTextBox(
                              title: "Account Number",
                              hint: "Enter your Account Number",
                              icon: Icons.account_balance_wallet,
                              input: TextInputType.number,
                              setter: (v) => _cardItem.setAccountNo = v,
                            ),

                            MyTextBox(
                              title: "IFSC",
                              hint: "Enter your IFSC Code",
                              icon: Icons.payment,
                              input: TextInputType.text,
                              setter: (v) => _cardItem.setIfsc = v,
                            ),

                            MyTextBox(
                              title: "Branch",
                              hint: "Enter your Branch",
                              icon: Icons.business,
                              input: TextInputType.text,
                              setter: (v) => _cardItem.setBranch = v,
                            ),
                            MyTextBox(
                              title: "Email",
                              hint: "Enter your Email Address",
                              icon: Icons.email,
                              input: TextInputType.text,
                              setter: (v) => _cardItem.setEmail = v,
                            ),
                            MyTextBox(
                              title: "Phone",
                              hint: "Enter your Phone Number",
                              icon: Icons.phone_android,
                              input: TextInputType.phone,
                              setter: (v) => _cardItem.setPhone = v,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _buildGpaybox(
                                    getter: () => _cardItem.getGpay,
                                    setter: (v) => _cardItem.setGpay = v),
                              ],
                            ),

                            CreateButton(
                                formKey: _formKey, cardItem: _cardItem),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Container(
                    child: Text("An error occured"),
                  ),
                );
              }
            }),
      ),
    );
  }

// Build Gpay checkbox
  Widget _buildGpaybox({Function getter, Function setter}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.grey,
            ),
            child: Checkbox(
              value: getter() ?? false,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  setter(value);
                });
              },
            ),
          ),
          Text(
            'Gpay',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class MyTextBox extends StatelessWidget {
  final String title;
  final String hint;
  final IconData icon;
  final TextInputType input;
  final Function setter;

  MyTextBox({this.title, this.hint, this.icon, this.input, this.setter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.centerLeft,
      decoration: kBoxDecorationStyle,
      height: 50.0,
      child: TextFormField(
        onSaved: setter,
        keyboardType: input,
        style: TextStyle(
          color: Colors.black,
          fontFamily: "OpenSans",
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
          ),
          hintText: hint,
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }
}

// Card Popup
