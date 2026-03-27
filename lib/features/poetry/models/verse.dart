import 'package:flutter/material.dart';

class Verse {
  Verse({this.chest = const Part(), this.rump = const Part()});

  /// Al-Sadr — the first half of a verse.
  final Part chest;

  /// Al-Ajuz — the second half of a verse.
  final Part rump;

  final GlobalKey key = GlobalKey();
}

class Part {
  const Part({this.value = ''});

  final String value;
}