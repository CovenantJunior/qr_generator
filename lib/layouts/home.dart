import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_generator/layouts/options.dart';
import 'package:qr_generator/layouts/qr_generator.dart';
import 'package:qr_generator/layouts/qr_scan.dart';

class Home extends StatefulWidget {
  List<Color>? colors;
  Color? textColor;
  
  Home({
    super.key,
    required this.colors,
    required this.textColor
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<void> requestPermissions() async {
    // Request the necessary permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage
      // Add other permissions you need here
    ].request();

    // Check if all permissions are granted
    if (statuses.containsValue(PermissionStatus.denied)) {
      Fluttertoast.showToast(
        msg: "App may malfunctoin without granted permissions",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: widget.textColor,
        textColor: widget.colors![0]
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
        backgroundColor: widget.colors![0],
        foregroundColor: widget.textColor,
        leading: const SizedBox(),
      ),
      drawer: Options(colors: widget.colors, textColor: widget.textColor),
      backgroundColor: widget.colors![0],
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text(
                'QR Generator',
                style: GoogleFonts.quicksand(
                  color: widget.textColor,
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
                        boxShadow: [
                          BoxShadow(
                            // blurRadius: 5,
                            spreadRadius: 5,
                            color: widget.textColor!
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
                            () => Navigator.push(context, MaterialPageRoute(builder: (context) => QRGenerator(colors: widget.colors, textColor: widget.textColor))
                            )
                          ),
            
                          const SizedBox(
                            height: 40,
                          ),
            
                           _buttonBuilder(
                            context,
                            "Scan QR Code",
                            Icons.qr_code_scanner_rounded,
                            () => Navigator.push(context, MaterialPageRoute(builder: (context) => QRScan(colors: widget.colors, textColor: widget.textColor))
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
          color: widget.colors![0],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: widget.textColor,
              size: 90,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.quicksand(
                color: widget.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }

}