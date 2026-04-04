import 'package:awzan/core/tafaeel/tafaeel.dart';
import 'package:awzan/core/tafaeel/taghieerat.dart';

final altaweel = Bahar(
  name: "الطَوِيلُ",
  tafaeel: [
    tf('فُعُولُن').withTaghieerat([ta('القبض'), ta('الخرم')]),
    tf('مَفَاعِيلُن').withTaghieerat([ta('القبض'), ta('الحذف'), ta('الكف')]),
    tf('فُعُولُن').withTaghieerat([ta('القبض')]),
    tf('مَفَاعِيلُن').withTaghieerat([ta('القبض'), ta('الحذف')]),
  ],
);

final almadeed = Bahar(
  name: "المَدِيدُ",
  tafaeel: [
    tf('فَاعِلَاتُن').withTaghieerat([
      ta('الحذف'),
      ta('الخبن'),
      ta('الكف'),
      ta('القصر'),
      ta('البتر'),
      ta('الحذف+الخبن'),
      ta('الشكل'),
    ]),
    tf('فَاعِلُن').withTaghieerat([ta('الخبن')]),
    tf('فَاعِلَاتُن').withTaghieerat([
      ta('الحذف'),
      ta('الخبن'),
      ta('الكف'),
      ta('القصر'),
      ta('البتر'),
      ta('الحذف+الخبن'),
      ta('الشكل'),
    ]),
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
    tf('فَاعِلُن').withTaghieerat([ta('الخبن'), ta('القطع')]),
    tf('مُستَفعِلُن').withTaghieerat([
      ta('الخبن'),
      ta('الطي'),
      ta('القطع'),
      ta('التذييل'),
      ta('الخبل'),
      ta('القطع+الخبن'),
    ]),
    tf('فَاعِلُن').withTaghieerat([ta('الخبن'), ta('القطع')]),
  ],
);

final albasitAlmagzoou = Bahar(
  name: "ُالبَسِيطُ المَجزُوء",
  tafaeel: [
    tf('مُستَفعِلُن').withTaghieerat([
      ta('الخبن'),
      ta('الطي'),
      ta('القطع'),
      ta('التذييل'),
      ta('الخبل'),
    ]),
    tf('فَاعِلُن').withTaghieerat([ta('الخبن'), ta('القطع')]),
    tf('مُستَفعِلُن').withTaghieerat([
      ta('الخبن'),
      ta('الطي'),
      ta('القطع'),
      ta('التذييل'),
      ta('الخبل'),
    ]),
  ],
);

final mukhallaAlbasit = Bahar(
  name: "مُخَلَّعُ البَسِيطِ",
  tafaeel: [
    tf('مُستَفعِلُن').withTaghieerat([
      ta('الخبن'),
      ta('الطي'),
      ta('القطع'),
      ta('التذييل'),
      ta('الخبل'),
    ]),
    tf('فَاعِلُن').withTaghieerat([ta('الخبن'), ta('القطع')]),
    tf('فُعُولُن'),
  ],
);

final alwafer = Bahar(
  name: "الوافِرُ",
  tafaeel: [
    tf('مَفَاعَلَتُن').withTaghieerat([ta('العصب'), ta('القطف')]),
    tf('مَفَاعَلَتُن').withTaghieerat([ta('العصب'), ta('القطف')]),
    tf('مَفَاعَلَتُن').withTaghieerat([ta('العصب'), ta('القطف')]),
  ],
);

final alwaferAlmagzoou = Bahar(
  name: "الوافِرُ المَجزُوءُ",
  tafaeel: [
    tf('مَفَاعَلَتُن').withTaghieerat([ta('العصب'), ta('القطف')]),
    tf('مَفَاعَلَتُن').withTaghieerat([ta('العصب'), ta('القطف')]),
  ],
);

final alkamel = Bahar(
  name: "الكامِلُ",
  tafaeel: [
    tf('مُتَفَاعِلُن').withTaghieerat([
      ta('القطع'),
      ta('الحذذ'),
      ta('الإضمار'),
      ta('الوقص'),
      ta('التذييل'),
      ta('الترفيل'),
      ta('الحذذ+الإضمار'),
      ta('الخزل'),
    ]),
    tf('مُتَفَاعِلُن').withTaghieerat([
      ta('القطع'),
      ta('الحذذ'),
      ta('الحذذ+الإضمار'),
      ta('الإضمار'),
      ta('الوقص'),
      ta('التذييل'),
      ta('الترفيل'),
      ta('الخزل'),
    ]),
    tf('مُتَفَاعِلُن').withTaghieerat([
      ta('القطع', allow: [ta('الإضمار')]),
      ta('الحذذ'),
      ta('الحذذ+الإضمار'),
      ta('الإضمار'),
      ta('الوقص'),
      ta('الخزل'),
    ]),
  ],
);

