import 'package:awzan/core/parser/constants.dart';
import 'package:awzan/core/rules/rules.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_chunk.dart';

var albawade = {
  "matcher": (RuleArgs a) =>
      a.node.harakah == null &&
      a.node.isStartOfWord()
      // Alif al-wasl is a different case.
      // It's either a (أ) such as in (الوَقتُ)
      // or an (إ) such as in (اختَر)
      // or it's a connecting letter that joins two words
      // were the alif will be omitted
      // So we will deal it with another rule
      &&
      !a.node.isAlifWasl(),

  "work": (RuleArgs a) {
    // This rule applies to all the letters
    // at the begining or after a masafah that has no harakah

    // Since no word starts with a (saken),
    // we need to consider adding a harakah
    // if only it doesn't have one
    // or else, leave it as it is.

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
  },
};
