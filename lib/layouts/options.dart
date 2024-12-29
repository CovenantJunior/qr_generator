import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_generator/components/option_tile.dart';
import 'package:qr_generator/components/theme_option_tile.dart';
import 'package:qr_generator/components/themes.dart';
import 'package:qr_generator/controllers/option_controller.dart';

class Options extends StatefulWidget {
  List<Color>? colors;
  Color? textColor;

  Options({
    super.key,
    required this.colors,
    required this.textColor
  });

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {

  void speedInfo() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Scan Mode",
        textAlign: TextAlign.center,
        style: GoogleFonts.quicksand(
          color: widget.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: widget.colors![0],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              "NORMAL",
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: widget.textColor,
                fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Text(
              "Scans barcodes with a timeout between scans.",
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: widget.textColor,
              ),
            ),
          ),
          ListTile(
            title: Text(
              "TURBO MODE",
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: widget.textColor,
                fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Text(
              "Scans barcodes continuously, may cause memory issues.",
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: widget.textColor,
              ),
            ),
          ),
          ListTile(
            title: Text(
              "NO DUPLICATES",
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: widget.textColor,
                fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Text(
              "Scans each barcode only once until a new one is scanned.",
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: widget.textColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  List<Map<String, dynamic>> themes = Themes().themes;

  @override
  void initState() {
    super.initState();
    context.read<OptionController>().initOptions();
  }

  @override
  Widget build(BuildContext context) {
    List options = context.watch<OptionController>().options;
    bool? beep = options.first.beep;
    bool? vibrate = options.first.vibrate;
    bool? copyToClipboard = options.first.copyToClipboard;
    bool? flash = options.first.flash;
    DetectionSpeed detectionSpeed = options.first.detectionSpeed;
    String? optionName;
    switch (detectionSpeed.toString().split('.').last) {
      case 'normal':
        optionName = 'NORMAL';
        break;
      case 'unrestricted':
        optionName = 'TURBO MODE';
        break;
      case 'noDuplicates':
        optionName = 'NO DUPLICATES';
        break;
      default:
    }
    CameraFacing facing = options.first.facing;
    int? qrSize = options.first.qrSize;
    bool? qrTransparent = options.first.qrTransparent;
    int? qrTheme = options.first.theme;

    return Scaffold(
      backgroundColor: widget.colors![0],
      appBar: AppBar(
        leading: const SizedBox(),
        backgroundColor: widget.colors![0],
      ),
      body: 
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OptionTile(
                    id: 1,
                    title: "Beep",
                    icon: Icons.volume_up_outlined,
                    enabled: beep!,
                    colors: widget.colors,
                    textColor: widget.textColor
                  ),
                  OptionTile(
                    id: 2,
                    title: "Vibrate",
                    icon: Icons.vibration_outlined,
                    enabled: vibrate!,
                    colors: widget.colors,
                    textColor: widget.textColor
                  ),
                  OptionTile(
                    id: 3,
                    title: "Clipboard",
                    icon: Icons.copy,
                    enabled: copyToClipboard!,
                    colors: widget.colors,
                    textColor: widget.textColor
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    children: [
                      OptionTile(
                        id: 4,
                        title: "Scan Mode\n'$optionName'",
                        icon: Icons.speed_rounded,
                        enabled: true,
                        colors: widget.colors,
                        textColor: widget.textColor
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: GestureDetector(
                          onTap: speedInfo,
                          child: Icon(
                            Icons.help_outline_rounded,
                            color: widget.textColor,
                            size: 20,
                          ),
                        ),
                      )
                    ]
                  ),
                  OptionTile(
                    id: 5,
                    title: "Camera\n'${facing.toString().split('.').last.toUpperCase()}'",
                    icon: facing == CameraFacing.back ? Icons.flip_camera_ios_outlined : Icons.flip_camera_ios_rounded,
                    enabled: true,
                    colors: widget.colors,
                    textColor: widget.textColor
                  ),
                  OptionTile(
                    id: 6,
                    title: "Flash",
                    icon: flash! ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                    enabled: flash,
                    colors: widget.colors,
                    textColor: widget.textColor
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OptionTile(
                    id: 7,
                    title: "QR Size\n'$qrSize px'",
                    icon: Icons.qr_code_rounded,
                    enabled: true,
                    colors: widget.colors,
                    textColor: widget.textColor
                  ),
                  OptionTile(
                    id: 8,
                    title: "Transparent",
                    icon: Icons.water_drop_sharp,
                    enabled: qrTransparent!,
                    colors: widget.colors,
                    textColor: widget.textColor
                  ),
                  Stack(
                    children: [
                      OptionTile(
                        id: 9,
                        title: "Remove Ads",
                        icon: Icons.movie_filter_outlined,
                        enabled: true,
                        colors: widget.colors,
                        textColor: widget.textColor
                      ),
                      Positioned(
                        right: 0,
                        child: Icon(
                          Icons.workspace_premium_outlined,
                          color: widget.textColor,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70),
            Icon(
              Icons.color_lens_outlined,
              color: widget.textColor,
              size: 40,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
              child: Divider(
                color: widget.textColor,
                thickness: .4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 170,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: themes.map((theme) {
                  return Row(
                    children: [
                      ThemeOptionTile(
                        id: theme['id'],
                        title: theme['name'],
                        icon: Icons.volume_up_outlined,
                        enabled: theme['id'] == qrTheme,
                        color: theme['color'],
                        textColor: theme['textColor'],
                      ),
                      const SizedBox(width: 20)
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        )
    );
  }
}