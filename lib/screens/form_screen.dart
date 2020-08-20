import 'package:bankcardmaker/imageGen/image_generator.dart';
import 'package:bankcardmaker/models/card_item.dart';
import 'package:bankcardmaker/widgets/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    "PNB",
    "yes"
  ];

  var _gPay = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: MainAppBar(
          color: Colors.transparent,
          textColor: Colors.white,
          title: 'Enter Your Details',
        ),
        backgroundColor: Colors.indigo,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
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
                      setter: (v) => _cardItem.setName = v,
                    ),

                    buildDropdown(
                      displayText: 'Choose Your Country',
                      icon: (Icons.public),
                      list: _countries,
                      getter: () => _cardItem.getCountry,
                      setter: (v) => _cardItem.setCountry = v,
                    ),
                    buildDropdown(
                      displayText: 'Choose Your Bank',
                      icon: (Icons.account_balance),
                      list: _banks,
                      getter: () => _cardItem.getBank,
                      setter: (v) => _cardItem.setBank = v,
                    ),

                    _buildTF(
                      title: "Account Number",
                      hint: "Enter your Account Number",
                      icon: Icons.account_balance_wallet,
                      input: TextInputType.number,
                      setter: (v) => _cardItem.setAccountNo = v,
                    ),

                    _buildTF(
                      title: "IFSC",
                      hint: "Enter your IFSC Code",
                      icon: Icons.payment,
                      input: TextInputType.text,
                      setter: (v) => _cardItem.setIfsc = v,
                    ),

                    _buildTF(
                      title: "Branch",
                      hint: "Enter your Branch",
                      icon: Icons.business,
                      input: TextInputType.text,
                      setter: (v) => _cardItem.setBranch = v,
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
                        _buildGpaybox(
                            getter: () => _cardItem.getGpay,
                            setter: (v) => _cardItem.setGpay = v),
                      ],
                    ),
                    _buildBtn(),
                  ],
                ),
              ),
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

  Widget _buildBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width * 0.4,
      child: RaisedButton(
        elevation: 10.0,
        onPressed: () async {
          _formKey.currentState.save();
          print(_cardItem.toMap);
          final imgBytes =
              await ImgFromTempelate.generateBankCard(_cardItem.toMap);
          _showDialog(context, imgBytes);
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
            fontFamily: 'OpenSans',
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
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
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
                isExpanded: true,
                hint: Text(
                  displayText,
                  style: kHintTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showDialog(context, ByteData imgBytes) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          title: Container(
            child: Text(
              "Your Card is Successfully Generated !",
              style: TextStyle(color: Colors.green, fontSize: 15),
            ),
          ),
          // content: Image.asset('assets/images/banktamlets/yes.png'),
          content: Image.memory(imgBytes.buffer.asUint8List()),
          actions: [
            FlatButton(
              onPressed: () {},
              child: Row(
                children: [
                  FaIcon(
                    Icons.delete,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "DISCARD",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              color: Colors.red[700],
            ),
            FlatButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.solidSave,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "SAVE",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              color: Colors.green[700],
            ),
          ]);
    },
  );
}
