import 'package:awzan/core/parser/ast.dart';
import 'package:awzan/core/buhoor.dart';
import 'package:awzan/core/parser/constants.dart';
import 'package:awzan/core/rules/rules.dart';
import 'package:awzan/core/tafaeel/tafaeel.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_chunk.dart';
import 'package:path/path.dart';

class ProsodyWriting {
  static Node? convertToAST(String text) {
    final ast = Ast(input: text);

    return ast.parse();
  }

  static List<(Bahar, List<Tafeelah>)> getMatchesForText(String text) {
    return findMatchesForBinary(textToBinary(text));
  }

  static String textToBinary(String text) {
    return prosodyToChunkedBits(
      textToProsody(text),
    ).fold("", (a, b) => "$a${b.value}");
  }

  static List<ProsodyError> validate(List<BitChunk> chunkedBits) {
    List<ProsodyError> errors = [];
    for (var (index, chunk) in chunkedBits.indexed) {
      var prev = (index - 1) > 0
          ? chunkedBits.elementAtOrNull(index - 1)
          : null;
      var next = (index + 1) < chunkedBits.length
          ? chunkedBits.elementAtOrNull(index + 1)
          : null;

      if (prev != null) {
        var len = prev.value.length;
        var joined = "${prev.value}${chunk.value}";

        if (joined.startsWith("00", len - 1) &&
            (next != null || (joined.length - len - 1 > 0))) {
          errors.add(
            ProsodyError(
              from: prev.pos + (prev.extent - 1),
              to: chunk.pos + 1,
              type: .twoSaken,
            ),
          );
        }
      }
    }

    return errors;
  }

  static List<PChunk> textToProsody(String text) {
    Node? node = convertToAST(text);
    List<PChunk> prosodyWriting = [];

    while (node != null) {
      if (node.type == .masafah) {
        node = node.child;
        continue;
      }

      final rule = getRuleForNode(node);
      if (rule.isNotEmpty) {
        RuleResult result = rule['work'](RuleArgs(node: node));

        node = result.next;
        prosodyWriting.add(result.writing);
      } else {
        prosodyWriting.add(PChunk.make(node));
        node = node.child;
      }
    }

    return prosodyWriting;
  }

  static Map getRuleForNode(Node node) {
    return rules.firstWhere((rule) {
      final dynamic matcher = rule['matcher'];

      return matcher(RuleArgs(node: node));
    }, orElse: () => {});
  }

  static List<BitChunk> prosodyToChunkedBits(List<PChunk> prosody) {
    List<BitChunk> binary = [];

    for (var chunk in prosody) {
      if (chunk.value.isEmpty) continue;

      List<String> chars = chunk.value.split("");
      String value = "";

      for (var (index, char) in chars.indexed) {
        if (_isHarakah(char) || char == sukoon) continue;

        String? next = chars.elementAtOrNull(index + 1);
        value += (next != null && _isHarakah(next)) ? "1" : "0";
      }

      binary.add(BitChunk(pos: chunk.from, extent: chunk.extent, value: value));
    }

    return binary;
  }

  static bool _isHarakah(String char) => switch (char) {
    fatha || kasrah || dammah => true,
    _ => false,
  };

  static List<(Bahar, List<Tafeelah>)> findMatchesForBinary(String binary) {
    final List<(Bahar, List<Tafeelah>)> matches = [];

    for (var bahar in buhoor) {
      for (var sowrah in bahar.sowar) {
        if (sowrah.fold("", (a, b) => a += b.value) == binary) {
          matches.add((bahar, sowrah));
        }
      }
    }

    return matches;
  }

  static String splitTextBasedOnTafaeel(String text, List<Tafeelah> tafaeel) {
    Node? node = convertToAST(text);
    String output = "";

    for (var tafeelah in tafaeel) {
      var len = tafeelah.value.length;

      while (node != null && len-- > 0) {
        final value = node.value;
        final harakah = node.harakah?.value ?? '';

        output += "$value$harakah";
        node = node.child;
      }

      output += " ";
    }

    return output;
  }

  static List<List<Tafeelah>> binaryToTafaeel(String binary) {
    List<List<Tafeelah>> checkPossibilities(int pos) {
      List<List<Tafeelah>> possibilities = [];
      for (var tafeelah in tafaeel) {
        if (binary.length - pos >= 4 &&
            [fa.name, faal.name].contains(tafeelah.name)) {
          continue;
        }

        if (binary.startsWith(tafeelah.value, pos)) {
          var nextPos = pos + tafeelah.value.length;
          var nextTafelat = checkPossibilities(nextPos);

          if (nextTafelat.isNotEmpty || nextPos == binary.length) {
            List<List<Tafeelah>> accepted = nextTafelat.isEmpty
                ? [
                    [tafeelah],
                  ]
                : List.generate(
                    nextTafelat.length,
                    (index) => [
                      tafeelah,
                      if (index < nextTafelat.length) ...nextTafelat[index],
                    ],
                  );

            possibilities.addAll(accepted);
          }
        }
      }
      return possibilities;
    }

    return checkPossibilities(0);
  }
}

class ProsodyError {
  ProsodyError({required this.from, required this.to, required this.type});

  final int from;
  final int to;
  final ProsodyErrorType type;

  Map toJson() => {"from": from, "to": to, "type": type.toString()};
}

enum ProsodyErrorType { twoSaken, fourMuharrakat }

class BitChunk {
  BitChunk({required this.pos, required this.extent, required this.value});

  final int pos;
  final int extent;
  final String value;
}
