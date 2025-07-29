import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_generator/ads/interstitial.dart';
import 'package:qr_generator/ads/rewarded.dart';
import 'package:qr_generator/controllers/option_controller.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image/image.dart' as img;

class QRGenerator extends StatefulWidget {
  final List<Color>? colors;
  final Color? textColor;

  const QRGenerator({
    super.key,
    required this.colors,
    required this.textColor,
  });

  @override
  State<QRGenerator> createState() => _QRGeneratorState();
}

String data = "";
String selectedTyped = "";
TextEditingController? textEditingController;
ScreenshotController screenshotController = ScreenshotController();
final Map<String, TextEditingController> controllers = {
  "name": TextEditingController(),
  "phone": TextEditingController(),
  "email": TextEditingController(),
  "url": TextEditingController(),
  "wifi_ssid": TextEditingController(),
  "wifi_password": TextEditingController(),
  "email_subject": TextEditingController(),
  "email_body": TextEditingController(),
  "sms_phone": TextEditingController(),
  "sms_message": TextEditingController(),
  "phone_call": TextEditingController(),
  "geo_latitude": TextEditingController(),
  "geo_longitude": TextEditingController(),
  "event_title": TextEditingController(),
  "event_description": TextEditingController(),
  "event_start": TextEditingController(),
  "event_end": TextEditingController(),
};

