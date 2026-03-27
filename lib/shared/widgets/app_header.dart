import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'package:awzan/app/theme.dart';
import 'package:awzan/shared/utils/responsive.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  static bool get _isDesktop =>
      !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

  @override
  Widget build(BuildContext context) {
    final s          = screenScale(context);
    final isDesktop  = _isDesktop;

    Widget bar = Container(
      height: 52 * s,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: 16 * s),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Image.asset(
            'assets/logos/awzan.png',
            width: 28 * s,
            height: 28 * s,
          ),
          SizedBox(width: 10 * s),
          Text(
            'أوزان',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Scheherazade',
              fontSize: scaledFont(context, 20),
              fontWeight: FontWeight.w700,
              color: AppColors.gold,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          if (isDesktop) ...[
            _WinBtn(
              icon: Icons.remove,
              onTap: () => windowManager.minimize(),
            ),
            const SizedBox(width: 6),
            _WinBtn(
              icon: Icons.crop_square,
              onTap: () async {
                if (await windowManager.isMaximized()) {
                  windowManager.unmaximize();
                } else {
                  windowManager.maximize();
                }
              },
            ),
            const SizedBox(width: 6),
            _WinBtn(
              icon: Icons.close,
              onTap: () => windowManager.close(),
              danger: true,
            ),
          ],
        ],
      ),
    );

    if (isDesktop) {
      bar = GestureDetector(
        onPanStart: (_) => windowManager.startDragging(),
        child: bar,
      );
    }

    return bar;
  }
}

class _WinBtn extends StatefulWidget {
  const _WinBtn({
    required this.icon,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool danger;

  @override
  State<_WinBtn> createState() => _WinBtnState();
}

class _WinBtnState extends State<_WinBtn> {
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
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _hovered
                ? (widget.danger ? AppColors.red : AppColors.border)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            widget.icon,
            size: 14,
            color: _hovered && widget.danger ? Colors.white : AppColors.textSec,
          ),
        ),
      ),
    );
  }
}