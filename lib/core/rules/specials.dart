import 'package:awzan/core/parser/ast.dart';
import 'package:awzan/core/parser/constants.dart';
import 'package:awzan/core/rules/alawakher.dart';
import 'package:awzan/core/rules/rules.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_chunk.dart';

class Specials {
  static List<String> muarraf = ["الذي", "الذين", "التي", "الرحمن"];
  static List<String> ghairMuarraf = [
    "هذا",
    "هذه",
    "هذي",
    "هؤلاء",
    "هذان",
    "عمرو",
    "أولي",
  ];
  static List<String> ghairMuhaddad = ["رحمن", 'آ', "لكن", "إله"];

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
        'عمرو' => _parseAmru(node),
        'أولي' => _parseOule(node),
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

  static RuleResult? _parseAmru(Node? node) {
    Node raa = node!.child!.child!;

    // We should omit the waw but changing the children
    raa.child = raa.child?.child;

    var alawakherResult = alawakher['work']!(RuleArgs(node: raa)) as RuleResult;

    return RuleResult(
      next: raa.child,
      writing: PChunk(
        value: "عَم${alawakherResult.writing.value}",
        from: node.pos,
        extent: (raa.pos - node.pos) + PChunk.getExtent(raa),
      ),
    );
  }

  static RuleResult? _parseOule(Node? node) {
    Node waw = node!.child!;
    Node yaa = waw.child!.child!;
    Node? next = yaa.nextHarf();

    bool isMawsool = next?.isAlifWasl() ?? false;

    if (!waw.isSaken()) {
      return RuleResult(next: waw, writing: PChunk.make(node));
    }

    return RuleResult(
      next: next,
      writing: PChunk(
        value: "أُلِ${isMawsool ? '' : 'ي'}",
        from: node.pos,
        extent: (yaa.pos - node.pos) + PChunk.getExtent(yaa),
      ),
    );
  }

  static RuleResult _parseLaken(Node node) {
    Node kaf = node.child!;

    if (kaf.harakah != null && kaf.harakah?.value != kasrah) {
      return RuleResult(next: kaf, writing: PChunk.make(node));
    }

    return RuleResult(
      next: kaf.child,
      writing: PChunk(
        value: "لَاكِ",
        from: node.pos,
        extent: (kaf.pos - node.pos) + PChunk.getExtent(kaf),
      ),
    );
  }

  static RuleResult _parseIlah(Node node) {
    Node lam = node.child!;

    if (lam.harakah == null || lam.harakah!.value != fatha) {
      return RuleResult(next: lam, writing: PChunk.make(node));
    }

    return RuleResult(
      next: lam.child,
      writing: PChunk(
        value: "إِلَا",
        from: node.pos,
        extent: (lam.pos - node.pos) + PChunk.getExtent(lam),
      ),
    );
  }

  static RuleResult? tryParseGhairMuhaddad(Node? node) {
    if (node == null) return null;

    String special = ghairMuhaddad.firstWhere(
      (el) => node.isStartOfSequence(el),
      orElse: () => '',
    );

    if (special.isNotEmpty) {
      return switch (special) {
        'رحمن' => RuleResult(
          next: node.nthChild(3),
          writing: PChunk(
            value: "رَحمَا",
            from: node.pos,
            extent: node.nthChild(3)!.pos - node.pos,
          ),
        ),
        "لكن" => _parseLaken(node),
        "إله" => _parseIlah(node),
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
