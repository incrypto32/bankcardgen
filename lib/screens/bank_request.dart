import 'package:bcard/constants/countries.dart';
import 'package:bcard/models/request.dart';
import 'package:bcard/services/database_service.dart';
import 'package:bcard/widgets/country_picker.dart';
import 'package:bcard/widgets/main_appbar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:bcard/accessories/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BankRequestForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BankRequestFormState();
  }

  static final String routeName = '/bankRequestForm';
}

class _BankRequestFormState extends State<BankRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldState>();
  bool _isError = false;
  BankRequest _bankRequest = BankRequest(country: countries[0]['name']);
  bool _loading = false;

  void _startLoading() {
    if (!_loading) {
      setState(() {
        _loading = true;
      });
    }
  }

  void _stopLoading() {
    if (_loading) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _showDialog(context, String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(8),
            title: Container(
                padding: EdgeInsets.all(10),
                height: 40,
                child: Center(
                    child: Text(
                  msg,
                  style: TextStyle(color: Colors.green),
                ))),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Ok")),
            ],
          );
        });
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(
      String msg) {
    return _globalKey.currentState.showSnackBar(
      SnackBar(
        content: Container(
          height: 20,
          alignment: Alignment.center,
          child: FittedBox(
            child: Text(
              msg,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  void addRequest({BuildContext context, BankRequest bankRequest}) async {
    if (!_formKey.currentState.validate()) {
      print("Bank Details Not Provided ");
      return;
    }

    ConnectivityResult connection = await Connectivity().checkConnectivity();

    if (connection == ConnectivityResult.none) {
      print("___________________NETWORK ISSUE_______________");
      _showSnackBar("Request Failed. Please check your network connection !");
    } else {
      if (!_loading) {
        try {
          _startLoading();
          print('\n ${bankRequest.bank} in ${bankRequest.country}');
          await DatabaseService().addBankRequest(bankRequest).whenComplete(() {
            _showDialog(context, "Request submitted successfully !");
            _stopLoading();
          });
        } catch (e) {
          _stopLoading();
          _showSnackBar('Error Occured. Check your Network Connection !');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _globalKey,
        appBar: MainAppBar(
          color: Colors.transparent,
          textColor: Colors.white,
          title: 'Request bank details',
        ),
        backgroundColor: Colors.indigo,
        body: _loading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitRing(
                    color: Colors.white,
                    size: 30,
                    lineWidth: 5,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Submitting your Request ..",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  // physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance,
                        color: Colors.indigo[200],
                        size: 150,
                      ),
                      Container(height: 15),
                      //dropdown for selecting country
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.topCenter,
                        decoration: kBoxDecorationStyle,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.public,
                                color: Colors.grey,
                              ),
                            ),
                            Expanded(
                              child: CountryPicker(
                                onChanged: (val) {
                                  setState(() {
                                    this._bankRequest.country = val.name;
                                  });
                                },
                                showFlagMain: true,
                                // hideSearch: true,
                                favorite: ['IN', 'US'],
                                // countryFilter: ['US', 'IN'],
                                showOnlyCountryWhenClosed: true,
                                alignLeft: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(height: 15),
                      //textfield for entering bankname
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.centerLeft,
                        decoration: kBoxDecorationStyle,
                        height: _isError ? 70 : 50,
                        child: TextFormField(
                          onChanged: (String value) {
                            setState(() {
                              this._bankRequest.bank = value;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                _isError = true;
                              });
                              return 'Please provide bank details';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "OpenSans",
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(14.0),
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
                          onPressed: () => addRequest(
                              context: context, bankRequest: this._bankRequest),
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
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

//Dropdown button selecting country
// buildDropdown(
//   displayText: 'Choose Your Country',
//   icon: (Icons.public),
//   list: _countries,
//   getter: () {
//     print("Getterreeey");
//     print(getCountry);
//     return getCountry;
//   },
//   setter: (v) => setCountry = v,
// ),

// Container buildDropdown({
//   IconData icon,
//   String displayText,
//   List list,
//   Function getter,
//   Function setter,
// }) {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 10),
//     margin: EdgeInsets.symmetric(vertical: 5),
//     alignment: Alignment.topCenter,
//     decoration: kBoxDecorationStyle,
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Container(
//           margin: EdgeInsets.symmetric(horizontal: 10),
//           child: Icon(
//             icon,
//             color: Colors.grey,
//           ),
//         ),
//         Expanded(
//           child: DropdownButton(
//             underline: Text(""),
//             items: list
//                 .map(
//                   (value) => DropdownMenuItem(
//                     child: Text(
//                       value,
//                       style: TextStyle(color: Colors.black87),
//                     ),
//                     value: value,
//                   ),
//                 )
//                 .toList(),
//             onChanged: (selectedValue) {
//               setState(() {
//                 setter(selectedValue);
//               });
//             },
//             value: getter(),
//             isExpanded: false,
//             hint: Text(displayText, style: kHintTextStyle),
//           ),
//         ),
//       ],
//     ),
//   );
// }
