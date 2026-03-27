import 'package:flutter_test/flutter_test.dart';
import 'package:awzan/core/parser/ast.dart';
import 'package:awzan/core/tafaeel/tafaeel.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_writing.dart';

void main() {
  test("The alif in word بِاسمِ is not vowel", () {
    var ast = Ast(input: "بِاسمِ");

    Node alif = ast.parse()!.child!;

    expect(false, alif.isVowel());
  });

  test("Each alif in word حاجاتٌ is vowel", () {
    var ast = Ast(input: "حاجاتٌ");

    Node alif = ast.parse()!.child!;
    bool isVowel = alif.isVowel();

    expect(true, isVowel);
  });

  test("The yaa in word أراوِي is vowel", () {
    var ast = Ast(input: "أراوِي");

    Node yaa = ast.parse()!.nthChild(4)!;

    expect(true, yaa.isVowel());
  });

  test("The waw in word قالُوا is vowel and the alif is not", () {
    var ast = Ast(input: "قالُوا");

    Node waw = ast.parse()!.nthChild(3)!;
    Node alif = waw.child!;

    expect(true, waw.isVowel());
    expect(false, alif.isVowel());
  });

  test("The alif in word سِواكُم is vowel and the waw is not", () {
    var ast = Ast(input: "سِواكُم");

    Node waw = ast.parse()!.child!;
    Node alif = waw.child!;

    expect(true, alif.isVowel());
    expect(false, waw.isVowel());
  });

  test("The waw in الحاجاتُ واللَّيْلُ is not waw aljamaa'ah", () {
    var ast = Ast(input: "الحاجاتُ واللَّيْلُ");

    Node waw = ast.parse()!.nthChild(8)!;

    expect(false, waw.isWawAlJamaaAh());
  });

  test("The prosody of قالوا is same as ${tf('فَعلُن')}", () {
    String binary = ProsodyWriting.textToBinary("قالُوا");

    expect(binary, tf('فَعلُن').value);
  });

  test("The prosody of مَطِيِّكُم is same as ${tf('مَفاعِلُن')}", () {
    String binary = ProsodyWriting.textToBinary("مَطِيِّكُم");

    expect(binary, tf('مَفاعِلُن').value);
  });

  test("The yaa in لَأَمْيَلُ is not a vowel", () {
    var ast = Ast(input: "أَمْيَلُ");

    Node yaa = ast.parse()!.nthChild(2)!;

    expect(false, yaa.isVowel());
  });
}
