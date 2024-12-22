import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionTile extends StatefulWidget {
  String? title;
  void fn;
  IconData icon;
  bool enabled;
  List<Color>? colors;
  Color? textColor;

  OptionTile({
    super.key,
    required this.title,
    required this.fn,
    required this.icon,
    required this.enabled,
    required this.colors,
    required this.textColor
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
        color: !widget.enabled ? widget.colors![1] : widget.colors![0],
        child: SizedBox(
          height: 100,
          width: 100,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: !widget.enabled ? widget.colors![0] : widget.textColor,
                size: 30,
              ),
              const SizedBox(height: 10),
              Text(
                widget.title!,
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  color: !widget.enabled ? widget.colors![0] : widget.textColor,
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