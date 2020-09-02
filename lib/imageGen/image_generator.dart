import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bankcardmaker/cache_manager/custom_cache_manager.dart';
import 'package:bankcardmaker/cache_manager/firebase_cache_manager.dart';
import 'package:bankcardmaker/constants/constants.dart';
import 'package:ext_storage/ext_storage.dart';
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
    print("Got file from cache: " + file.path);
    final Uint8List byteArray = await file.readAsBytes();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(byteArray, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  static Future<ui.Image> loadImageFromCacheOrFirebase(String imageUrl) async {
    // final File file = await CustomCacheManager().getSingleFile(imageUrl);
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

  // Prints a paragraph onto the canvas
  static ui.Paragraph createParagraph(
      {String text,
      bool fromMap = false,
      Map<String, String> map,
      Color color = Colors.white,
      double fontSize = 35}) {
    final textStyle = ui.TextStyle(
      color: color,
      fontSize: fontSize,
    );
    final paragraphStyle = ui.ParagraphStyle(
      textDirection: TextDirection.ltr,
    );
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle);
    try {
      if (fromMap) {
        map.forEach((key, value) {
          paragraphBuilder.addText('\n$key : $value');
        });
      } else {
        paragraphBuilder.addText(text);
      }
    } catch (e) {
      print('Cannot addText');
    }

    final paragraph = paragraphBuilder.build();

    print(paragraph.height);
    // final offset = Offset(75, 150);
    return paragraph;
  }

  static double printParagraph(
      {@required Canvas canvas,
      String text,
      @required double widthConstraint,
      @required Offset offset,
      bool fromMap = false,
      Map<String, String> map}) {
    ui.Paragraph paragraph;
    try {
      print(map);

      paragraph = createParagraph(fromMap: fromMap, text: text, map: map);
    } catch (e) {
      print('Error in printParagraph');
    }

    paragraph.layout(ui.ParagraphConstraints(width: widthConstraint));
    canvas.drawParagraph(paragraph, offset);

    return paragraph.height;
  }

  static void printGpay({
    @required Canvas canvas,
    @required Offset offset,
    @required String no,
    @required ui.Image img,
  }) async {
    Paint paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    try {
      //  paragraph= createParagraph(fromMap: false,text: 'Pay : 7034320115',color: Colors.black);
      //  paragraph.layout(ui.ParagraphConstraints(width: 830));

    } catch (e) {
      print(e);
    }

    // Draws a rounded rectangle
    print("hello");
    print(canvas);
    canvas.drawRRect(
      RRect.fromRectAndRadius(offset & Size(450, 80), Radius.circular(10)),
      paint,
    );
    // Offset(75, 150 + pH + 20)

    // Draws the Gpay logo
    paintImage(
      canvas: canvas,
      scale: 1,
      fit: BoxFit.contain,
      // rect: Rect.fromCenter(
      //   center: Offset(130, offset.dy + 10),
      //   height: 60,
      //   width: 60,
      // ),
      rect: Rect.fromLTRB(
        offset.dx + 20,
        offset.dy + 15,
        offset.dx + 20 + 50,
        offset.dy + 65,
      ),
      image: img,
    );

    // Prints Number
    TextSpan span = TextSpan(
        style: TextStyle(
            color: Colors.blueGrey, fontSize: 35, fontWeight: FontWeight.bold),
        text: 'Pay : $no');
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, offset.translate(80, 20));
    // canvas.drawParagraph(paragraph, offset.translate(90, 10));
  }

// Function to paint text
  static double printPara({
    @required Canvas canvas,
    @required bool fromMap,
    Map<String, dynamic> map,
    String text,
    @required double widthConstraint,
    @required Offset offset,
  }) {
    double fontSize = 55;
    String text2 = "";
    String text3 = "";

    //
    if (fromMap && map != null) {
      text = "";
      fontSize = 55;
      map.forEach((key, value) {
        print("$key : $value");
        if (!(key == 'Gpay' || key == 'Bank' || key == 'Type')) {
          if (!(value.toString().replaceAll(new RegExp(r"\s+"), '') == '' ||
              value == null)) {
            if (key == 'Ac/No') {
              print("Printed  $key : $value");
              text += '\n$key : $value';
            } else if (['Name', 'IFSC', 'IBAN', 'Branch'].contains(key)) {
              print("Printed  $key : $value");
              text2 += '\n$key : $value';
            } else if (key != 'Phone') {
              print("Printed  $key : $value");
              text3 += '\n$key : $value';
            } else if (key == 'Phone' &&
                (map['Gpay'] == false || map['Gpay'] == null)) {
              print("Printed $key : $value");
              text3 += '\n$key : $value';
            } else if (key != 'Phone') {
              print("Printed  $key : $value");
              text3 += '\n$key : $value';
            }
          }
        }
      });
    } else {
      print("reached here");
      fontSize = 40;
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
    details, {
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
      if (details['Gpay'] == true && details['Phone'] != null) {
        printGpay(
          canvas: canvas,
          no: details['Phone'],
          offset: Offset(xInitial, yInitial + pH + 20),
          img: gpayImg,
        );
      }

      printPara(
        canvas: canvas,
        fromMap: false,
        widthConstraint: 400,
        offset: Offset(40, 40),
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
    var buffer;

    try {
      pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
      buffer = pngBytes.buffer;
      if (await Permission.storage.request().isGranted) {
        var directory = await ExtStorage.getExternalStorageDirectory();
        File(directory +
                '/' +
                ExtStorage.DIRECTORY_DOWNLOADS +
                '/blah/cardeyyy.png')
            .create(recursive: true)
            .then((value) {
          value.writeAsBytes(buffer.asUint8List());
        });
      }
    } catch (err) {
      print('pngBytes : An error occured');
      print(err);
      return null;
    }

    return pngBytes;
  }

  // generate BankCard
  static Future<ByteData> generateBankCard(Map<String, dynamic> details) async {
    var img;
    if (details != null) {
      print(details);
      img = await _bankCardWorker(
        details,
        yInitial: 100,
        xInitial: 100,
        tempelateLoadMethod: TempelateLoadMethod.cachedFirebase,
      );
    }
    return _pngBytes(img);
  }
}
