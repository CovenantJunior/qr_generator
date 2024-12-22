import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_generator/components/option_tile.dart';
import 'package:qr_generator/components/theme_option_tile.dart';
import 'package:qr_generator/components/themes.dart';
import 'package:qr_generator/controllers/option_controller.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {

  option(id) {
    return false;
  }

  toggleTheme(id) {
    return false;
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
  CameraFacing facing = options.first.facing;
  int? qrSize = options.first.qrSize;
  bool? qrTransparent = options.first.qrTransparent;
  int? qrTheme = options.first.theme;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 0, 50),
      appBar: AppBar(
        leading: const SizedBox(),
        backgroundColor: const Color.fromARGB(255, 43, 0, 50),
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
                    title: "Beep",
                    icon: Icons.volume_up_outlined,
                    fn:  option(1),
                    enabled: beep!
                  ),
                  OptionTile(
                    title: "Vibrate",
                    icon: Icons.vibration_outlined,
                    fn:  option(2),
                    enabled: vibrate!
                  ),
                  OptionTile(
                    title: "Clipboard",
                    icon: Icons.copy,
                    fn:  option(3),
                    enabled: copyToClipboard!
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
                    title: "Detection Speed\n'${detectionSpeed.toString().split('.').last}'",
                    icon: Icons.speed_rounded,
                    fn:  option(4),
                    enabled: true
                  ),
                  OptionTile(
                    title: "Camera\n'${facing.toString().split('.').last}'",
                    icon: Icons.flip_camera_ios_outlined,
                    fn:  option(5),
                    enabled: true
                  ),
                  OptionTile(
                    title: "Flash",
                    icon: flash! ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                    fn:  option(6),
                    enabled: flash
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
                    title: "QR Size\n'$qrSize px'",
                    icon: Icons.qr_code_rounded,
                    fn:  option(7),
                    enabled: true
                  ),
                  OptionTile(
                    title: "Transparent",
                    icon: Icons.water_drop_sharp,
                    fn:  option(8),
                    enabled: qrTransparent!
                  ),
                  Stack(
                    children: [
                      OptionTile(
                        title: "Remove Ads",
                        icon: Icons.movie_filter_outlined,
                        fn:  option(9),
                        enabled: true
                      ),
                      const Icon(
                        Icons.workspace_premium_outlined
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70),
            Center(
              child: Text(
                "THEMES",
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
              child: Divider(),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 170,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: themes.map((theme) {
                  return Row(
                    children: [
                      ThemeOptionTile(
                        title: theme['name'],
                        icon: Icons.volume_up_outlined,
                        fn: toggleTheme(theme['id']),
                        enabled: theme['id'] == qrTheme,
                        color: theme['color'],
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