import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_generator/controllers/option_controller.dart';

class ThemeOptionTile extends StatefulWidget {
  int? id;
  String? title;
  IconData icon;
  bool enabled;
  List<Color> color;
  Color? textColor;
  ThemeOptionTile({
    super.key,
    required  this.id,
    required this.title,
    required this.icon,
    required this.enabled,
    required this.color,
    required this.textColor
  });

  @override
  State<ThemeOptionTile> createState() => _ThemeOptionTileState();
}

class _ThemeOptionTileState extends State<ThemeOptionTile> {
  toggleTheme(id) {
    context.read<OptionController>().updateTheme(id);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () => toggleTheme(widget.id),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    widget.color[0],
                    widget.color[1]
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
        Text(
          widget.title!,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: widget.textColor
          ),
        ),
        if (widget.enabled)
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Center(
            child: Icon(
              Icons.done_outline_rounded,
              color: widget.textColor,
            ),
          ),
        )
        
      ]
    );
  }
}