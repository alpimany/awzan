import 'package:awzan/core/tafaeel/tafaeel.dart';
import 'package:awzan/core/tafaeel/taghieerat.dart';

final altaweel = Bahar(
  name: "الطَوِيلُ",
  tafaeel: [
    tf('فُعُولُن').withTaghieerat([ta('القبض'), ta('الخرم')]),
    tf('مَفاعِيلُن').withTaghieerat([ta('القبض'), ta('الحذف'), ta('الكف')]),
    tf('فُعُولُن').withTaghieerat([ta('القبض')]),
    tf('مَفاعِيلُن').withTaghieerat([ta('القبض'), ta('الحذف')]),
  ],
);

final albasit = Bahar(
  name: "البَسِيطُ",
  tafaeel: [
    tf('مُستَفعِلُن').withTaghieerat([
      ta('الخبن'),
      ta('الطي'),
      ta('القطع'),
      ta('التذييل'),
      ta('الخبل'),
      ta('القطع+الخبن'),
    ]),
    tf('فاعِلُن').withTaghieerat([ta('الخبن'), ta('القطع')]),
    tf('مُستَفعِلُن').withTaghieerat([
      ta('الخبن'),
      ta('الطي'),
      ta('القطع'),
      ta('التذييل'),
      ta('الخبل'),
      ta('القطع+الخبن'),
    ]),
    tf('فاعِلُن').withTaghieerat([ta('الخبن'), ta('القطع')]),
  ],
);

final alwafer = Bahar(
  name: "الوافِرُ",
  tafaeel: [
    tf('مَفاعَلَتُن').withTaghieerat([ta('العصب'), ta('القطف')]),
    tf('مَفاعَلَتُن').withTaghieerat([ta('العصب'), ta('القطف')]),
    tf('مَفاعَلَتُن').withTaghieerat([ta('العصب'), ta('القطف')]),
  ],
);

final mukhallaAlbasit = Bahar(
  name: "مُخَلَّعُ البَسِيطِ",
  tafaeel: [
    tf('مُستَفعِلُن').withTaghieerat([]),
    tf('فاعِلُن').withTaghieerat([ta('الخبن')]),
    tf('فُعُولُن').withTaghieerat([]),
  ],
);

final buhoor = [altaweel, albasit, alwafer, mukhallaAlbasit];

class Bahar {
  Bahar({required this.name, required this.tafaeel})
    // Cartesian Product algorithm.
    : sowar = tafaeel.map((e) => [e, ...e.sowar]).fold([[]], (a, b) {
        return [
          for (var sublist in a.map((x) => b.map((y) => [...x, y]))) ...sublist,
        ];
      });

  final String name;
  final List<Tafeelah> tafaeel;
  final List<List<Tafeelah>> sowar;
}

class Sowrah {
  Sowrah({required this.name, required this.value, required this.taghieer});

  final String name;
  final String value;
  final Taghieer taghieer;

  @override
  String toString() {
    return name;
  }

  Map toJson() => {'name': name, 'value': value, 'taghieer': taghieer.toJson()};
}
