import 'dart:io';
import 'dart:typed_data';

import 'package:bankcardmaker/imageGen/image_generator.dart';
import 'package:bankcardmaker/models/card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateButton extends StatefulWidget {
  const CreateButton({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required CardItem cardItem,
  })  : _formKey = formKey,
        _cardItem = cardItem,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final CardItem _cardItem;

  @override
  _CreateButtonState createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> {
  void _showDialog(context, ByteData imgBytes) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
            title: Container(
              child: Text(
                "Your Card is Successfully Generated !",
                style: TextStyle(color: Colors.green, fontSize: 15),
              ),
            ),
            content: Image.memory(imgBytes.buffer.asUint8List()),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  FocusScope.of(ctx).unfocus();
                },
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
                onPressed: () async {
                  if (await Permission.storage.request().isGranted) {
                    var prefs = await SharedPreferences.getInstance();
                    var directory = await getApplicationDocumentsDirectory();
                    var fileName = DateTime.now().toIso8601String() + '.png';
                    var filePath =
                        directory.path + '/saved_cards' + '/' + fileName;
                    print(filePath);
                    prefs.setString(fileName, widget._cardItem.toString());
                    File(filePath).create(recursive: true).then((value) {
                      value.writeAsBytes(imgBytes.buffer.asUint8List());
                    });
                    Navigator.of(ctx).pop();
                    FocusScope.of(ctx).unfocus();
                    widget._formKey.currentState.reset();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Saved Succefully'),
                      ),
                    );
                  }
                },
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

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width * 0.4,
      child: RaisedButton(
        elevation: 10.0,
        onPressed: () async {
          if (!_loading) {
            var imgBytes;
            widget._formKey.currentState.save();

            try {
              _startLoading();

              print(widget._cardItem.toMap);
              imgBytes = await ImgFromTempelate.generateBankCard(
                  widget._cardItem.toMap);

              _showDialog(context, imgBytes);
              _stopLoading();
            } catch (e) {
              _stopLoading();
              String msg;
              e.runtimeType == SocketException
                  ? msg = "Check your network connection"
                  : msg = 'Image generation failed. Please fill all the fields';
              Scaffold.of(context).showSnackBar(
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
          }

          // imgBytes == null
          //     ? Scaffold.of(context).showSnackBar(
          //         SnackBar(
          //           content: Container(
          //             height: 20,
          //             alignment: Alignment.center,
          //             child: FittedBox(
          //               child: Text(
          //                 'Image generation failed. Please fill all the fields',
          //                 style: TextStyle(color: Colors.red),
          //               ),
          //             ),
          //           ),
          //           backgroundColor: Colors.white,
          //         ),
          //       )
          //     : _showDialog(context, imgBytes);
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blue[900],
        child: _loading
            ? SpinKitThreeBounce(
                color: Colors.white,
                size: 20,
              )
            : Text(
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
}
