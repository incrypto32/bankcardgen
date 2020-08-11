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
    Future<ui.Image> img = decodeImageFromList(Uint8List.view(data.buffer));
    return img;
  }

  // Prints a paragraph onto the canvas
  static printParagraph({Canvas canvas,Offset offset,String text, bool fromMap,Map<String,String> map}) {
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
      if(fromMap){
        map.forEach((key, value) {
          paragraphBuilder.addText('\n$key : $value');
        });
      }else{
        paragraphBuilder.addText(text);
      }
    

    final constraints = ui.ParagraphConstraints(width: 830);
    final paragraph = paragraphBuilder.build();
    paragraph.layout(constraints);
    // final offset = Offset(75, 150);
    
    canvas.drawParagraph(paragraph, offset);
    return paragraph.height;
  }

// The core funtion which puts all the drawings together
  static Future<ui.Image> _bankCardWorker(details) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(
        recorder, Rect.fromPoints(Offset(0.0, 0.0), Offset(30.0, 600.0)));
    final stroke = Paint();
    try {
      var imge = await loadUiImage('assets/images/axis.png');

      canvas.drawImage(imge, Offset(0, 0), stroke);
    } catch (e) {
      print(e);
    }
    var pH = printParagraph(canvas:canvas, offset:Offset(75, 150,),fromMap: true,map:details);
    stroke.color = Colors.white;
    stroke.style = PaintingStyle.fill;

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Offset(75, 150 + pH + 20) & Size(700, 100), Radius.circular(20)),
        stroke);

    final picture = recorder.endRecording();
    final img = await picture.toImage(930, 600);
    return img;
  }

// The core function which genrates the compressed PNG Image
  static Future<ByteData> pngBytes(ui.Image img) async {
  
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = pngBytes.buffer;
    try {
      if (await Permission.storage.request().isGranted) {
        var directory = await ExtStorage.getExternalStorageDirectory();
        await File(directory +
                '/' +
                ExtStorage.DIRECTORY_DOWNLOADS +
                '/cardeyyy.png')
            .writeAsBytes(buffer.asUint8List());
      }
    } catch (err) {
      print(err);
    }

    return pngBytes;
    
  }

  // generate BankCard
  static Future<ByteData> generateBankCard(Map<String,String> details) async{
    final img = await _bankCardWorker(details);
    return pngBytes(img);
  }
}
