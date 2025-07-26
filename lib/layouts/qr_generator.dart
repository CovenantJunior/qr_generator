import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_generator/ads/rewarded.dart';
import 'package:qr_generator/controllers/option_controller.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QRGenerator extends StatefulWidget {
  List<Color>? colors;
  Color? textColor;

  QRGenerator({super.key, required this.colors, required this.textColor});

  @override
  State<QRGenerator> createState() => _QRGeneratorState();
}

String data = "";
String selectedTyped = "text";
TextEditingController? textEditingController;
ScreenshotController screenshotController = ScreenshotController();
final Map<String, TextEditingController> controllers = {
  "name": TextEditingController(),
  "phone": TextEditingController(),
  "email": TextEditingController(),
  "url": TextEditingController()
};

class _QRGeneratorState extends State<QRGenerator> {

  late RewardedAds _rewardedAdService;

  @override
  void initState() {
    super.initState();
    _rewardedAdService = RewardedAds();
    _rewardedAdService.loadRewardedAd();
  }

  String generatedData() {
    switch (selectedTyped) {
      case 'contact':
        return """BEGIN:VCARD
          VERSION:3.0
          FN:${controllers['name']?.text}
          TEL:${controllers['phone']?.text}
          EMAIL:${controllers['email']?.text}
          END:VCARD""";
      case 'url':
        String url = controllers['url']!.text;
        if (!url.startsWith('http://') && !url.startsWith('https://')) {
          url = "https://$url";
        }
        return url;
      default:
        return textEditingController!.text;
    }
  }

  String generateRandomText() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    return List.generate(10, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Widget buildFormatButton({
    required String format,
    required String label,
    required bool isPremium,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () async {
        if (isPremium) {
          bool shown = await _rewardedAdService.showRewardedAd(context);
          if (shown) {
            shareQR(format);
          }
        } else {
          shareQR(format);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isPremium
                ? [widget.colors![1], widget.colors![0]]
                : [Colors.grey.shade300, Colors.grey.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 40,
                    color: isPremium ? Colors.white : widget.textColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isPremium ? Colors.white : widget.textColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isPremium)
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.lock,
                  color: Colors.yellowAccent,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showFormatSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Select Image Format",
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            color: widget.textColor,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding: const EdgeInsets.all(10),
            children: [
              // JPG (Free)
              buildFormatButton(
                format: 'jpg',
                label: 'JPG',
                isPremium: false,
                icon: Icons.image,
              ),
              // PNG (Premium)
              buildFormatButton(
                format: 'png',
                label: 'PNG',
                isPremium: true,
                icon: Icons.image_outlined,
              ),
              // SVG (Premium)
              buildFormatButton(
                format: 'svg',
                label: 'SVG',
                isPremium: true,
                icon: Icons.polyline,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: GoogleFonts.quicksand(color: widget.textColor),
            ),
          ),
        ],
      ),
    );
  }

  void shareQR(String format) async {
    String filename = generateRandomText();
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = "${directory.path}/$filename.$format";
    final capture = await screenshotController.capture();

    File imageFile = File(imagePath);
    await imageFile.writeAsBytes(capture as List<int>);
    await Share.shareXFiles([XFile(imagePath)], text: "QR Code");
  }

  Widget buildText(TextEditingController? controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          label: Text(label),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (e) => setState(() {
          data = generatedData();
        }),
      ),
    );
  }

  Widget inputFields(String selectedTyped) {
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
      default:
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              label: const Text('Input text characters'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (e) {
              setState(() {
                data = e;
              });
            },
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.colors![0],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: widget.colors![0],
        foregroundColor: widget.textColor,
        centerTitle: true,
        title: Text(
          "Generate QR Code",
          style: GoogleFonts.quicksand(
            color: widget.textColor,
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5.0),
                    child: Column(
                      children: [
                        SegmentedButton<String>(
                          segments: [
                            ButtonSegment(
                              enabled: true,
                              value: 'text',
                              label: const Text('Text'),
                              icon: Icon(
                                Icons.text_fields_rounded,
                                color: widget.colors![1],
                              ),
                            ),
                            ButtonSegment(
                              value: 'url',
                              label: const Text('URL'),
                              icon: Icon(
                                Icons.link_rounded,
                                color: widget.colors![1],
                              ),
                            ),
                            ButtonSegment(
                              value: 'contact',
                              label: const Text('Contact'),
                              icon: Icon(
                                Icons.contact_page_rounded,
                                color: widget.colors![1],
                              ),
                            ),
                          ],
                          selected: {selectedTyped},
                          onSelectionChanged: (Set<String> selected) {
                            setState(() {
                              selectedTyped = selected.first;
                              data = '';
                            });
                          },
                        ),
                        inputFields(selectedTyped),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              if (data.isNotEmpty)
                Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Screenshot(
                              controller: screenshotController,
                              child: QrImageView(
                                data: data,
                                backgroundColor: context
                                        .read<OptionController>()
                                        .options
                                        .first
                                        .qrTransparent!
                                    ? Colors.transparent
                                    : Colors.white,
                                version: QrVersions.auto,
                                size: context
                                    .read<OptionController>()
                                    .options
                                    .first
                                    .qrSize!
                                    .toDouble(),
                                errorCorrectionLevel: QrErrorCorrectLevel.H,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 15),
              if (data.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: showFormatSelectionDialog,
                  label: const Text('Share Code'),
                  icon: Icon(
                    Icons.share,
                    color: widget.colors![1],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