final alkamelAlmagzoou = Bahar(
  name: "الكامِلُ المَجزُوءُ",
  tafaeel: [
    tf('مُتَفَاعِلُن').withTaghieerat([
      ta('القطع'),
      ta('الحذذ'),
      ta('الإضمار'),
      ta('الوقص'),
      ta('التذييل'),
      ta('الترفيل'),
      ta('الحذذ+الإضمار'),
      ta('الخزل'),
    ]),
    tf('مُتَفَاعِلُن').withTaghieerat([
      ta('الإضمار'),
      ta('الوقص'),
      ta('الخزل'),
      ta('القطع', allow: [ta('الإضمار')]),
      ta('التذييل', allow: [ta('الإضمار')]),
      ta('الترفيل', allow: [ta('الإضمار')]),
    ]),
  ],
);

final alhazag = Bahar(
  name: "الهَزَجُ",
  tafaeel: [
    tf('مَفَاعِيلُن').withTaghieerat([ta('الحذف'), ta('القبض'), ta('الكف')]),
    tf('مَفَاعِيلُن').withTaghieerat([ta('الحذف'), ta('القبض'), ta('الكف')]),
  ],
);

final arraml = Bahar(
  name: "الرَّملُ",
  tafaeel: [
    tf('فَاعِلَاتُن').withTaghieerat([
      ta('الخبن'),
      ta('الكف'),
      ta('الحذف'),
      ta('القصر'),
      ta('التسبيغ'),
      ta('الشكل'),
    ]),
    tf('فَاعِلَاتُن').withTaghieerat([
      ta('الخبن'),
      ta('الكف'),
      ta('الحذف'),
      ta('القصر'),
      ta('التسبيغ'),
      ta('الشكل'),
    ]),
    tf('فَاعِلَاتُن').withTaghieerat([
      ta('الخبن'),
      ta('الكف'),
      ta('الحذف'),
      ta('القصر'),
      ta('التسبيغ'),
      ta('الشكل'),
    ]),
  ],
);

final arramlAlmagzoou = Bahar(
  name: "الرَّملُ المَجزُوءُ",
  tafaeel: [
    tf('فَاعِلَاتُن').withTaghieerat([
      ta('الخبن'),
      ta('الكف'),
      ta('الحذف'),
      ta('القصر'),
      ta('التسبيغ'),
      ta('الشكل'),
    ]),
    tf('فَاعِلَاتُن').withTaghieerat([
      ta('الخبن'),
      ta('الكف'),
      ta('الحذف'),
      ta('القصر'),
      ta('التسبيغ'),
      ta('الشكل'),
    ]),
  ],
);

final assarree = Bahar(
  name: "السَّرِيعُ",
  tafaeel: [
    tf('مُستَفعِلُن').withTaghieerat([ta('الخبن'), ta('الطي'), ta('الخبل')]),
    tf('مُستَفعِلُن').withTaghieerat([ta('الخبن'), ta('الطي'), ta('الخبل')]),
    tf('مَفعُولَاتُ').withTaghieerat([
      ta('الصلم'),
      ta('الكسف+الطي'),
      ta('الوقف+الطي'),
      ta('الكسف+الطي+الخبن'),
    ]),
  ],
);

final assarreeAlMashtour = Bahar(
  name: "السَّرِيعُ المَشطُورُ",
  tafaeel: [
    tf('مُستَفعِلُن').withTaghieerat([ta('الخبن'), ta('الطي'), ta('الخبل')]),
    tf('مُستَفعِلُن').withTaghieerat([ta('الخبن'), ta('الطي'), ta('الخبل')]),
    tf('مَفعُولَاتُ').withTaghieerat([
      ta('الكسف', allow: [ta('الخبن')]),
      ta('الوقف', allow: [ta('الخبن')]),
    ]),
  ],
);

