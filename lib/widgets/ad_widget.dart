import 'dart:typed_data';

import 'package:bankcardmaker/models/ad.dart';
import 'package:bankcardmaker/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AdWidget extends StatelessWidget {
  const AdWidget({Key key, this.showPopupFunc, this.imgFuture, this.bank})
      : super(key: key);
  final Function showPopupFunc;
  final Future<ByteData> imgFuture;
  final String bank;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.all(0),
      insetPadding: EdgeInsets.all(10),
      elevation: 0,
      content: FutureBuilder<Ad>(
          future: DatabaseService.getAd(bank),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Image.network(
                      snapshot.data.assetUrl,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 5,
                    child: Container(
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white38,
                      ),

                      // margin: EdgeInsets.only(right: 10, bottom: 10),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(
                            Icons.close,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                height: 1,
              );
            }
          }),
      actions: [
        Container(
          width: double.maxFinite,
          child: Row(
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              FutureBuilder<ByteData>(
                  future: imgFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          RaisedButton(
                              color: Colors.indigo,
                              child: Icon(Icons.chevron_right),
                              onPressed: () {
                                showPopupFunc(
                                  snapshot.data,
                                );
                              }),
                          Text(
                            "Card Generated",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        "Generating your card please wait ",
                        style: TextStyle(color: Colors.white),
                      );
                    } else {
                      return Column(
                        children: [
                          SpinKitRing(
                            color: Colors.white,
                            size: 30,
                            lineWidth: 5,
                          ),
                          Text(
                            "Generating your card please wait ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      );
                    }
                  }),
              Spacer()
            ],
          ),
        ),
      ],
    );
  }
}