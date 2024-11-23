import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as contacts;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScan extends StatefulWidget {
  const QRScan({super.key});

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> with SingleTickerProviderStateMixin {

  String type = 'text';
  bool flashEnabled = false;
  MobileScannerController scannerController = MobileScannerController();
  late AnimationController controller;

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
        backgroundColor: Colors.white,
        textColor: Colors.purple
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
  }

  void process(String data) {
    scannerController.stop();
    controller.stop();

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
          scannerController.start();
          controller.repeat();
        },
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
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
                  const Text(
                    'Scanned Result:',
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Type: ${type.toUpperCase()}',
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          SelectableText(data),
                          const SizedBox(height: 15),
                          if (type == 'url') 
                          ElevatedButton.icon(
                            onPressed: () {
                              openURL(data);
                            },
                            icon: const Icon(
                              Icons.open_in_browser_rounded
                            ),
                            label: const Text(
                              "Open URL"
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50)
                            ),
                          ),
                          if (type == 'contact') 
                          ElevatedButton.icon(
                            onPressed: () {
                              saveContact(data);
                            },
                            icon: const Icon(
                              Icons.save_outlined
                            ),
                            label: const Text(
                              "Save Contact"
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50)
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => Share.share(data),
                                icon: const Icon(
                                  Icons.share_rounded
                                ),
                                label: const Text('Share')
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  scannerController.start();
                                  controller.repeat();
                                },
                                icon: const Icon(
                                  Icons.qr_code_rounded
                                ),
                                label: const Text('Scan Again')
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
        const SnackBar(
          content: Text( 'Saved!'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
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
      backgroundColor: Colors.purple,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Scan QR Code",
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        actions: [
          !flashEnabled ? IconButton(
            onPressed: () {
              setState(() {
                scannerController.toggleTorch();
                flashEnabled = !flashEnabled;
              });
            },
            icon: const Icon(
              Icons.flash_off_rounded
            )
          ) : IconButton(
            onPressed: () {
              setState(() {
                scannerController.toggleTorch();
                flashEnabled = !flashEnabled;
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
            controller: scannerController,
            onDetect: (e) {
              final code = e.barcodes.first;
              if (code.rawValue != null) {
                String? value = code.rawValue;
                process(value!);
              }
            },
          ),
          Center(
            child: LottieBuilder.asset(
              'animations/scanning.json',
              controller: controller,
              filterQuality: FilterQuality.high,
              onLoaded: (e) {
                controller
                  ..duration = const Duration(seconds: 2)
                  ..repeat();
              }
            ),
          )
        ],
      )
    );
  }
}
