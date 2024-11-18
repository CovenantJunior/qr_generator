import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

    Widget buildText(textEditingController, label) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: textEditingController,
          onChanged: (e) => {
            data = generatedData()
          },
        ),
      );
    }

    Widget inputFields() {
      switch (selectedTyped) {
        case 'contact':
          return Column(
            children: [
              buildText(controllers['name'], 'Name'),
              buildText(controllers['phone'], 'Phone'),
              buildText(controllers['email'], 'Email'),
            ],
          );
        
        case 'url':
          return buildText(controllers['url'], 'URL');
        default: return TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            label: const Text('Input text characters'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)
            )
          ),

          onChanged: (e) {
            setState(() {
              data = e;
            });
          },
        );
      }
    }
    
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Generate QR",
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                  child: Column(
                    children: [
                      SegmentedButton(
                        segments: const [
                          ButtonSegment(
                            value: 'text',
                            label: Text('Text'),
                            icon: Icon(
                              Icons.text_fields_rounded
                            )
                          ),
                          ButtonSegment(
                            value: 'url',
                            label: Text('URL'),
                            icon: Icon(
                              Icons.link_rounded
                            )
                          ),
                          ButtonSegment(
                            value: 'contact',
                            label: Text('Contact'),
                            icon: Icon(
                              Icons.contact_page_rounded
                            )
                          )
                        ],
                        selected: {selectedTyped},
                        onSelectionChanged:(p0) {
                          setState(() {
                            selectedTyped = p0.first;
                            data = '';
                          });
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}