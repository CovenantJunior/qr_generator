import 'package:flutter/material.dart';
import 'package:qr_generator/components/option_tile.dart';

class QRDrawer extends StatefulWidget {
  const QRDrawer({super.key});

  @override
  State<QRDrawer> createState() => _QRDrawerState();
}

class _QRDrawerState extends State<QRDrawer> {

  beep() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        leading: const SizedBox(),
        backgroundColor: Colors.purple,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close_fullscreen_rounded,
                color: Colors.white,
              )
            ),
          )
        ],
      ),
      body: 
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OptionTile(
                    title: "Beep",
                    icon: Icons.volume_up_outlined,
                    fn: beep(),
                    enabled: true
                  ),
                  OptionTile(
                    title: "Vibrate",
                    icon: Icons.vibration_outlined,
                    fn: beep(),
                    enabled: false
                  ),
                  OptionTile(
                    title: "Vibrate",
                    icon: Icons.vibration_outlined,
                    fn: beep(),
                    enabled: false
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OptionTile(
                    title: "Beep",
                    icon: Icons.volume_up_outlined,
                    fn: beep(),
                    enabled: true
                  ),
                  OptionTile(
                    title: "Vibrate",
                    icon: Icons.vibration_outlined,
                    fn: beep(),
                    enabled: false
                  ),
                  OptionTile(
                    title: "Vibrate",
                    icon: Icons.vibration_outlined,
                    fn: beep(),
                    enabled: true
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OptionTile(
                    title: "Beep",
                    icon: Icons.volume_up_outlined,
                    fn: beep(),
                    enabled: false
                  ),
                  OptionTile(
                    title: "Vibrate",
                    icon: Icons.vibration_outlined,
                    fn: beep(),
                    enabled: true
                  ),
                  OptionTile(
                    title: "Vibrate",
                    icon: Icons.vibration_outlined,
                    fn: beep(),
                    enabled: false
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OptionTile(
                    title: "Beep",
                    icon: Icons.volume_up_outlined,
                    fn: beep(),
                    enabled: false
                  ),
                  OptionTile(
                    title: "Vibrate",
                    icon: Icons.vibration_outlined,
                    fn: beep(),
                    enabled: true
                  ),
                  OptionTile(
                    title: "Vibrate",
                    icon: Icons.vibration_outlined,
                    fn: beep(),
                    enabled: false
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        )
    );
  }
}