import 'package:bankcardmaker/accessories/constants.dart';
import 'package:flutter/material.dart';

class MyDropDown extends StatelessWidget {
  final IconData icon;
  final String displayText;
  final List list;
  final String getter;
  final Function setter;
  final Function setState;
  const MyDropDown({
    Key key,
    this.icon,
    this.displayText,
    this.list,
    this.getter,
    this.setter,
    this.setState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                value: getter,
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
