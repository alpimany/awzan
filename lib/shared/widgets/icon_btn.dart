import 'package:flutter/material.dart';


class IconBtn extends StatefulWidget {
  const IconBtn({
    super.key,
    required this.icon,
    required this.color,
    required this.hoverColor,
    required this.onTap,
    this.size = 20,
  });

  final IconData icon;
  final Color color;
  final Color hoverColor;
  final VoidCallback onTap;
  final double size;

  @override
  State<IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<IconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.hoverColor.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            widget.icon,
            size: widget.size,
            color: _hovered ? widget.hoverColor : widget.color,
          ),
        ),
      ),
    );
  }
}