class _QRGeneratorState extends State<QRGenerator> {
  late RewardedAds _rewardedAdService;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
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
      case 'wifi':
        String ssid = controllers['wifi_ssid']!.text;
        String password = controllers['wifi_password']!.text;
        return "WIFI:S:$ssid;P:$password;T:WPA;;";
      case 'email':
        String email = controllers['email']!.text;
        String subject = controllers['email_subject']!.text;
        String body = controllers['email_body']!.text;
        return "mailto:$email?subject=$subject&body=$body";
      case 'sms':
        String phone = controllers['sms_phone']!.text;
        String message = controllers['sms_message']!.text;
        return "SMSTO:$phone:$message";
      case 'phone_call':
        return "tel:${controllers['phone_call']!.text}";
      case 'geo':
        String latitude = controllers['geo_latitude']!.text;
        String longitude = controllers['geo_longitude']!.text;
        return "geo:$latitude,$longitude";
      case 'event':
        String title = controllers['event_title']!.text;
        String description = controllers['event_description']!.text;
        String start = controllers['event_start']!.text.replaceAll(RegExp(r'[^0-9]'), '');
        String end = controllers['event_end']!.text.replaceAll(RegExp(r'[^0-9]'), '');
        return """BEGIN:VCALENDAR
  VERSION:2.0
  BEGIN:VEVENT
  SUMMARY:$title
  DESCRIPTION:$description
  DTSTART:$start
  DTEND:$end
  END:VEVENT
  END:VCALENDAR""";
      default:
        return textEditingController?.text ?? '';
    }
  }

  String generateRandomText() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(10, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> requestPermissions() async {

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    if (statuses.containsValue(PermissionStatus.denied)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Storage permission is required to download images.',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
  }

  Widget buildFormatButton({
    required String format,
    required String label,
    required bool isPremium,
    required IconData icon,
    required String action
  }) {
    return GestureDetector(
      onTap: () async {
        if (isPremium) {
          bool shown = await _rewardedAdService.showRewardedAd(context);
          if (shown) {
            if (action == 'share') {
              shareQR(format);
            } else if (action == 'save') {
              saveQR(format);
            }
          }
        } else {
          await InterstitialAds().loadInterstitialAd(context);
          if (action == 'share') {
            shareQR(format);
          } else if (action == 'save') {
            saveQR(format);
          }
        }
      },
      child: SizedBox(
        height: 100,
        width: 100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
                      size: 30,
                      color: Colors.black
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    ),
                  ],
                ),
              ),
              if (isPremium)
                const Positioned(
                  top: 8,
                  right: 3,
                  child: Icon(
                    Icons.movie_filter_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTypeButton({
    required String type,
    required String label,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTyped = type;
          data = '';
          controllers.forEach((_, controller) => controller.clear());
          textEditingController?.clear();
        });
      },
      child: SizedBox(
        height: 100,
        width: 100,
        child: Container(
          decoration: BoxDecoration(
            color: selectedTyped == type ? Colors.grey[200] : widget.textColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: widget.colors![1],
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: widget.colors![0],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSaveFormatSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Save in Image Format",
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            color: widget.colors![1],
          ),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              // JPG (Free)
              buildFormatButton(
                format: 'jpg',
                label: 'JPG',
                isPremium: false,
                icon: Icons.image,
                action: 'save'
              ),
              // PNG (Premium)
              buildFormatButton(
                format: 'png',
                label: 'PNG',
                isPremium: true,
                icon: Icons.image_outlined,
                action: 'save'
              ),
              // SVG (Premium)
              buildFormatButton(
                format: 'svg',
                label: 'SVG',
                isPremium: true,
                icon: Icons.polyline,
                action: 'save'
              ),
              // WEBP (Premium)
              buildFormatButton(
                format: 'webp',
                label: 'WEBP',
                isPremium: true,
                icon: Icons.image_aspect_ratio,
                action: 'save'
              ),
              // GIF (Premium)
              buildFormatButton(
                format: 'gif',
                label: 'GIF',
                isPremium: true,
                icon: Icons.gif,
                action: 'save'
              ),
              // TIFF (Premium)
              buildFormatButton(
                format: 'tiff',
                label: 'TIFF',
                isPremium: true,
                icon: Icons.image_search,
                action: 'save'
              ),
              // EPS (Premium)
              buildFormatButton(
                format: 'eps',
                label: 'EPS',
                isPremium: true,
                icon: Icons.layers_rounded,
                action: 'save'
              ),
              // HEIF (Premium)
              buildFormatButton(
                format: 'heif',
                label: 'HEIF',
                isPremium: true,
                icon: Icons.image_rounded,
                action: 'save'
              ),
              // AVIF (Premium)
              buildFormatButton(
                format: 'avif',
                label: 'AVIF',
                isPremium: true,
                icon: Icons.compass_calibration,
                action: 'save'
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void showShareFormatSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Share in Image Format",
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            color: widget.colors![1],
          ),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children: [
              // JPG (Free)
              buildFormatButton(
                format: 'jpg',
                label: 'JPG',
                isPremium: false,
                icon: Icons.image,
                action: 'share'
              ),
              // PNG (Premium)
              buildFormatButton(
                format: 'png',
                label: 'PNG',
                isPremium: true,
                icon: Icons.image_outlined,
                action: 'share'
              ),
              // SVG (Premium)
              buildFormatButton(
                format: 'svg',
                label: 'SVG',
                isPremium: true,
                icon: Icons.polyline,
                action: 'share'
              ),
              // WEBP (Premium)
              buildFormatButton(
                format: 'webp',
                label: 'WEBP',
                isPremium: true,
                icon: Icons.image_aspect_ratio,
                action: 'share'
              ),
              // GIF (Premium)
              buildFormatButton(
                format: 'gif',
                label: 'GIF',
                isPremium: true,
                icon: Icons.gif,
                action: 'share'
              ),
              // TIFF (Premium)
              buildFormatButton(
                format: 'tiff',
                label: 'TIFF',
                isPremium: true,
                icon: Icons.image_search,
                action: 'share'
              ),
              // EPS (Premium)
              buildFormatButton(
                format: 'eps',
                label: 'EPS',
                isPremium: true,
                icon: Icons.layers_rounded,
                action: 'share'
              ),
              // HEIF (Premium)
              buildFormatButton(
                format: 'heif',
                label: 'HEIF',
                isPremium: true,
                icon: Icons.image_rounded,
                action: 'share'
              ),
              // AVIF (Premium)
              buildFormatButton(
                format: 'avif',
                label: 'AVIF',
                isPremium: true,
                icon: Icons.compass_calibration,
                action: 'share'
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveQR(String format) async {
    try {
      // Request storage permissions
      await requestPermissions();

      // Capture QR code image
      final capture = await screenshotController.capture();
      if (capture == null) {
        throw Exception('Failed to capture QR code image');
      }

      // Get downloads directory
      final directory = await getDownloadsDirectory();
      if (directory == null) {
        throw Exception('Unable to access downloads directory');
      }

      // Create Perzsi directory
      final dir = Directory('${directory.path}/QR Code Generator');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Generate a random filename
      String filename = generateRandomText();
      final filePath = '${dir.path}/$filename.$format';
      File file = File(filePath);

      // Save the image based on format
      if (format == 'png') {
        await file.writeAsBytes(capture);
      } else if (format == 'jpg') {
        // Convert to JPG using the image package
        final image = img.decodeImage(capture);
        if (image == null) {
          throw Exception('Failed to decode captured image');
        }
        final jpgBytes = img.encodeJpg(image, quality: 80);
        await file.writeAsBytes(jpgBytes);
      } else {
        // Placeholder for unsupported formats (SVG, EPS, etc.)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Format $format is not supported yet.',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'QR code saved successfully as "$format"',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint('Error saving QR code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save QR code: $e',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
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

  Widget buildText(TextEditingController? controller, String label, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          label: Text(label),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        onChanged: (e) => setState(() {
          if (e.isEmpty) {
            data = '';
          } else {
            data = generatedData();
          }
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
            buildText(controllers['phone'], 'Phone', isNumeric: true),
            buildText(controllers['email'], 'Email'),
          ],
        );
      case 'url':
        return buildText(controllers['url'], 'URL');
      case 'wifi':
        return Column(
          children: [
            buildText(controllers['wifi_ssid'], 'WiFi SSID'),
            buildText(controllers['wifi_password'], 'WiFi Password'),
          ],
        );
      case 'email':
        return Column(
          children: [
            buildText(controllers['email'], 'Email Address'),
            buildText(controllers['email_subject'], 'Subject'),
            buildText(controllers['email_body'], 'Body'),
          ],
        );
      case 'sms':
        return Column(
          children: [
            buildText(controllers['sms_phone'], 'Phone Number', isNumeric: true),
            buildText(controllers['sms_message'], 'Message'),
          ],
        );
      case 'phone_call':
        return buildText(controllers['phone_call'], 'Phone Number', isNumeric: true);
      case 'geo':
        return Column(
          children: [
            buildText(controllers['geo_latitude'], 'Latitude', isNumeric: true),
            buildText(controllers['geo_longitude'], 'Longitude', isNumeric: true),
          ],
        );
      case 'event':
        return Column(
          children: [
            buildText(controllers['event_title'], 'Event Title'),
            buildText(controllers['event_description'], 'Description'),
            buildText(controllers['event_start'], 'Start Date (YYYYMMDDTHHMMSS)'),
            buildText(controllers['event_end'], 'End Date (YYYYMMDDTHHMMSS)'),
          ],
        );
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
      resizeToAvoidBottomInset: true,
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
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                    child: Column(
                      children: [
                        Text(
                          "Select QR Code Type",
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            color: widget.colors![1],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        data.isNotEmpty
                            ? Container(
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                    height: context.read<OptionController>().options.first.qrSize!.toDouble(),
                                    child: Screenshot(
                                      controller: screenshotController,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: context.read<OptionController>().options.first.qrTransparent! ? Colors.transparent : Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: QrImageView(
                                          data: data,
                                          backgroundColor: context.read<OptionController>().options.first.qrTransparent! ? Colors.transparent : Colors.white,
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
                                  ),
                              ),
                            )
                            : GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 3,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                padding: const EdgeInsets.all(10),
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  buildTypeButton(
                                    type: 'text',
                                    label: 'Text',
                                    icon: Icons.text_fields_rounded,
                                  ),
                                  buildTypeButton(
                                    type: 'url',
                                    label: 'URL',
                                    icon: Icons.link_rounded,
                                  ),
                                  buildTypeButton(
                                    type: 'contact',
                                    label: 'Contact',
                                    icon: Icons.contact_page_rounded,
                                  ),
                                  buildTypeButton(
                                    type: 'wifi',
                                    label: 'WiFi',
                                    icon: Icons.wifi,
                                  ),
                                  buildTypeButton(
                                    type: 'email',
                                    label: 'Email',
                                    icon: Icons.email,
                                  ),
                                  buildTypeButton(
                                    type: 'sms',
                                    label: 'SMS',
                                    icon: Icons.sms,
                                  ),
                                  buildTypeButton(
                                    type: 'phone_call',
                                    label: 'Phone',
                                    icon: Icons.phone,
                                  ),
                                  buildTypeButton(
                                    type: 'geo',
                                    label: 'Geo',
                                    icon: Icons.location_on,
                                  ),
                                  buildTypeButton(
                                    type: 'event',
                                    label: 'Event',
                                    icon: Icons.event,
                                  ),
                                ],
                              ),
                        const SizedBox(height: 10),
                        inputFields(selectedTyped),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              if (data.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: showSaveFormatSelectionDialog,
                      label: const Text(
                        'Save Code',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      icon: Icon(
                        Icons.save_alt_rounded,
                        color: widget.colors![1],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: showShareFormatSelectionDialog,
                      label: const Text(
                        'Share Code',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      icon: Icon(
                        Icons.share,
                        color: widget.colors![1],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}