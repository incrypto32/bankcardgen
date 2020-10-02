import 'dart:typed_data';

import 'package:bcard/image_generator/image_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder<ByteData>(
          future: ImgFromTempelate.generateBankCard({
            "Bank": "federalbank",
            "A/c No": "784598656889635",
            "Name": "John Doe",
            "IFSC": "FDL54865",
            "Branch": "Thrissur",
            "Phone": "7032415896",
            "Email": "johndoe@gmail.com",
            "Gpay": true,
            "Type": "Savings Account"
          }),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var buf = snapshot.data.buffer;
              return Container(
                child: Image.memory(Uint8List.view(buf)),
                // child: Container(),
              );
            }
            return Container();
          }),
    ));
  }
}
