import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:awzan/core/buhoor.dart';
import 'package:path/path.dart' as path;
import 'package:awzan/core/utils/prosody_writing/prosody_writing.dart';

void main() {
  var lameyyahAlarab = File(
    path.join(Directory.current.path, 'test', 'lameyyah_alarab.txt'),
  ).readAsStringSync().split('\n');

  test("Every part of la-meyyatul-arab is from at'taweel", () {
    for (String part in lameyyahAlarab) {
      final matches = ProsodyWriting.getMatchesForText(part.trim());

      expect(true, matches.any((match) => match.$1.name == altaweel.name));
    }
  });

  var lameyyahAbiTalib = File(
    path.join(Directory.current.path, 'test', 'lameyyah_abi_talib.txt'),
  ).readAsStringSync().split('\n');

  test("First 50 part of la-meyyatu-abi-talib is from at'taweel", () {
    int c = 1;
    for (String part in lameyyahAbiTalib) {
      if (c++ >= 50) break;
      final matches = ProsodyWriting.getMatchesForText(part.trim());

      expect(true, matches.any((match) => match.$1.name == altaweel.name));
    }
  });

  var muallaqahAlqais = File(
    path.join(Directory.current.path, 'test', 'muallaqah_alqais.txt'),
  ).readAsStringSync().split('\n');

  test("Every part of مُعلَّقة امرُؤ القَيس is from at'taweel", () {
    for (String part in muallaqahAlqais) {
      final matches = ProsodyWriting.getMatchesForText(part.trim());

      expect(true, matches.any((match) => match.$1.name == altaweel.name));
    }
  });
}
