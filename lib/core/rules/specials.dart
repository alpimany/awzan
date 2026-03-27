import 'package:awzan/core/parser/ast.dart';
import 'package:awzan/core/parser/constants.dart';
import 'package:awzan/core/rules/rules.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_chunk.dart';

class Specials {
  static List<String> muarraf = ["الذي", "الذين", "التي", "الرحمن"];
  static List<String> ghairMuarraf = ["هذا", "هذه", "هذي", "هؤلاء", "هذان"];
  static List<String> ghairMuhaddad = ["رحمن", "لكن", 'آ'];

  static RuleResult? tryParseMuarraf(Node? node) {
    if (node == null) return null;

    String special = muarraf.firstWhere(
      (el) => node.nthChild(2)!.makesWord(el.substring(2)),
      orElse: () => '',
    );

    bool isLamTarif = node.isLamTarif();
    bool isBegining = node.parent == null;

    String prefixQamary = isLamTarif
        ? 'ل${node.harakah?.value ?? fatha}للَ'
        : isBegining
        ? 'أَللَ'
        : 'للَ';

    String prefixShamsy = isLamTarif
        ? 'ل${node.harakah?.value ?? fatha}'
        : isBegining
        ? 'أَ'
        : '';

    if (special.isNotEmpty) {
      return switch (special) {
        'الذين' => RuleResult(
          next: node.nthChild(4),
          writing: PChunk(
            value: "$prefixQamaryذِي",
            from: node.pos,
            extent: node.nthChild(4)!.pos - node.pos,
          ),
        ),
        'الذي' || 'التي' => RuleResult(
          next: node.nthChild(3),
          writing: PChunk(
            value: "$prefixQamary${node.child!.child!.value}$kasrah",
            from: node.pos,
            extent: node.nthChild(3)!.pos - node.pos,
          ),
        ),
        'الرحمن' => RuleResult(
          next: node.nthChild(5),
          writing: PChunk(
            value: "$prefixShamsyررَحمَا",
            from: node.pos,
            extent: node.nthChild(5)!.pos - node.pos,
          ),
        ),
        _ => null,
      };
    }

    return null;
  }

  static RuleResult? tryParseGhairMuarraf(Node? node) {
    if (node == null) return null;

    String special = ghairMuarraf.firstWhere(
      (el) => node.makesWord(el),
      orElse: () => '',
    );

    if (special.isNotEmpty) {
      return switch (special) {
        'هذا' || 'هذه' => RuleResult(
          next: node.child,
          writing: PChunk(
            value: "هَا",
            from: node.pos,
            extent: node.child!.pos - node.pos,
          ),
        ),
        _ => RuleResult(
          next: node.child,
          writing: PChunk(
            value: "${node.value}$fathaا",
            from: node.pos,
            extent: node.child!.pos - node.pos,
          ),
        ),
      };
    }

    return null;
  }

  static RuleResult? tryParseGhairMuhaddad(Node? node) {
    if (node == null) return null;

    String special = ghairMuhaddad.firstWhere(
      (el) => node.isStartOfSequence(el),
      orElse: () => '',
    );

    if (special.isNotEmpty) {
      return switch (special) {
        'لكن' => RuleResult(
          next: node.nthChild(2),
          writing: PChunk(
            value: "لَاكِ",
            from: node.pos,
            extent: node.nthChild(2)!.pos - node.pos,
          ),
        ),
        'رحمن' => RuleResult(
          next: node.nthChild(3),
          writing: PChunk(
            value: "رَحمَا",
            from: node.pos,
            extent: node.nthChild(3)!.pos - node.pos,
          ),
        ),
        'آ' => RuleResult(
          next: node.child,
          writing: PChunk(
            value: "ءَا",
            from: node.pos,
            extent: node.child!.pos - node.pos,
          ),
        ),
        _ => null,
      };
    }

    return null;
  }
}
