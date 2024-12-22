import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionTile extends StatefulWidget {
  String? title;
  void fn;
  IconData icon;
  bool enabled;
  OptionTile({
    super.key,
    required this.title,
    required this.fn,
    required this.icon,
    required this.enabled
  });

  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.fn,
      child: Card(
        elevation: 10,
        color: !widget.enabled ?const Color.fromARGB(255, 43, 0, 50) : const Color.fromARGB(255, 15, 0, 15),
        child: SizedBox(
          height: 100,
          width: 100,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: !widget.enabled ? Colors. grey : Colors.white,
                size: 30,
              ),
              const SizedBox(height: 10),
              Text(
                widget.title!,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  color: !widget.enabled ? Colors.grey : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}