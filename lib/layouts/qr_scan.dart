import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as contacts;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_generator/ads/interstitial.dart';
import 'package:qr_generator/controllers/option_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class QRScan extends StatefulWidget {
  final List<Color>? colors;
  final Color? textColor;

  const QRScan({
    super.key,
    required this.colors,
    required this.textColor,
  });

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> with TickerProviderStateMixin {
  String type = 'text';
  bool? flashEnabled;
  MobileScannerController? scannerController;
  late AnimationController controller;
  bool beep = true;
  final player = AudioPlayer();
  bool showZoomSlider = false; // Toggle for zoom slider visibility
  double currentZoomScale = 1.0; // Display range: 1.0 to 5.0

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();

    if (statuses.containsValue(PermissionStatus.denied)) {
      Fluttertoast.showToast(
        msg: "Camera permission is required to scan QR codes",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: widget.textColor,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    controller = AnimationController(vsync: this);
    flashEnabled = context.read<OptionController>().options.first.flash!;
    scannerController = MobileScannerController(
      detectionSpeed: context.read<OptionController>().options.first.detectionSpeed,
      facing: context.read<OptionController>().options.first.facing,
    );
    scannerController!.setZoomScale((currentZoomScale - 1.0) / 4.0); // Map 1.0-5.0 to 0.0-1.0
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (context.read<OptionController>().options.first.flash!) {
        scannerController!.toggleTorch();
      }
    });
  }

  void copy(String data) {
    Clipboard.setData(ClipboardData(text: data));
    Fluttertoast.showToast(
      msg: "Copied",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: widget.colors![0],
      textColor: widget.textColor,
    );
  }

  void process(String data) {
    scannerController!.stop();
    controller.stop();
    if (context.read<OptionController>().options.first.vibrate!) {
      Vibration.vibrate(duration: 50);
    }
    setState(() {
      flashEnabled = !flashEnabled!;
    });

    if (data.startsWith('BEGIN:VCARD')) {
      setState(() {
        type = 'contact';
      });
    } else if (data.startsWith('http://') || data.startsWith('https://')) {
      setState(() {
        type = 'url';
      });
    } else {
      setState(() {
        type = 'text';
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PopScope(
        onPopInvokedWithResult: (a, b) {
          scannerController!.start();
          controller.repeat();
        },
        child: DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.3,
          maxChildSize: 0.4,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    'Scanned Result:',
                    style: GoogleFonts.quicksand(
                      color: widget.colors![1],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Type: ${type.toUpperCase()}',
                    style: GoogleFonts.quicksand(
                      color: widget.colors![1],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          SelectableText(data),
                          const SizedBox(height: 15),
                          if (type == 'url')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    openURL(data);
                                  },
                                  icon: Icon(
                                    Icons.open_in_browser_rounded,
                                    color: widget.textColor,
                                  ),
                                  label: Text(
                                    "Open URL",
                                    style: GoogleFonts.quicksand(
                                      color: widget.textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    iconColor: widget.textColor,
                                    backgroundColor: widget.colors![0],
                                  ),
                                ),
                                if (!context.read<OptionController>().options.first.copyToClipboard!)
                                  const SizedBox(width: 20),
                                if (!context.read<OptionController>().options.first.copyToClipboard!)
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      copy(data);
                                    },
                                    icon: Icon(
                                      Icons.copy_rounded,
                                      color: widget.textColor,
                                    ),
                                    label: Text(
                                      "Copy URL",
                                      style: GoogleFonts.quicksand(
                                        color: widget.textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      iconColor: widget.textColor,
                                      backgroundColor: widget.colors![0],
                                    ),
                                  ),
                              ],
                            ),
                          if (type == 'contact')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    saveContact(data);
                                  },
                                  icon: const Icon(Icons.save_outlined),
                                  label: Text(
                                    "Save Contact",
                                    style: GoogleFonts.quicksand(
                                      color: widget.textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    iconColor: widget.textColor,
                                    backgroundColor: widget.colors![0],
                                  ),
                                ),
                                if (!context.read<OptionController>().options.first.copyToClipboard!)
                                  const SizedBox(width: 20),
                                if (!context.read<OptionController>().options.first.copyToClipboard!)
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      copy(data);
                                    },
                                    icon: const Icon(Icons.copy_all_rounded),
                                    label: Text(
                                      "Copy Contact",
                                      style: GoogleFonts.quicksand(
                                        color: widget.textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      iconColor: widget.textColor,
                                      backgroundColor: widget.colors![0],
                                    ),
                                  ),
                              ],
                            ),
                          const SizedBox(height: 15),
                          if (type == 'text' && !context.read<OptionController>().options.first.copyToClipboard!)
                            ElevatedButton.icon(
                              onPressed: () {
                                copy(data);
                              },
                              icon: const Icon(Icons.copy_all_rounded),
                              label: Text(
                                "Copy Text",
                                style: GoogleFonts.quicksand(
                                  color: widget.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                iconColor: widget.textColor,
                                backgroundColor: widget.colors![0],
                              ),
                            ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => Share.share(data),
                                icon: Icon(
                                  Icons.share_rounded,
                                  color: widget.colors![1],
                                ),
                                label: Text(
                                  'Share',
                                  style: GoogleFonts.quicksand(
                                    color: widget.colors![1],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  scannerController!.start();
                                  controller.repeat();
                                },
                                icon: Icon(
                                  Icons.qr_code_rounded,
                                  color: widget.colors![1],
                                ),
                                label: Text(
                                  'Scan Again',
                                  style: GoogleFonts.quicksand(
                                    color: widget.colors![1],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    if (context.read<OptionController>().options.first.copyToClipboard!) {
      copy(data);
    }
    InterstitialAds().loadInterstitialAd(context);
  }

  Future<void> openURL(String data) async {
    final uri = Uri.parse(data);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Fluttertoast.showToast(
        msg: "Could not launch URL",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: widget.textColor,
      );
    }
  }

  Future<void> saveContact(String data) async {
    List<String> lines = data.split('\n');
    String? name, phone, email;
    for (var line in lines) {
      if (line.startsWith('FN:')) name = line.substring(3);
      if (line.startsWith('TEL:')) phone = line.substring(4);
      if (line.startsWith('EMAIL:')) email = line.substring(6); // Adjusted for EMAIL
    }

    final contact = contacts.Contact()
      ..name.first = name ?? ''
      ..phones = [contacts.Phone(phone ?? '')]
      ..emails = [contacts.Email(email ?? '')];

    try {
      await contacts.FlutterContacts.requestPermission();
      await contact.insert();
      Fluttertoast.showToast(
        msg: "Contact saved",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: widget.colors![0],
        textColor: widget.textColor,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to save contact",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: widget.textColor,
      );
    }
  }

  void updateZoomScale(double scale) {
    final clampedScale = scale.clamp(1.0, 5.0); // Display range: 1.0 to 5.0
    final zoomValue = (clampedScale - 1.0) / 4.0; // Map to 0.0 to 1.0
    setState(() {
      currentZoomScale = clampedScale;
      scannerController!.setZoomScale(zoomValue);
      if (context.read<OptionController>().options.first.vibrate!) {
        Vibration.vibrate(duration: 20);
      }
    });
  }

  @override
  void dispose() {
    scannerController?.dispose();
    controller.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    beep = context.watch<OptionController>().options.first.beep!;
    return Scaffold(
      backgroundColor: widget.colors![0],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: widget.colors![0],
        foregroundColor: widget.textColor,
        actions: [
          IconButton(
            onPressed: () {
              context.read<OptionController>().setCamera();
              scannerController?.switchCamera();
            },
            icon: Icon(
              context.read<OptionController>().options.first.facing == CameraFacing.back
                  ? Icons.flip_camera_ios_outlined
                  : Icons.flip_camera_ios_rounded,
              color: widget.textColor,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                scannerController!.toggleTorch();
                flashEnabled = !flashEnabled!;
              });
            },
            icon: Icon(
              flashEnabled! ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              color: widget.textColor,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                showZoomSlider = !showZoomSlider;
              });
            },
            icon: Icon(
              Icons.zoom_in_rounded,
              color: widget.textColor,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onScaleUpdate: (ScaleUpdateDetails details) {
              double newScale = currentZoomScale * details.scale;
              updateZoomScale(newScale);
            },
            child: MobileScanner(
              controller: scannerController,
              onDetect: (e) async {
                if (beep) {
                  await player.play(AssetSource('audios/beep.mp3'));
                }
                final code = e.barcodes.first;
                if (code.rawValue != null) {
                  String? value = code.rawValue;
                  process(value!);
                }
              },
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Center(
              child: LottieBuilder.asset(
                'assets/animations/code-scanning.json',
                controller: controller,
                filterQuality: FilterQuality.high,
                onLoaded: (e) {
                  controller
                    ..duration = const Duration(seconds: 2)
                    ..repeat();
                },
              ),
            ),
          ),
          if (showZoomSlider)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: widget.colors![0].withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.zoom_out_rounded,
                      color: widget.textColor,
                      size: 20,
                    ),
                    Expanded(
                      child: Slider(
                        value: currentZoomScale, 
                        min: 1.0,
                        max: 5.0,
                        divisions: 40,
                        activeColor: widget.textColor,
                        inactiveColor: widget.textColor!.withOpacity(0.5),
                        onChanged: (value) {
                          updateZoomScale(value);
                        },
                      ),
                    ),
                    Icon(
                      Icons.zoom_in_rounded,
                      color: widget.textColor,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${currentZoomScale.toStringAsFixed(1)}x',
                      style: GoogleFonts.quicksand(
                        color: widget.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}