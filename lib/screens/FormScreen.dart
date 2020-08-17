import 'package:bankcardmaker/models/CardItem.dart';
import 'package:bankcardmaker/widgets/MainAppBar.dart';
import 'package:flutter/material.dart';
import '../accessories/constants.dart';
import 'package:flutter/services.dart';
import '../animations/faded_animation.dart';

class FormScreen extends StatefulWidget {
  static const routeName = "/form_screen";
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  CardItem _cardItem = CardItem();
  var selectedBank;
  var selectedCountry;
  final List<String> _countries = [
    "India",
    "Qatar",
    "Abu Dabi",
    "Kuwait",
    "Sharjah",
    "Muscat"
  ];
  final List<String> _banks = [
    "SBI",
    "Canara Bank",
    "Federal Bank",
    "Axis bank",
    "PNB"
  ];

  var _gPay = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: MainAppBar(
          color: Colors.indigo,
          title: 'Enter Your Details',
        ),
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    // physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //  Divider(),

                        _buildTF(
                          title: "Name",
                          hint: "Enter your Name",
                          icon: Icons.account_circle,
                          input: TextInputType.name,
                          setter: (v) => _cardItem.setPhone = v,
                        ),

                        _buildTF(
                          title: "Account Number",
                          hint: "Enter your Account Number",
                          icon: Icons.account_balance_wallet,
                          input: TextInputType.number,
                          setter: (v) => _cardItem.setPhone = v,
                        ),

                        _buildTF(
                          title: "IFSC",
                          hint: "Enter your IFSC Code",
                          icon: Icons.payment,
                          input: TextInputType.text,
                          setter: (v) => _cardItem.setPhone = v,
                        ),

                        buildDropdown(
                          displayText: 'Choose Your Bank',
                          icon: (Icons.account_balance),
                          value: selectedBank,
                          list: _banks,
                        ),
                        buildDropdown(
                          displayText: 'Choose Your Country',
                          icon: (Icons.public),
                          value: selectedCountry,
                          list: _countries,
                        ),

                        _buildTF(
                          title: "Branch",
                          hint: "Enter your Branch",
                          icon: Icons.business,
                          input: TextInputType.text,
                          setter: (v) => _cardItem.setPhone = v,
                        ),

                        _buildTF(
                          title: "Phone",
                          hint: "Enter your Phone Number",
                          icon: Icons.phone_android,
                          input: TextInputType.phone,
                          setter: (v) => _cardItem.setPhone = v,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: _buildGpaybox(),
                            ),
                          ],
                        ),

                        _buildBtn(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTF({
    String title,
    String hint,
    IconData icon,
    TextInputType input,
    Function setter,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.centerLeft,
      decoration: kBoxDecorationStyle,
      height: 50.0,
      child: TextField(
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

  Widget _buildGpaybox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.grey),
            child: Checkbox(
              value: _gPay,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _gPay = value;
                });
              },
            ),
          ),
          Text(
            'Use For Gpay',
            // style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildBtn() {
    // return FadeAnimation(1,
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width * 0.4,
      child: RaisedButton(
        elevation: 10.0,
        onPressed: () {
          //_savedCards.add(CardItem())
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blue[900],
        child: Text(
          'CREATE',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 15.0,
            // fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Container buildDropdown(
      {IconData icon, String value, String displayText, List list}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.centerLeft,
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
                  .map((value) => DropdownMenuItem(
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black87),
                        ),
                        value: value,
                      ))
                  .toList(),
              onChanged: (selectedValue) {
                print('$selectedValue');
                setState(() {
                  // selectedBank = selectedBranchName;
                  value = selectedValue;
                });
              },
              value: value,
              isExpanded: false,
              hint: Text(
                displayText,
                style: kHintTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
