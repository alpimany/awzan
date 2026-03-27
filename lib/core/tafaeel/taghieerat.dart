import 'package:awzan/core/parser/constants.dart';
import 'package:awzan/core/tafaeel/tafaeel.dart';

class Taghieer {
  Taghieer({
    required this.name,
    required this.description,
    required this.apply,
  });

  final String name;
  final String description;
  final (String, String) Function(Tafeelah) apply;

  Map toJson() => {'name': name, 'description': description};
}

final taghieerat = [
  Taghieer(
    name: 'القبض',
    description: 'حذف الخامس الساكن',
    apply: (Tafeelah t) {
      assert(t.value.length >= 5 && t.value[4] == "0");

      return (
        t.name.replaceRange(_hIndex(t.name, 4), _hIndex(t.name, 5), ""),
        t.value.replaceRange(4, 5, ""),
      );
    },
  ),
  Taghieer(
    name: 'الخبن',
    description: 'حذف الثاني الساكن',
    apply: (Tafeelah t) {
      assert(t.value.length >= 3 && t.value[1] == "0");

      return (
        t.name.replaceRange(_hIndex(t.name, 1), _hIndex(t.name, 2), ""),
        t.value.replaceRange(1, 2, ""),
      );
    },
  ),
  Taghieer(
    name: 'الخرم',
    description: 'حذف المتحرك الأول من الوتد المجموع في أوله',
    apply: (Tafeelah t) {
      assert(t.value.isNotEmpty && t.value.startsWith("110"));

      return (
        t.name.replaceRange(0, _hIndex(t.name, 1), ""),
        t.value.replaceRange(0, 1, ""),
      );
    },
  ),
  Taghieer(
    name: 'الحذف',
    description: 'حذف السبب الأخير من آخره',
    apply: (Tafeelah t) {
      assert(t.value.length >= 3 && t.value.endsWith("10"));

      return (
        t.name.substring(0, _hIndex(t.name, t.value.length - 2)),
        t.value.substring(0, t.value.length - 2),
      );
    },
  ),
  Taghieer(
    name: 'الكف',
    description: 'حذف السابع الساكن',
    apply: (Tafeelah t) {
      assert(t.value.length >= 7 && t.value.startsWith("0", 6));

      return (
        t.name.replaceRange(_hIndex(t.name, 6), _hIndex(t.name, 7), ""),
        t.value.replaceRange(6, 7, ""),
      );
    },
  ),
  Taghieer(
    name: 'القصر',
    description: 'حذف ثاني السبب الخفيف من آخره مع تسكين ما قبله',
    apply: (Tafeelah t) {
      assert(t.value.length >= 3 && t.value.endsWith("10"));

      String harfBeforeLast = t.name
          .split("")
          .where((el) => !RegExp(r'[\u0617-\u061A\u064B-\u0652]').hasMatch(el))
          .join()
          .substring(t.value.length - 2, t.value.length - 1);

      return (
        "${t.name.substring(0, _hIndex(t.name, t.value.length - 2))}$harfBeforeLast$sukoon",
        "${t.value.substring(0, t.value.length - 2)}0",
      );
    },
  ),
  Taghieer(
    name: 'القطع',
    description: 'حذف آخر الوتد المجموع مع تسكين ما قبله',
    apply: (Tafeelah t) {
      assert(t.value.length >= 3 && t.value.endsWith("110"));

      String harfBeforeLast = t.name
          .split("")
          .where((el) => !RegExp(r'[\u0617-\u061A\u064B-\u0652]').hasMatch(el))
          .join()
          .substring(t.value.length - 2, t.value.length - 1);

      return (
        "${t.name.substring(0, _hIndex(t.name, t.value.length - 2))}$harfBeforeLast$sukoon",
        "${t.value.substring(0, t.value.length - 2)}0",
      );
    },
  ),
  Taghieer(
    name: 'البتر',
    description: 'الحذف والقطع',
    apply: (Tafeelah t) {
      var (name, value) = ta('الحذف').apply(t);

      return ta('القطع').apply(Tafeelah(name: name, value: value));
    },
  ),
  Taghieer(
    name: 'الحذف+الخبن',
    description: 'الحذف والخبن',
    apply: (Tafeelah t) {
      var (name, value) = ta('الحذف').apply(t);

      return ta('الخبن').apply(Tafeelah(name: name, value: value));
    },
  ),
  Taghieer(
    name: 'الشكل',
    description: 'الكف والخبن',
    apply: (Tafeelah t) {
      var (name, value) = ta('الكف').apply(t);

      return ta('الخبن').apply(Tafeelah(name: name, value: value));
    },
  ),
  Taghieer(
    name: 'الطي',
    description: 'حذف الرابع الساكن',
    apply: (Tafeelah t) {
      assert(t.value.length >= 4 && t.value[3] == "0");

      return (
        t.name.replaceRange(_hIndex(t.name, 3), _hIndex(t.name, 4), ""),
        t.value.replaceRange(3, 4, ""),
      );
    },
  ),
  Taghieer(
    name: 'الخبل',
    description: 'الطي والخبن',
    apply: (Tafeelah t) {
      var (name, value) = ta('الطي').apply(t);

      return ta('الخبن').apply(Tafeelah(name: name, value: value));
    },
  ),
  Taghieer(
    name: 'التذييل',
    description: 'زيادة ساكن على ما آخره وتد مجموع.',
    apply: (Tafeelah t) {
      assert(t.value.length >= 3 && t.value.endsWith("110"));

      return (
        "${t.name.substring(0, _hIndex(t.name, t.value.length - 2))}لَان",
        "${t.value}0",
      );
    },
  ),
  Taghieer(
    name: 'القطع+الخبن',
    description: 'القطع والخبن',
    apply: (Tafeelah t) {
      var (name, value) = ta('القطع').apply(t);

      return ta('الخبن').apply(Tafeelah(name: name, value: value));
    },
  ),
  Taghieer(
    name: 'العصب',
    description: 'تسكين الخامس المتحرك',
    apply: (Tafeelah t) {
      assert(t.value.length >= 5 && t.value[4] == "1");

      return (
        t.name.replaceRange(
          _hIndex(t.name, 4),
          _hIndex(t.name, 5),
          "${t.value[4]}$sukoon",
        ),
        t.value.replaceRange(4, 5, "0"),
      );
    },
  ),
  Taghieer(
    name: 'القطف',
    description: 'الحذف والعصب',
    apply: (Tafeelah t) {
      var (name, value) = ta('الحذف').apply(t);

      return ta('العصب').apply(Tafeelah(name: name, value: value));
    },
  ),
];

Taghieer ta(String taghieer) =>
    taghieerat.firstWhere((el) => el.name == taghieer);

int _hIndex(String text, int index) {
  int pos = 0;

  while (pos < text.length) {
    if (!RegExp(r'[\u0617-\u061A\u064B-\u0652]').hasMatch(text[pos])) {
      if (--index < 0) break;
    }

    pos += 1;
  }

  return pos;
}
