import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

  // Loads an image from external directory
  static Future<ui.Image> loadUiImageFromExteranalDirectory(
      String filename) async {
    Directory appDocDir = await getApplicationSupportDirectory();
    String path = appDocDir.path + '/banktamlets' + '/' + filename;
    print(path);
    final file = File(path);
    final bytes = await file.readAsBytes();

    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      return completer.complete(img);
    });
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
      rect: Rect.fromLTRB(100, offset.dy + 10, 150, offset.dy + 70),
      image: img,
    );

    // Prints Number
    TextSpan span = TextSpan(
        style: TextStyle(
            color: Colors.blueGrey, fontSize: 35, fontWeight: FontWeight.bold),
        text: 'Pay : 7034320115');
    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, offset.translate(100, 20));
    // canvas.drawParagraph(paragraph, offset.translate(90, 10));
  }

// Function to paint text
  static double printPara(
      {@required Canvas canvas,
      bool fromMap,
      Map<String, String> map,
      String text,
      @required double widthConstraint,
      @required Offset offset}) {
    String text2 = "";
    String text3 = "";
    if (fromMap) {
      text = "";

      map.forEach((key, value) {
        // print(text);
        if (key != 'Gpay' && key != 'bank') {
          if (key =='Ac No') {
            text += '\n$key : $value';
          } else if(['Name','IFSC','Branch'].contains(key)){
            text2 += '\n$key : $value';
          }else{
            text3+= '\n$key : $value';

          }
        }
      });
    }
    print(text);
    TextSpan span = TextSpan(
      style: TextStyle(
        color: Colors.white,
        fontSize: 45,
        fontWeight: FontWeight.bold,
      ),
      children: [
        TextSpan(
            style: TextStyle(color: Colors.white, fontSize: 46,fontWeight: FontWeight.normal), text: text2,),
 TextSpan(
            style: TextStyle(color: Colors.white, fontSize: 46,fontWeight: FontWeight.normal), text: 
            text3,),

      ],
      text: text,
    );
    TextPainter bankTextPainter = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    bankTextPainter.layout(maxWidth: widthConstraint);
    // TextPainter detailsPrinter = TextPainter(
    //   text: TextSpan(
    //     style: TextStyle(color: Colors.white, fontSize: 35),

    //   ),
    // );
    bankTextPainter.paint(canvas, offset);
    return bankTextPainter.height;
  }

// The core funtion which puts all the drawings together
  static Future<ui.Image> _bankCardWorker(details,
      {bool fromAsset = false,@required double yInitial}) async {
    final gpayImg = await loadImageAsset('assets/images/gpay.png');
    ui.Image imge;
    fromAsset
        ? imge = await loadImageAsset(
            'assets/images/banktamlets/' + details['bank'] + '.png')
        : imge =
            await loadUiImageFromExteranalDirectory(details['bank'] + '.png');

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(
        recorder, Rect.fromPoints(Offset(0.0, 0.0), Offset(30.0, 600.0)));
    final stroke = Paint();

    canvas.drawImage(imge, Offset(0, 0), stroke);
    var pH = printPara(
        canvas: canvas,
        offset: Offset(
          75,
          yInitial,
        ),
        fromMap: true,
        widthConstraint: 830,
        map: details);

    stroke.color = Colors.white;
    stroke.style = PaintingStyle.fill;
    if( details['Gpay'] != null ){
  
    printGpay(
      canvas: canvas,
      no: details['Gpay'],
      offset: Offset(75, yInitial + pH + 20),
      img: gpayImg,
    );
 }
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
      img = await _bankCardWorker(
        details,
        yInitial: 100,
      );
    } catch (e) {
      print('generateBankCard : Error Occured');
      throw Future.error(e);
    }
    return pngBytes(img);
  }
}
