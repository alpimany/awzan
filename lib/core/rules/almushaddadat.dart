import 'package:awzan/core/parser/constants.dart';
import 'package:awzan/core/rules/rules.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_chunk.dart';

var almushaddadat = {
  "matcher": (RuleArgs a) => a.node.isMushaddad(),
  "work": (RuleArgs a) {
    // This rule applies to letters that are supposed
    // to have a shaddah or they have one already

    String harakah = a.node.harakah != null
        ? [dammah, kasrah, fatha].firstWhere(
            (el) => a.node.harakah!.value!.contains(el),
            orElse: () => fatha,
          )
        : fatha;
    String value = a.node.value!;

    return RuleResult(
      next: a.node.child,
      writing: PChunk.fromValue(a.node, "$value$value$harakah"),
    );
  },
};