final almonsarih = Bahar(
  name: "المُنسَرِحُ",
  tafaeel: [
    tf(
      'مُستَفعِلُن',
    ).withTaghieerat([ta('الخبن'), ta('الطي'), ta('القطع'), ta('الخبل')]),
    tf(
      'مَفعُولَاتُ',
    ).withTaghieerat([ta('الخبن'), ta('الطي'), ta('الكسف'), ta('الوقف')]),
    tf('مُستَفعِلُن').withTaghieerat([ta('الطي'), ta('القطع')]),
  ],
);

final almonsarihAlmanhouk = Bahar(
  name: "المُنسَرِحُ المَنهُوكُ",
  tafaeel: [
    tf(
      'مُستَفعِلُن',
    ).withTaghieerat([ta('الخبن'), ta('الطي'), ta('القطع'), ta('الخبل')]),
    tf('مَفعُولَاتُ').withTaghieerat([ta('الخبن'), ta('الكسف'), ta('الوقف')]),
  ],
);

final alkhafif = Bahar(
  name: "الخَفِيفُ",
  tafaeel: [
    tf('فَاعِلَاتُن').withTaghieerat([
      ta('الخبن'),
      ta('الكف'),
      ta('الحذف'),
      ta('التشعيث'),
      ta('الشكل'),
    ]),
    tf(
      'مُس تَفعِ لُن',
    ).withTaghieerat([ta('الخبن'), ta('الكف'), ta('الشكل'), ta('القصر+الخبن')]),
    tf('فَاعِلَاتُن').withTaghieerat([ta('الخبن'), ta('الحذف'), ta('التشعيث')]),
  ],
);

final alkhafifAlmagzoou = Bahar(
  name: "الخَفِيفُ المَجزُوءُ",
  tafaeel: [
    tf('فَاعِلَاتُن').withTaghieerat([
      ta('الخبن'),
      ta('الكف'),
      ta('الحذف'),
      ta('التشعيث'),
      ta('الشكل'),
    ]),
    tf('مُس تَفعِ لُن').withTaghieerat([ta('الخبن'), ta('القصر+الخبن')]),
  ],
);

final almudharea = Bahar(
  name: "المُضارِعُ",
  tafaeel: [
    tf('مَفَاعِيلُن').withTaghieerat([ta('القبض'), ta('الكف')]),
    tf('فَاعِ لَا تُن').withTaghieerat([ta('الكف')]),
  ],
);

final almuqtadabh = Bahar(
  name: "المُقتَضَبُ",
  tafaeel: [
    tf('مَفعُولَاتُ').withTaghieerat([ta('الخبن'), ta('الطي')]),
    tf('مُستَفعِلُن').withTaghieerat([
      // TODO: Exclude مُستَفعِلُن
      ta('الطي'),
    ]),
  ],
);

final almujtath = Bahar(
  name: "المُجتَثُّ",
  tafaeel: [
    tf('مُس تَفعِ لُن').withTaghieerat([ta('الخبن'), ta('الكف'), ta('الشكل')]),
    tf('فَاعِلَاتُن').withTaghieerat([ta('الخبن'), ta('الكف'), ta('التشعيث')]),
  ],
);

final almutaqarip = Bahar(
  name: "المُتَقارِبُ",
  tafaeel: [
    tf('فُعُولُن').withTaghieerat([
      ta('القبض'),
      ta('القصر'),
      ta('الحذف'),
      ta('الخرم'),
      ta('البتر'),
    ]),
    tf('فُعُولُن').withTaghieerat([
      ta('القبض'),
      ta('القصر'),
      ta('الحذف'),
      ta('الخرم'),
      ta('البتر'),
    ]),
    tf('فُعُولُن').withTaghieerat([
      ta('القبض'),
      ta('القصر'),
      ta('الحذف'),
      ta('الخرم'),
      ta('البتر'),
    ]),
    tf(
      'فُعُولُن',
    ).withTaghieerat([ta('القبض'), ta('القصر'), ta('الحذف'), ta('البتر')]),
  ],
);

final almutaqaripAlmagzoou = Bahar(
  name: "المُتَقارِبُ المَجزُوءُ",
  tafaeel: [
    tf('فُعُولُن').withTaghieerat([
      ta('القبض'),
      ta('القصر'),
      ta('الحذف'),
      ta('الخرم'),
      ta('البتر'),
    ]),
    tf('فُعُولُن').withTaghieerat([
      ta('القبض'),
      ta('القصر'),
      ta('الحذف'),
      ta('الخرم'),
      ta('البتر'),
    ]),
    tf('فُعُولُن').withTaghieerat([ta('الحذف'), ta('البتر')]),
  ],
);

