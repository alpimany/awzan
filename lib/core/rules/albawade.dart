import 'package:awzan/core/parser/ast.dart';
import 'package:awzan/core/parser/constants.dart';
import 'package:awzan/core/rules/rules.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_chunk.dart';

var albawade = {
  "matcher": (RuleArgs a) => a.node.harakah == null && a.node.isStartOfWord(),
  "work": (RuleArgs a) {
    // This rule applies to all the letters
    // at the begining or after a masafah that has no harakah

    // Since no word starts with a (saken),
    // we need to consider adding a harakah
    // if only it doesn't have one
    // or else, leave it as it is.

    // But alif al-wasl is a different case.
    // It's either a (أ) such as in (الوَقتُ)
    // or an (إ) such as in (اختَر)
    // or it's a connecting letter that joins two words
    // were the alif will be omitted

    if (a.node.isAlifWasl()) {
      // We will deal with alif being at the begining only,
      // and in another rule we will deal with it being between two words.
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
      }
    } else {
      // Other letters
      // Harf eii (إ) has kasrah always
      if (a.node.isEii()) {
        return RuleResult(
          next: a.node.child,
          writing: PChunk.fromValue(a.node, 'إ$kasrah'),
        );
      } else {
        return RuleResult(
          next: a.node.child,
          writing: PChunk.fromValue(a.node, '${a.node.value}$fatha'),
        );
      }
    }
  },
};
