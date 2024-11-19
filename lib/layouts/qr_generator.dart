import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QRGenerator extends StatefulWidget {
  const QRGenerator({super.key});

  @override
  State<QRGenerator> createState() => _QRGeneratorState();
}

String data = "";
String selectedTyped = "text";
TextEditingController? textEditingController;
ScreenshotController screenshotController = ScreenshotController();
final Map<String, TextEditingController> controllers = {
  "name" : TextEditingController(),
  "phone": TextEditingController(),
  "email" : TextEditingController(),
  "url" : TextEditingController()
};
class _QRGeneratorState extends State<QRGenerator> {
  @override
  Widget build(BuildContext context) {

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
            print(e),
            setState(() {
              data = generatedData();
            })
          },
        ),
      );
    }

    Widget inputFields(selectedTyped) {
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
        default: return Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              label: const Text('Input text characters'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              )
            ),
          
            onChanged: (e) {
              print(e);
              setState(() {
                data = e;
              });
            },
          ),
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
          "Generate QR Code",
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                    child: Column(
                      children: [
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              enabled: true,
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
                            ),
                          ],
                          selected: {selectedTyped},
                          onSelectionChanged:(Set<String> selected) {
                            setState(() {
                              selectedTyped = selected.first;
                              data = '';
                            });
                            print(selectedTyped);
                          },
                        ),
                        inputFields(selectedTyped),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (data.isNotEmpty)
              Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          child: Screenshot(
                            controller: screenshotController!,
                            child: QrImageView(
                              data: data,
                              version: QrVersions.auto,
                              size: 250,
                              errorCorrectionLevel: QrErrorCorrectLevel.H,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}