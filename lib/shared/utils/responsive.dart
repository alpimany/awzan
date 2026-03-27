import 'package:flutter/material.dart';

/// Returns a scale factor: 1.0 on screens ≥ 600 px, down to 0.75 at 320 px.
double screenScale(BuildContext context) {
  final w = MediaQuery.sizeOf(context).width;
  if (w >= 600) return 1.0;
  if (w <= 320) return 0.75;
  return 0.75 + (w - 320) / (600 - 320) * 0.25;
}

/// Scales [base] font size by [screenScale] and rounds to a whole number.
double scaledFont(BuildContext context, double base) =>
    (base * screenScale(context)).roundToDouble();