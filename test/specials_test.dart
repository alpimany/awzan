import 'package:flutter_test/flutter_test.dart';
import 'package:awzan/core/tafaeel/tafaeel.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_writing.dart';

void main() {
  test("The prosody of word اللهُ is same as ${falun.name} ${fa.name}", () {
    String binary = ProsodyWriting.textToBinary('اللهُ');

    expect(binary, "${falun.value}${fa.value}");
  });

  test("The prosody of word واللهُ is same as ${falun.name} ${fa.name}", () {
    String binary = ProsodyWriting.textToBinary('واللهُ');

    expect(binary, "${falun.value}${fa.value}");
  });

  test("The prosody of هَوَ اللهُ is same as ${mafaeelun.name}", () {
    String binary = ProsodyWriting.textToBinary('هُوَ اللهُ');

    expect(binary, mafaeelun.value);
  });

  test("The prosody of word والذي is same as ${faaelun.name}", () {
    String binary = ProsodyWriting.textToBinary('والذي');

    expect(binary, faaelun.value);
  });

  test("The prosody of word لِلذي is same as ${faaelun.name}", () {
    String binary = ProsodyWriting.textToBinary('لِلذي');

    expect(binary, faaelun.value);
  });

  test("The prosody of word والذينَ is same as ${faaelun.name} ${fa.name}", () {
    String binary = ProsodyWriting.textToBinary('والذينَ');

    expect(binary, "${faaelun.value}${fa.value}");
  });

  test("The prosody of word لِلذينَ is same as ${faaelun.name} ${fa.name}", () {
    String binary = ProsodyWriting.textToBinary('لِلذينَ');

    expect(binary, "${faaelun.value}${fa.value}");
  });

  test(
    "The prosody of word الرحمنُ is same as ${tf('فَعلُن')} ${tf('فَعلُن')}",
    () {
      String binary = ProsodyWriting.textToBinary('الرحمنُ');

      expect(binary, "${falun.value}${falun.value}");
    },
  );

  test("The prosody of word هذا is same as ${tf('فَعلُن')}", () {
    String binary = ProsodyWriting.textToBinary('هذا');

    expect(binary, tf('فَعلُن').value);
  });

  test(
    "The prosody of word هذا الذي is same as ${tf('فَعلُن')} ${tf('فَعَل')}",
    () {
      String binary = ProsodyWriting.textToBinary('هذا الذي');

      expect(binary, tf('فَعلُن').value + tf('فَعَل').value);
    },
  );

  test("The prosody of word لكِنَّنِي is same as ${tf('مُستَفعِلُن')}", () {
    String binary = ProsodyWriting.textToBinary('لكِنَّنِي');

    expect(binary, tf('مُستَفعِلُن').value);
  });
}
