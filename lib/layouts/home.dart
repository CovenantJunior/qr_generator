import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_generator/layouts/options.dart';
import 'package:qr_generator/layouts/qr_generator.dart';
import 'package:qr_generator/layouts/qr_scan.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        leading: const SizedBox(),
      ),
      drawer: const Options(),
      backgroundColor: Colors.purple,
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text(
                'QR Generator',
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            // blurRadius: 5,
                            spreadRadius: 5,
                            color: Colors.white
                          )
                        ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buttonBuilder(
                            context,
                            "Generate QR Code",
                            Icons.qr_code_rounded,
                            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QRGenerator())
                            )
                          ),
            
                          const SizedBox(
                            height: 40,
                          ),
            
                           _buttonBuilder(
                            context,
                            "Scan QR Code",
                            Icons.qr_code_scanner_rounded,
                            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QRScan())
                            )
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buttonBuilder(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200,
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 90,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }

}