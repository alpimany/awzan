import 'package:awzan/core/parser/ast.dart';
import 'package:awzan/core/parser/constants.dart';
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
    } else {
      // alif wasl or alif t'rif
      // alif being at the begining
      if (a.node.parent == null) {
        // At the begining, it's either (إ) or (أ)
        // It's (أ) only if the next harf is a lam with sukoon, or null
        // That's because they will form al-t'areef (ال)
        Node? afterAlif = a.node.nextHarf();
        if (afterAlif == null || (afterAlif.isLam() && afterAlif.isSaken())) {
          return RuleResult(
            next: afterAlif,
            writing: PChunk.fromValue(a.node, 'أ$fatha'),
          );
        } else {
          return RuleResult(
            next: afterAlif,
            writing: PChunk.fromValue(a.node, 'إ$kasrah'),
          );
        }
      } else {
        return RuleResult(
          next: a.node.child,
          // Here remains alif al wasl, and it's not written
          // (e. g قالَ الناسُ will be قالَنْناسُ without the alif)
          writing: PChunk.fromValue(a.node, ""),
        );
      }
    }
  },
};
