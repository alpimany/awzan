import 'package:awzan/core/tafaeel/taghieerat.dart';

final fa = Tafeelah(name: 'فَع', value: "10");
final faal = Tafeelah(name: 'فَعَل', value: "110");
final falun = Tafeelah(name: 'فَعلُن', value: "1010");
final mustafelun = Tafeelah(name: 'مُستَفعِلُن', value: "1010110");
final faelun = Tafeelah(name: 'فَعِلُن', value: "1110");
final faaelun = Tafeelah(name: 'فَاعِلُن', value: "10110");
final fuoolun = Tafeelah(name: 'فُعُولُن', value: "11010");
final mafaeelun = Tafeelah(name: 'مَفَاعِيلُن', value: "1101010");
final mafaelun = Tafeelah(name: 'مَفَاعِلُن', value: "110110");
final mafoulatu = Tafeelah(name: 'مَفعُولَاتُ', value: "1010101");
final mafaalatun = Tafeelah(name: 'مَفَاعَلَتُن', value: "1101110");
final mutafaelun = Tafeelah(name: 'مُتَفَاعِلُن', value: "1110110");
final faaelatun = Tafeelah(name: 'فَاعِلَاتُن', value: "1011010");
final musTafEiLun = Tafeelah(name: 'مُس تَفعِ لُن', value: "1010110");
final faaElaaTun = Tafeelah(name: 'فَاعِ لَا تُن', value: "1010110");

final tafaeel = [
  mafoulatu,
  mustafelun,
  musTafEiLun,
  mafaalatun,
  mutafaelun,
  faaelatun,
  faaElaaTun,
  mafaeelun,
  mafaelun,
  faaelun,
  fuoolun,
  faelun,
  falun,
  faal,
  fa,
];

Tafeelah tf(String wazn) => tafaeel.firstWhere((el) => el.name == wazn);

class Tafeelah {
  Tafeelah({
    required this.name,
    required this.value,
    this.sowar = const [],
    this.taghieer,
  });

  final String name;
  final String value;
  final List<Tafeelah> sowar;
  final Taghieer? taghieer;

  Tafeelah withTaghieerat(List<Taghieer> taghieerat) {
    List<Tafeelah> newSowar = [];
    for (var taghieer in taghieerat) {
      var (name, value) = taghieer.apply(this);

      int idx = tafaeel.indexWhere((el) => el.value == value);
      Tafeelah? similar = idx > 0 ? tafaeel.elementAtOrNull(idx) : null;
      Tafeelah tafeelah = Tafeelah(
        name: similar != null ? similar.name : name,
        value: value,
        taghieer: taghieer,
      );

      newSowar.add(tafeelah);

      if (taghieer.allow != null) {
        for (var extraTaghieer in taghieer.allow!) {
          (name, value) = extraTaghieer.apply(tafeelah);

          int idx = tafaeel.indexWhere((el) => el.value == value);
          Tafeelah? similar = idx > 0 ? tafaeel.elementAtOrNull(idx) : null;

          newSowar.add(
            Tafeelah(
              name: similar != null ? similar.name : name,
              value: value,
              taghieer: extraTaghieer,
            ),
          );
        }
      }
    }

    return Tafeelah(name: name, value: value, sowar: newSowar);
  }

  @override
  String toString() {
    return name;
  }

  Map toJson() {
    Map json = {'name': name, 'value': value};

    if (sowar.isNotEmpty) {
      json.addAll({'sowar': sowar.map((e) => e.toJson()).toList()});
    }

    if (taghieer != null) {
      json.addAll({'taghieer': taghieer!.toJson()});
    }

    return json;
  }
}
