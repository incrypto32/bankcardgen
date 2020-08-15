import 'package:bankcardmaker/models/card_item.dart';
import 'package:flutter/material.dart';
import '../accessories/constants.dart';
import 'package:flutter/services.dart';

class FormScreen extends StatefulWidget {
  static const routeName = "/form_screen";
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  List<CardItem> _savedCards=[];
  var selectedBank;
  var selectedCountry;
  final List<String> _countries=[
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
  var _gPay=false;

  Widget _buildTF(String title, String hint, IconData icon,TextInputType input) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text(
        //   title,
        //   style: kLabelStyle,
        // ),
        SizedBox(height: 10.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
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
            // enabledBorder:OutlineInputBorder(
            // borderSide: const BorderSide(color: Colors.white, width: 2.0),
            // borderRadius: BorderRadius.circular(25.0),
          // ),
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
        ),
      ],
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width*0.4,
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:Colors.grey[100]
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: [Colors.white38,Colors.white60,Colors.white70,],
                    //   stops: [0.1, 0.5, 0.7],
                    // ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 50.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Enter Your Details',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'OpenSans',
                            fontSize: 21.0,
                          ),
                        ),
                      //  Divider(),
                        SizedBox(height: 20.0),
                        _buildTF(
                            "Name", "Enter your Name", Icons.account_circle,TextInputType.name),
                        SizedBox(
                          height: 5.0,
                        ),
                        _buildTF("Account Number", "Enter your Account Number",
                            Icons.account_balance_wallet,TextInputType.number),
                        SizedBox(
                          height: 5,
                        ),
                        _buildTF("IFSC", "Enter your IFSC Code", Icons.payment,TextInputType.text),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Text(
                            //   title,
                            //   style: kLabelStyle,
                            // ),
                            SizedBox(height: 10.0),
                            Container(padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              decoration: kBoxDecorationStyle,
                              height: 50.0,
                              child: Row(
                                
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(width:10),
                                  Icon(Icons.account_balance,
                                  color: Colors.grey,),
                                  SizedBox(width: 10,),

                              Expanded(
                                                              child: DropdownButton(
                                                         underline: Text(""),       
                                  items: _banks
                                      .map((value) => DropdownMenuItem(
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: Colors.black87),
                                            ),
                                            value: value,
                                          ))
                                      .toList(),
                                  onChanged: (selectedBranchName) {
                                    print('$selectedBranchName');
                                    setState(() {
                                      selectedBank = selectedBranchName;
                                    });
                                  },
                                  value: selectedBank,
                                  isExpanded: false,
                                  hint: Text(
                                    'Choose Your Bank',
                                    style: kHintTextStyle,
                                  ),
                                ),
                              ),

                                ],
                              ),
                              
                              
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Text(
                            //   title,
                            //   style: kLabelStyle,
                            // ),
                            SizedBox(height: 10.0),
                            Container(padding: EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              decoration: kBoxDecorationStyle,
                              height: 50.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(width:10),
                                  Icon(Icons.public,
                                  color: Colors.grey,),
                                  SizedBox(width: 10,),

                              Expanded(
                                                              child: DropdownButton(
                                                                underline: Text(""),

                                  items: _countries
                                      .map((value) => DropdownMenuItem(
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: Colors.black87),
                                            ),
                                            value: value,
                                          ))
                                      .toList(),
                                  onChanged: (selectedCountryName) {
                                    print('$selectedCountry');
                                    setState(() {
                                      selectedCountry = selectedCountryName;
                                    });
                                  },
                                  value: selectedCountry,
                                  isExpanded: false,
                                  hint: Text(
                                    'Choose Your Country',
                                    style: kHintTextStyle,
                                  ),
                                ),
                              ),

                                ],
                              ),
                              
                              
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        _buildTF("Branch", "Enter your Branch", Icons.business,TextInputType.text),
                        SizedBox(
                          height: 5,
                        ),
                        // _buildTF("Phone", "Enter your Phone", Icons.phone),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        _buildTF("GPay", "Enter your Phone Number",
                            Icons.phone_android,TextInputType.phone),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
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
}
