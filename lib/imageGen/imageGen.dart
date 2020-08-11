import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class ImgFromTempelate {
  // Loads an Image from assets and conver it into a darts Image encoding
  static Future<ui.Image> loadUiImage(String imageAssetPath) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  // Prints a paragraph onto the canvas
  static ui.Paragraph createParagraph(
      {String text, bool fromMap, Map<String, String> map}) {
    print(map);
    final textStyle = ui.TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 38,
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
      {Canvas canvas,
      String text,
      double widthConstraint,
      Offset offset,
      bool fromMap,
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

  static void printGpay(
      {Canvas canvas, Offset offset, String no, ui.Image img}) async {
    Paint paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    // final paragraph = createParagraph(fromMap: false,text: 'Pay : 7034320115');

    // Draws a rounded rectangle
    print("hello");
    print(canvas);
    canvas.drawRRect(
      RRect.fromRectAndRadius(offset & Size(700, 100), Radius.circular(20)),
      paint,
    );
    // Offset(75, 150 + pH + 20)

    // Draws the Gpay logo
    paintImage(
      canvas: canvas,
      scale: 1,
      fit: BoxFit.cover,
      rect: Rect.fromCenter(
        center: Offset(130, offset.dy + 50),
        height: 80,
        width: 80,
      ),
      image: img,
    );

    // Prints Number

  }

// The core funtion which puts all the drawings together
  static Future<ui.Image> _bankCardWorker(details) async {
    final gpayImg = await loadUiImage('assets/images/gpay.png');
    final imge = await loadUiImage('assets/images/axis.png');
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(
        recorder, Rect.fromPoints(Offset(0.0, 0.0), Offset(30.0, 600.0)));
    final stroke = Paint();

    canvas.drawImage(imge, Offset(0, 0), stroke);
    var pH = printParagraph(
        canvas: canvas,
        offset: Offset(
          75,
          150,
        ),
        fromMap: true,
        widthConstraint: 830,
        map: details);

    stroke.color = Colors.white;
    stroke.style = PaintingStyle.fill;
    printGpay(
        canvas: canvas,
        no: details['Gpay'],
        offset: Offset(75, 150 + pH + 20),
        img: gpayImg);
    // canvas.drawRRect(
    //     RRect.fromRectAndRadius(
    //         Offset(75, 150 + pH + 20) & Size(700, 100), Radius.circular(20)),
    //     stroke);

    final picture = recorder.endRecording();
    final img = await picture.toImage(930, 600);
    return img;
  }

// The core function which genrates the compressed PNG Image
  static Future<ByteData> pngBytes(ui.Image img) async {
    var pngBytes;
    var buffer;
    try {
      pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
      buffer = pngBytes.buffer;
      if (await Permission.storage.request().isGranted) {
        var directory = await ExtStorage.getExternalStorageDirectory();
        await File(directory +
                '/' +
                ExtStorage.DIRECTORY_DOWNLOADS +
                '/cardeyyy.png')
            .writeAsBytes(buffer.asUint8List());
      }
    } catch (err) {
      print('pngBytes : An error occured');
      print(err);
    }

    return pngBytes;
  }

  // generate BankCard
  static Future<ByteData> generateBankCard(Map<String, String> details) async {
    var img;
    try {
      img = await _bankCardWorker(details);
    } catch (e) {
      print('generateBankCard : Error Occured');
      throw Future.error(e);
    }
    return pngBytes(img);
  }
}
