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
        color: widget.enabled ?Colors.purple : Colors.blue[700],
        child: SizedBox(
          height: 100,
          width: 100,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(height: 10),
              Text(
                widget.title!,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}