import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QRGenerator extends StatefulWidget {
  const QRGenerator({super.key});

  @override
  State<QRGenerator> createState() => _QRGeneratorState();
}

class _QRGeneratorState extends State<QRGenerator> {
  @override
  Widget build(BuildContext context) {
    TextEditingController? textEditingController;
    ScreenshotController? screenshotController;
    String data = "";
    String selectedTyped = "Text";
    final Map<String, TextEditingController> controllers = {
      "name" : TextEditingController(),
      "phone": TextEditingController(),
      "email" : TextEditingController(),
      "url" : TextEditingController()
    };

    String generatedData() {
      switch (selectedTyped) {
        case 'contact':
          return """BEGIN:VCARD
            VERSION:3.0
            FN" : ${controllers['name']?.text},
            TEL": ${controllers['phone']?.text},
            EMAIL" : ${controllers['email']?.text},
            END:VCARD
          """;

          case 'url':
          String url = controllers['url']!.text;
          if(!url.startsWith('http://') && !url.startsWith('https://')) {
            url = "https://$url";
          }
          return url;
          
        default:
        return textEditingController!.text;
      }
    }


    void shareQR() async {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = "${directory.path}/qr.png";
      final capture = screenshotController!.capture();

      File imageFile = File(imagePath);
      await imageFile.writeAsBytes(capture as List<int>);
      await Share.shareXFiles([XFile(imagePath)], text: "QR Code");
    }

    Widget buildText(context, label) {
      return const Text('data');
    }
    
    return Scaffold(
      appBar: AppBar(),
    );
  }
}