import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_generator/controllers/option_controller.dart';

class OptionTile extends StatefulWidget {
  int id;
  String? title;
  IconData icon;
  bool enabled;
  List<Color>? colors;
  Color? textColor;

  OptionTile({
    super.key,
    required this.id,
    required this.title,
    required this.icon,
    required this.enabled,
    required this.colors,
    required this.textColor
  });

  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  int? _selectedSize;

  List<DropdownMenuItem<int>> getDropdownItems() {
    List<DropdownMenuItem<int>> items = [];
    items.add(const DropdownMenuItem(value: 100, child: Text('100x100')));
    items.add(const DropdownMenuItem(value: 200, child: Text('200x200')));
    items.add(const DropdownMenuItem(value: 300, child: Text('300x300')));
    return items;
  }

  void selectSize() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Select Size",
          textAlign: TextAlign.center,
          style: GoogleFonts.quicksand(
            color: widget.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: widget.colors![0],
        content: DropdownButton(
          dropdownColor: widget.colors![0],
          style: GoogleFonts.quicksand(
            color: widget.textColor,
            fontWeight: FontWeight.w500,
          ),
          iconEnabledColor: widget.textColor,
          value: context.read<OptionController>().options.first.qrSize,
          onChanged: (int? newValue) {
            setState(() {
              _selectedSize = newValue;
            });
            context.read<OptionController>().setQRSize(newValue);
            Navigator.pop(context);
          },
          items: getDropdownItems(),
        )
      ),
    );
  }

  option(id, {int? size}) {
    switch (id) {
      case 1:
        context.read<OptionController>().setBeep();
        break;
      case 2:
        context.read<OptionController>().setVibrations();
        break;
      case 3:
        context.read<OptionController>().setClipboard();
        break;
      case 4:
        context.read<OptionController>().setDetectionSpeed();
        break;
      case 5:
        context.read<OptionController>().setCamera();
        break;
      case 6:
        context.read<OptionController>().setFlash();
        break;
      case 7:
        selectSize();
        // context.read<OptionController>().setQRSize(size);
        break;
      case 8:
        context.read<OptionController>().setTransparent();
        break;
      default:
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => option(widget.id),
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