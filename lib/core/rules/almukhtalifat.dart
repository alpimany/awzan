import 'package:awzan/core/parser/ast.dart';
import 'package:awzan/core/parser/constants.dart';
import 'package:awzan/core/rules/alawakher.dart';
import 'package:awzan/core/rules/rules.dart';
import 'package:awzan/core/rules/specials.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_chunk.dart';

final almukhtalifat = [
  {
    "matcher": (RuleArgs a) => a.node.nextHarf()?.isWawAlJamaaAh() ?? false,
    "work": (RuleArgs a) {
      Node? afterAlif = a.node.nthChild(2)?.nextHarf();
      String suffix = afterAlif != null && afterAlif.isAlifWasl() ? "" : "و";

      return RuleResult(
        next: a.node.nthChild(3),
        writing: PChunk(
          value: "${a.node.value}$dammah$suffix",
          from: a.node.pos,
          extent: 2,
        ),
      );
    },
  },
  {
    "matcher": (RuleArgs a) =>
        (a.node.nthChild(2)?.isStartOfMuarraf() ?? false) &&
        (a.node.isStartOfSequence('الله') || a.node.isStartOfSequence('لله')),
    "work": (RuleArgs a) {
      bool withAlif = a.node.isStartOfSequence('الله');
      Node haa = withAlif ? a.node.nthChild(3)! : a.node.nthChild(2)!;
      bool isBegining = a.node.parent == null;
      bool isLast = haa.isEndOfWord();

      String suffix = "";

      if (isLast) {
        var alawakherResult =
            alawakher['work']!(
                  RuleArgs(
                    node: Node(
                      type: .harf,
                      pos: 0,
                      value: haa.value,
                      harakah: haa.harakah,
                      child: haa.child,
                      parent: Node(type: .harf, pos: 0, value: "ا"),
                    ),
                  ),
                )
                as RuleResult;

        suffix = alawakherResult.writing.value;
      } else {
        suffix = "ه${haa.value}";
      }

      return RuleResult(
        next: haa.child,
        writing: PChunk(
          value:
              '${withAlif
                  ? isBegining
                        ? "أَللَا"
                        : "للَا"
                  : "ل${a.node.harakah?.value ?? fatha}للَا"}$suffix',
          from: a.node.pos,
          extent: (haa.pos - a.node.pos) + PChunk.getExtent(haa),
        ),
      );
    },
  },
  {
    "matcher": (RuleArgs a) =>
        (a.node.nthChild(2)?.isStartOfMuarraf() ?? false) &&
        Specials.muarraf.any(
          (el) => a.node.nthChild(2)!.makesWord(el.substring(2)),
        ),
    "work": (RuleArgs a) {
      return Specials.tryParseMuarraf(a.node);
    },
  },
  {
    "matcher": (RuleArgs a) =>
        !(a.node.nthChild(2)?.isStartOfMuarraf() ?? false) &&
        Specials.ghairMuarraf.any((el) => a.node.makesWord(el)),
    "work": (RuleArgs a) {
      return Specials.tryParseGhairMuarraf(a.node);
    },
  },

  {
    "matcher": (RuleArgs a) =>
        Specials.ghairMuhaddad.any((el) => a.node.isStartOfSequence(el)),
    "work": (RuleArgs a) {
      return Specials.tryParseGhairMuhaddad(a.node);
    },
  },
];
