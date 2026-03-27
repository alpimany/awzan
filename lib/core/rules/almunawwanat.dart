import 'package:awzan/core/parser/ast.dart';
import 'package:awzan/core/parser/constants.dart';
import 'package:awzan/core/rules/rules.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_chunk.dart';

var almunawwanat = {
  "matcher": (RuleArgs a) => !a.node.isEndOfWord() && a.node.isMunawwan(),
  "work": (RuleArgs a) {
    Node harf = a.node;
    // This rule applies to letters that has tanween
    // and are not at the end of the word (e. g مَعًا)
    // the end is alif, and the tanween is at the ain

    // print(
    //   "Node: ${harf.value} that is a child of ${harf.parent!.value} is munawwan",
    // );

    // Note: words such as (جازِياً) has a voel (ي)
    // This voel will be skipped because it will give
    // harakah for (ز) per other rules then will be omitted
    // hence we will have only alif with fatha
    // another rule can deal with this alif
    // it should check the previous letter and determine what to do

    // here we can only deal with tanween al fath
    // but others, if they are not at the end
    // we can't process them, but instead
    // we can fallback to a normal harakah

    // There's another harf since this is not the end of the word
    Node next = harf.nextHarf()!;

    // We can treat it as tanween alfath if only it's child is alif (ا, ى)
    if ((harf.hasTanweenFath() || next.hasTanweenFath()) &&
        (next.value == "ا" || next.value == "ى")) {
      bool mushaddad = harf.hasShaddah() || next.hasShaddah();

      Node? afterAlif = next.nextHarf();
      bool isMawsool = afterAlif != null && afterAlif.isAlifWasl();

      return RuleResult(
        next: afterAlif,
        writing: PChunk.combine(
          harf,
          next,
          "${mushaddad ? '${harf.value}${harf.value}' : harf.value}$fathaن${isMawsool ? kasrah : ''}",
        ),
      );
    } else {
      // We should only take the first tanween, and negelect the others,
      // because a user can mistakenly input the tanween twice

      String tanween = [
        tanweenDham,
        tanweenKasr,
        tanweenFath,
      ].firstWhere((el) => harf.harakah!.value!.contains(el));

      return RuleResult(
        next: next,
        writing: PChunk.fromValue(
          harf,
          "${harf.value}${switch (tanween) {
            tanweenDham => dammah,
            tanweenKasr => kasrah,
            tanweenFath => fatha,
            _ => '',
          }}",
        ),
      );
    }
  },
};
