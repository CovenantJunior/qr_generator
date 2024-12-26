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
import 'package:qr_generator/controllers/option_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class QRScan extends StatefulWidget {
  List<Color>? colors;
  Color? textColor;

  QRScan({
    super.key,
    required this.colors,
    required this.textColor
  });

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> with TickerProviderStateMixin {

  String type = 'text';
  bool? flashEnabled;
  MobileScannerController? backScannerController;
  MobileScannerController? frontScannerController;
  
  late AnimationController controller;

  final player = AudioPlayer();

  Future<void> requestPermissions() async {
    // Request the necessary permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      // Add other permissions you need here
    ].request();

    // Check if all permissions are granted
    if (statuses.containsValue(PermissionStatus.denied)) {
      Fluttertoast.showToast(
        msg: "App may malfunctoin without granted permissions",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: widget.colors![0]
      );
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    controller = AnimationController(
      vsync: this
    );
    flashEnabled = context.watch<OptionController>().options.first.flash!;
    backScannerController = MobileScannerController(
      detectionSpeed: context.read<OptionController>().options.first.detectionSpeed,
      facing: CameraFacing.back,
    );
    frontScannerController = MobileScannerController(
      detectionSpeed: context.read<OptionController>().options.first.detectionSpeed,
      facing: CameraFacing.front,
    );
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (context.read<OptionController>().options.first.flash!) {
        backScannerController!.toggleTorch();
        frontScannerController!.toggleTorch();
      }
    });
  }

  void copy(data) {
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied!',
          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void beep() async {
    await player.play(AssetSource('audios/beep.mp3'));
  }

  void process(String data) {
    context.read<OptionController>().options.first.beep!
    ?
      beep()
    : 
      null;
    
    backScannerController!.stop();
    frontScannerController!.stop();
    controller.stop();
    context.read<OptionController>().options.first.vibrate! ? Vibration.vibrate(duration: 50) : null;

    if (data.startsWith('BEGIN:VCARD')) {
      setState(() {
        type = 'contact';
      });
    } else if(data.startsWith('http://') || data.startsWith('https://')) {
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
          /* scannerController!.start(); */
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24))
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration:  BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2)
                      ),
                    ),
                  ),
                  Text(
                    'Scanned Result:',
                    style: GoogleFonts.quicksand(
                      color: widget.colors![1],
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Type: ${type.toUpperCase()}',
                    style: GoogleFonts.quicksand(
                      color: widget.colors![1],
                      fontWeight: FontWeight.bold
                    )
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
                                    fontWeight: FontWeight.bold
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
                                    fontWeight: FontWeight.bold
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
                                icon: const Icon(
                                  Icons.save_outlined
                                ),
                                label: Text(
                                  "Save Contact",
                                  style: GoogleFonts.quicksand(
                                    color: widget.textColor,
                                    fontWeight: FontWeight.bold
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
                                icon: const Icon(
                                  Icons.copy_all_rounded
                                ),
                                label: Text(
                                  "Copy Contact",
                                  style: GoogleFonts.quicksand(
                                    color: widget.textColor,
                                    fontWeight: FontWeight.bold
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
                          if (type == 'text') 
                          if (!context.read<OptionController>().options.first.copyToClipboard!)
                            ElevatedButton.icon(
                              onPressed: () {
                                copy(data);
                              },
                              icon: const Icon(
                                Icons.copy_all_rounded
                              ),
                              label: Text(
                                "Copy Text",
                                style: GoogleFonts.quicksand(
                                  color: widget.textColor,
                                  fontWeight: FontWeight.bold
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
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  backScannerController!.start();
                                  frontScannerController!.start();
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
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  )
                ],
              ),
            );
          },
        ),
      )
    );

    context.read<OptionController>().options.first.copyToClipboard! ? copy(data) : null;
  }
  
  Future<void> openURL(String data) async {
    if (await canLaunchUrl(Uri.parse(data))) {
      launchUrl(Uri.parse(data));
    }
  }

  Future<void> saveContact(String data) async {
    List<String> lines = data.split('\n');
    String? name, phone, email;
    for (var line in lines) {
      if (line.startsWith('FN:')) name = line.substring(3);
      if (line.startsWith('TEL:')) phone = line.substring(4);
      if (line.startsWith('EMAIL:')) email = line.substring(5);
    }
    
    final contact = contacts.Contact()
    ..name.first = name!
    ..phones = [contacts.Phone(phone ?? '')]
    ..emails = [contacts.Email(email ?? '')];

    try {
      await contact.insert();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text( 
            'Saved!',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
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
          "Scan QR Code",
          style: GoogleFonts.quicksand(
            color: widget.colors![0],
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
           context.read<OptionController>().options.first.facing == CameraFacing.back ? IconButton(
            onPressed: () {
              context.read<OptionController>().setCamera();
            },
            icon: const Icon(
              Icons.flip_camera_ios_outlined
            ),
          ) : IconButton(
            onPressed: () {
              context.read<OptionController>().setCamera();
            },
            icon: const Icon(
              Icons.flip_camera_ios_rounded
            ),
          ),

          !flashEnabled! ? IconButton(
            onPressed: () {
              setState(() {
                backScannerController!.toggleTorch();
                frontScannerController!.toggleTorch();
                flashEnabled = !flashEnabled!;
              });
            },
            icon: const Icon(
              Icons.flash_off_rounded
            )
          ) : IconButton(
            onPressed: () {
              setState(() {
                backScannerController!.toggleTorch();
                frontScannerController!.toggleTorch();
                flashEnabled = !flashEnabled!;
              });
            },
            icon: const Icon(
              Icons.flash_on_rounded
            )
          )
        ],
      ),
      body: 
      Stack(
        children: [
          MobileScanner(
            controller: context.read<OptionController>().options.first.facing == CameraFacing.back ? backScannerController : frontScannerController,
            onDetect: (e) {
              final code = e.barcodes.first;
              if (code.rawValue != null) {
                String? value = code.rawValue;
                process(value!);
              }
            },
          ),
          GestureDetector(
            // onTap: () => process('test'),
            child: Opacity(
              opacity: .5,
              child: Center(
                child: LottieBuilder.asset(
                  'animations/code-scanning.json',
                  controller: controller,
                  filterQuality: FilterQuality.high,
                  onLoaded: (e) {
                    controller
                      ..duration = const Duration(seconds: 2)
                      ..repeat();
                  }
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
