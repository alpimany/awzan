import 'dart:io';
import 'package:awzan/core/buhoor.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_writing.dart';
import 'package:path/path.dart' as path;

import 'package:flutter_test/flutter_test.dart';

void main() {
  test("يمكن التعرف على قصائد بحر الطويل", () => testBahar(altaweel));

  test("يمكن التعرف على قصائد بحر الكامل", () => testBahar(alkamel));

  test("يمكن التعرف على قصائد بحر الرجز", () => testBahar(alragazu));

  test(
    "يمكن التعرف على قصائد بحر السريع المشطور",
    () => testBahar(assarreeAlMashtour),
  );
}

void testBahar(Bahar bahar) {
  var dirPath = path.join(
    Directory.current.path,
    'test/data/poetry',
    bahar.name,
  );
  var dir = Directory(dirPath).listSync();

  if (dir.any((e) => e.path.endsWith(".txt"))) {
    for (var entry in dir) {
      if (entry.path.endsWith(".txt")) {
        var poetry = File(entry.path).readAsStringSync().split('\n');

        for (String part in poetry) {
          final matches = ProsodyWriting.getMatchesForText(part.trim());

          expect(true, matches.any((match) => match.$1.name == bahar.name));
        }
      }
    }
  } else {
    throw "لا توجد قصائد في مجلد بحر ${bahar.name}";
  }
}
