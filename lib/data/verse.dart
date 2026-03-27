import 'package:flutter/material.dart';

class Verse {
  Verse({this.chest = const Part(), this.rump = const Part()});

  // Al-Sadr
  final Part chest;
  // Al-Ajuz
  final Part rump;

  final GlobalKey key = GlobalKey();
}

class Part {
  const Part({this.value = ""});

  final String value;
}
