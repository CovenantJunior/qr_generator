import 'package:flutter/material.dart';

class ThemeOptionTile extends StatefulWidget {
  String? title;
  void fn;
  IconData icon;
  bool enabled;
  List<Color> color;
  ThemeOptionTile({
    super.key,
    required this.title,
    required this.fn,
    required this.icon,
    required this.enabled,
    required this.color
  });

  @override
  State<ThemeOptionTile> createState() => _ThemeOptionTileState();
}

class _ThemeOptionTileState extends State<ThemeOptionTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.fn,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Card(
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
          if (widget.enabled)
          const Center(
            child: Icon(
              Icons.done_outline_rounded,
              color: Colors.white,
            ),
          )
        ]
      ),
    );
  }
}