final almutadarak = Bahar(
  name: "المُتَدارَكُ",
  tafaeel: [
    tf(
      'فَاعِلُن',
    ).withTaghieerat([ta('الخبن'), ta('القطع'), ta('التذييل'), ta('الترفيل')]),
    tf(
      'فَاعِلُن',
    ).withTaghieerat([ta('الخبن'), ta('القطع'), ta('التذييل'), ta('الترفيل')]),
    tf(
      'فَاعِلُن',
    ).withTaghieerat([ta('الخبن'), ta('القطع'), ta('التذييل'), ta('الترفيل')]),
    tf('فَاعِلُن').withTaghieerat([ta('الخبن'), ta('القطع')]),
  ],
);

final almutadarakAlmagzoou = Bahar(
  name: "المُتَدارَكُ المَجزُوءُ",
  tafaeel: [
    tf(
      'فَاعِلُن',
    ).withTaghieerat([ta('الخبن'), ta('القطع'), ta('التذييل'), ta('الترفيل')]),
    tf(
      'فَاعِلُن',
    ).withTaghieerat([ta('الخبن'), ta('القطع'), ta('التذييل'), ta('الترفيل')]),
    tf(
      'فَاعِلُن',
    ).withTaghieerat([ta('الخبن'), ta('القطع'), ta('التذييل'), ta('الترفيل')]),
  ],
);

final alragazu = Bahar(
  name: "الرَّجَزُ",
  tafaeel: [
    tf(
      'مُستَفعِلُن',
    ).withTaghieerat([ta('الخبن'), ta('الطي'), ta('القطع'), ta('الخبل')]),
    tf(
      'مُستَفعِلُن',
    ).withTaghieerat([ta('الخبن'), ta('الطي'), ta('القطع'), ta('الخبل')]),
    tf('مُستَفعِلُن').withTaghieerat([
      ta('الخبن'),
      ta('الطي'),
      ta('القطع', allow: [ta('الخبن')]),
    ]),
  ],
);

final alragazuAlmagzoou = Bahar(
  name: "الرَّجَزُ المَجزُوءُ",
  tafaeel: [
    tf(
      'مُستَفعِلُن',
    ).withTaghieerat([ta('الخبن'), ta('الطي'), ta('القطع'), ta('الخبل')]),
    tf('مُستَفعِلُن').withTaghieerat([ta('الخبن'), ta('الطي')]),
  ],
);

final alragazuAlmashtour = Bahar(
  name: "الرَّجَزُ المَشطُورُ",
  tafaeel: [
    tf(
      'مُستَفعِلُن',
    ).withTaghieerat([ta('الخبن'), ta('الطي'), ta('القطع'), ta('الخبل')]),
    tf(
      'مُستَفعِلُن',
    ).withTaghieerat([ta('الخبن'), ta('الطي'), ta('القطع'), ta('الخبل')]),
    tf('مُستَفعِلُن').withTaghieerat([
      ta('الخبن'),
      ta('الطي'),
      ta('القطع', allow: [ta('الخبن')]),
    ]),
  ],
);

final alragazuAlmanhouk = Bahar(
  name: "الرَّجَزُ المَنهُوكُ",
  tafaeel: [
    tf(
      'مُستَفعِلُن',
    ).withTaghieerat([ta('الخبن'), ta('الطي'), ta('القطع'), ta('الخبل')]),
    tf('مُستَفعِلُن').withTaghieerat([ta('الخبن'), ta('الطي')]),
  ],
);

// TODO: add tests for each bahar

final buhoor = [
  altaweel,
  almadeed,
  albasit,
  albasitAlmagzoou,
  mukhallaAlbasit,
  alwafer,
  alwaferAlmagzoou,
  alkamel,
  alkamelAlmagzoou,
  alhazag,
  arraml,
  arramlAlmagzoou,
  assarree,
  assarreeAlMashtour,
  almonsarih,
  almonsarihAlmanhouk,
  alkhafif,
  alkhafifAlmagzoou,
  almudharea,
  almuqtadabh,
  almutaqarip,
  almutaqaripAlmagzoou,
  almutadarak,
  almutadarakAlmagzoou,
  alragazu,
  alragazuAlmagzoou,
  alragazuAlmashtour,
  alragazuAlmanhouk,
];

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
