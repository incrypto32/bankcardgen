import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bcard/cache_manager/custom_cache_manager.dart';
import 'package:bcard/cache_manager/firebase_cache_manager.dart';
import 'package:bcard/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum TempelateLoadMethod { assets, extDir, cached, cachedFirebase }

class ImgFromTempelate {
  // Loads an Image from assets and conver it into a darts Image encoding
  static Future<ui.Image> loadImageAsset(String imageAssetPath) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  static Future<ui.Image> loadImageFromCacheOrNetwork(String imageUrl) async {
    final File file = await CustomCacheManager().getSingleFile(imageUrl);
    // final File file = await FirebaseCacheManager().getSingleFile(imageUrl);

    final Uint8List byteArray = await file.readAsBytes();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(byteArray, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  static Future<ui.Image> loadImageFromCacheOrFirebase(String imageUrl) async {
    // final File file = await CustomCacheManager().getSingleFile(imageUrl);
    print('trying to get $imageUrl');
    final File file = await FirebaseCacheManager().getSingleFile(imageUrl);
    print("Got file from cache: " + file.path);
    final Uint8List byteArray = await file.readAsBytes();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(byteArray, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  // Loads an image from external directory
  static Future<ui.Image> loadUiImageFromExteranalDirectory(
      String filename) async {
    Directory appDocDir;
    String path;
    final Completer<ui.Image> completer = Completer();
    try {
      appDocDir = await getApplicationSupportDirectory();
      path = appDocDir.path + '/banktamlets' + '/' + filename;
      print(path);
      final file = File(path);
      final bytes = await file.readAsBytes();
      ui.decodeImageFromList(bytes, (ui.Image img) {
        return completer.complete(img);
      });
    } catch (e) {
      print("An error occured while loading image from external directory");
      print(e);
      return null;
    }
    return completer.future;
  }

  static void printGpay({
    @required Canvas canvas,
    @required Offset offset,
    @required String no,
    bool gPay = false,
    bool phonePe = false,
    @required ui.Image img,
  }) async {
    Paint paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    // Draws a rounded rectangle

    // Paints Phone Number
    TextSpan span = TextSpan(
      style: TextStyle(
        color: Colors.blueGrey,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      text: 'Mob : $no',
    );

    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    canvas.drawRRect(
      RRect.fromRectAndRadius(
          offset & Size(tp.width + 120, 80), Radius.circular(10)),
      paint,
    );

    paint.color = Colors.grey;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          offset.translate(0, 50) & Size(tp.width + 120, 30),
          Radius.circular(10)),
      paint,
    );

    tp.paint(canvas, offset.translate(60, 5));

    if (gPay || phonePe) {
      // Prints Number
      span = TextSpan(
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
        text:
            'Available :  ${gPay ? "Google Pay," : ""} ${phonePe ? " PhonePe" : ""}',
      );
      tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, offset.translate(60, 50));
    }
  }

// Function to paint text
  static double printPara({
    @required Canvas canvas,
    @required bool fromMap,
    Map<String, dynamic> map,
    String text,
    double fontSize = 55,
    @required double widthConstraint,
    @required Offset offset,
  }) {
    String text2 = "";
    String text3 = "";

    //
    if (fromMap && map != null) {
      text = "";
      fontSize = 55;
      map.forEach((key, value) {
        print("$key : $value");
        if (!(key == 'Gpay' ||
            key == "PhonePe" ||
            key == 'Bank' ||
            key == 'Type')) {
          if (!(value.toString().replaceAll(new RegExp(r"\s+"), '') == '' ||
              value == null)) {
            if (key == 'A/c No') {
              text += '\n$key : $value';
            } else if (['Name', 'IFSC', 'IBAN', 'Branch'].contains(key)) {
              text2 += '\n$key : $value';
            } else if (key != 'Phone') {
              text3 += '\n$key : $value';
            } else if (key == 'Phone' &&
                (map['Gpay'] == false || map['Gpay'] == null)) {
              text3 += '\n$key : $value';
            } else if (key != 'Phone') {
              text3 += '\n$key : $value';
            }
          }
        }
      });
    }

    TextSpan span = TextSpan(
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
      children: [
        TextSpan(
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.normal,
          ),
          text: text2,
        ),
        TextSpan(
          style: TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontWeight: FontWeight.normal,
          ),
          text: text3,
        ),
      ],
      text: text,
    );

    TextPainter bankTextPainter = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    bankTextPainter.layout(maxWidth: widthConstraint);
    bankTextPainter.paint(canvas, offset);
    return bankTextPainter.height;
  }

// The core funtion which puts all the drawings together
  static Future<ui.Image> _bankCardWorker(
    Map details, {
    @required double yInitial,
    @required double xInitial,
    @required TempelateLoadMethod tempelateLoadMethod,
  }) async {
    ui.Image img;

    // Load Gpay logo
    final gpayImg = await loadImageAsset('assets/images/gpay.png');

    if (tempelateLoadMethod == TempelateLoadMethod.assets) {
      img = await loadImageAsset(
        'assets/images/banktamlets/' + details['Bank'] + '.png',
      );
    } else if (tempelateLoadMethod == TempelateLoadMethod.extDir) {
      img = await loadUiImageFromExteranalDirectory(
        details['Bank'] + '.png',
      );
    } else if (tempelateLoadMethod == TempelateLoadMethod.cached) {
      img = await loadImageFromCacheOrNetwork(
        backendImagesEndPoint + '/' + details['Bank'] + '.png',
      );
    } else if (tempelateLoadMethod == TempelateLoadMethod.cachedFirebase) {
      img = await loadImageFromCacheOrFirebase(
        details['Bank'] + '.png',
      );
    }

    // The picture recorder which records the canvas
    final ui.PictureRecorder recorder = ui.PictureRecorder();

    // The actual canvas
    final Canvas canvas = Canvas(
      recorder,
      Rect.fromPoints(
        Offset(0.0, 0.0),
        Offset(30.0, 600.0),
      ),
    );
    final stroke = Paint();

    // Draw the tamlet to canvas
    img == null
        ? throw ('Tempelate image is null')
        : canvas.drawImage(img, Offset(0, 0), stroke);

    // Start printig text on to canvas
    if (details != null) {
      var pH = printPara(
        canvas: canvas,
        offset: Offset(
          xInitial,
          yInitial,
        ),
        fromMap: true,
        widthConstraint: 830,
        map: details,
      );
      print('PrintPara complete');

      // Printing the Gpay number box
      stroke.color = Colors.white;
      stroke.style = PaintingStyle.fill;
      if ((details['Gpay'] || details['PhonePe']) &&
          (details['Phone'] != null && details['Phone'] != "")) {
        printGpay(
          canvas: canvas,
          no: details['Phone'],
          offset: Offset(xInitial, yInitial + pH + 20),
          gPay: details['Gpay'] ?? false,
          phonePe: details['PhonePe'] ?? false,
          img: gpayImg,
        );
      }

      printPara(
        canvas: canvas,
        fromMap: false,
        widthConstraint: 400,
        offset: Offset(xInitial, 60),
        fontSize: 35,
        text: details['Type'] ?? '',
      );
    } else {
      throw ("Error : details map is null");
    }
    final picture = recorder.endRecording();
    final finalimg = await picture.toImage(930, 600);
    return finalimg;
  }

// The core function which genrates the compressed PNG Image
  static Future<ByteData> _pngBytes(ui.Image img) async {
    var pngBytes;

    try {
      pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

      if (await Permission.storage.request().isGranted) {}
    } catch (err) {
      print(err);
      return null;
    }

    return pngBytes;
  }

  // generate BankCard
  static Future<ByteData> generateBankCard(Map<String, dynamic> details) async {
    var img;
    if (details != null) {
      img = await _bankCardWorker(
        details,
        yInitial: 80,
        xInitial: 80,
        tempelateLoadMethod: TempelateLoadMethod.cachedFirebase,
      );
    }
    return _pngBytes(img);
  }
}
