import 'dart:convert';

import 'package:bankcardmaker/services/banks.dart';
import 'package:bankcardmaker/models/card_item.dart';

import 'package:bankcardmaker/widgets/create_button.dart';
import 'package:bankcardmaker/widgets/my_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  Future<List<String>> _getCountryList(context) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var banksString = await prefs.get("banks");
      (banksString == null || banksString == '[]')
          ? Scaffold.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 8),
                content: Text(
                  "Please check your network connection",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : print("Network connection existsI");

      var banksJson = json.decode(banksString);
      _banks = ServerJsonResponse.decodeBankList(banksJson);
      var countries = _banks.map((e) => e.country).toSet().toList();
      return countries;
    } catch (e) {
      print(e);
      return null;
    }
  }

  _getBankList(String country) {
    var list = _banks ?? [];
    print("_________________Getting banklist___________________");
    print(_banks);
    _bankOptions =
        list.where((e) => e.country == country).map((e) => e.bank).toList();
    print(_bankOptions.toString());

    // if()
    // _cardItem.setBank = _bankOptions[0] ?? '';
    return _bankOptions;
  }

  String bankCode = "IFSC";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Builder(builder: (context) {
        return FutureBuilder<List<String>>(
            future: _getCountryList(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(
                  "_____________________SnapShot data______________________",
                );
                print(snapshot.data);
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
                              getter: _cardItem.getCountry,
                              setter: (v) {
                                setState(() {
                                  _cardItem.setCountry = v;
                                  _cardItem.setBank = null;
                                  _cardItem.setGpay = false;
                                  if (v == "India") {
                                    bankCode = "IFSC";
                                  } else {
                                    bankCode = "IBAN";
                                  }
                                  print(
                                    "______________Country  Changed to $v ____________",
                                  );
                                });
                              },
                            ),
                            MyDropDown(
                              displayText: 'Choose Your Bank',
                              icon: (Icons.account_balance),
                              list: _getBankList(_cardItem.getCountry ?? '') ??
                                  [],
                              getter: _cardItem.getBank,
                              setter: (v) {
                                setState(() {
                                  _cardItem.setBank = v;
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
                            MyDropDown(
                              displayText: 'Account Type',
                              icon: (Icons.account_balance),
                              list: [
                                "Savings Account",
                                "Current Account",
                                "NRO Account",
                                "NRE Account"
                              ],
                              getter: _cardItem.getType,
                              setter: (v) {
                                setState(() {
                                  _cardItem.setType = v;
                                });
                              },
                            ),

                            MyTextBox(
                              title: "IFSC",
                              hint: "Enter your $bankCode Code",
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

                            _cardItem.country == 'India'
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _buildGpaybox(
                                          getter: () => _cardItem.getGpay,
                                          setter: (v) => _cardItem.setGpay = v),
                                    ],
                                  )
                                : Container(),

                            CreateButton(
                                formKey: _formKey, cardItem: _cardItem),
                            // AdWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Container(
                    child: SpinKitCircle(
                      color: Colors.white,
                      size: 45,
                    ),
                  ),
                );
              }
            });
      }),
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
