import 'package:flutter/material.dart';
import 'package:qr_generator/components/option_tile.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {

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