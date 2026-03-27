import 'package:awzan/core/parser/ast.dart';
import 'package:awzan/core/rules/rules.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_chunk.dart';

var almawsolat = {
  "matcher": (RuleArgs a) => a.node.isAlifWasl() || a.node.isLamTarif(),
  "work": (RuleArgs a) {
    // This rule applies to words that start with alif alwasl.
    // They tend to connect with the previous word.
    // Also apllies to words that start with lam tarif
    // Because it comes as a replacement for the alif alwasl

    Node next = a.node.child!;

    if (next.isLam()) {
      bool isLamTarif = a.node.isLamTarif();
      bool isLamShamseyyah = next.child != null && next.child!.isShamsy();

      if (isLamShamseyyah) {
        return RuleResult(
          next: next.child,
          writing: PChunk.fromValue(
            a.node,
            isLamTarif ? "ل${a.node.harakah?.value}" : "",
          ),
        );
      } else {
        return RuleResult(
          next: next.child,
          writing: PChunk.fromValue(
            a.node,
            isLamTarif ? "ل${a.node.harakah?.value}ل" : "ل",
          ),
        );
      }
    }

    return RuleResult(
      next: a.node.child,
      // Here remains alif al wasl, and it's not written
      // (e. g قالَ الناسُ will be قالَنْناسُ without the alif)
      writing: PChunk.fromValue(a.node, ""),
    );
  },
};
