import 'dart:typed_data';

import 'package:bcard/models/ad.dart';
import 'package:bcard/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

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
          future: DatabaseService.adGetter(bank),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      if (await canLaunch(snapshot.data.link)) {
                        await launch(snapshot.data.link);
                      }
                    },
                    child: Image.network(
                      snapshot.data.assetUrl ?? "",
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
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: Colors.green,
                              child: Text("View Your Card"),
                              onPressed: () {
                                showPopupFunc(
                                  snapshot.data,
                                );
                              }),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text(
                        "An error Occured Please try again ",
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
