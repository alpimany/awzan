import 'package:awzan/core/parser/ast.dart';
import 'package:awzan/core/parser/constants.dart';
import 'package:awzan/core/rules/rules.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_chunk.dart';

var almuharrakat = {
  "matcher": (RuleArgs a) =>
      a.node.nextHarf() != null && a.node.nextHarf()!.isVowel(),
  "work": (RuleArgs a) {
    Node harf = a.node;
    // This rule applies to letters that are a parent of a vowel letter.
    // They will have harakah based on what vowel is there

    // ATTENTION: There's no simple way to differentiate between vowels
    // and original harf in a word, and if we add the corresponding harakah to a vowle
    // we could end up adding it to a saken, for example the word (أَبيَض)
    // the yaa here isn't vowel and it's not simple to find out if it's vowel
    // and if we consider the yaa a vowel then we will add kasrah to the baa
    // while it should be saken per the word's pronuncation
    // hence, we should not add harakah for each vowel, instead let the user
    // speceify, and we will only add harakah for alif as it is a strong vowel

    Node vowel = harf.nextHarf()!;

    // The vowel will be omitted if it is followd
    // by alif alwasl
    // such as in أرى النَّاسَ it will be أرَلننَاسَ
    var afterVowel = vowel.nextHarf();
    bool isMushaddad = harf.isMushaddad();

    bool isVowelMushaddad = vowel.isMushaddad();
    bool isVowelMunawwan = vowel.isMunawwan();

    bool omitted =
        vowel.isSaken() && (afterVowel != null && afterVowel.isAlifWasl());
    // but if after this vowel there's an alif and it's not alif alwasl
    // then it's alif waw al jamaa'ah such as in قالُوا
    // this alif shouldn't be in the prosody writing
    // bool hasAlifWawAljamaaah = (afterVowel?.isAlifWawAlJamaaAh() ?? false);

    // print(
    //   "Node: ${harf.value} that is a child of ${harf.parent?.value} and parent of ${harf.child?.value} is muharrak",
    // );

    String harakah = harf.harakah != null
        ? [dammah, kasrah, fatha].firstWhere(
            (el) => harf.harakah!.value!.contains(el),
            orElse: () => fatha,
          )
        : fatha;

    // But there's an exception
    // Some vowels should not change the current harakah,
    // all of them expect alif (ا، ى)
    if (vowel.value != 'ا' && vowel.value != 'ى') {
      harakah = switch (vowel.value) {
        'ي' => kasrah,
        'و' => dammah,
        _ => '',
      };
    }

    String value = isMushaddad ? "${harf.value}${harf.value}" : harf.value!;

    // if it's mushaddad or munawwan keep it for the other rules to deal with it
    // and if it's omitted, then skip it
    return RuleResult(
      next: (isVowelMushaddad || isVowelMunawwan) ? vowel : vowel.child,
      writing: (isVowelMushaddad || isVowelMunawwan)
          ? PChunk.fromValue(harf, '$value$harakah')
          : PChunk.combine(
              harf,
              vowel,
              '$value$harakah${omitted ? '' : "${vowel.value}${vowel.harakah?.value ?? ""}"}',
            ),
    );
  },
};
