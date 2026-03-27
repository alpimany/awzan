import 'package:awzan/core/parser/ast.dart';
import 'package:awzan/core/parser/constants.dart';
import 'package:awzan/core/rules/rules.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_chunk.dart';

var alawakher = {
  "matcher": (RuleArgs a) => a.node.isEndOfWord(),
  "work": (RuleArgs a) {
    // This rule applies to letters that are before the end
    // of a word or the entire part of the baytt.
    // These letters can have tanween-fatha such in (مَعًا)
    // (Note the tanween being in a harf before the end of the word)
    // or waw-aljamaa'ah followed by alif such in (قالُوا)

    // At the end of word a lot of things can happen.
    // The saken will be maksoor if followed by alif al-wasl,
    // unless the saken is a voel or waw-aljamaa'ah
    // because in that case, it should be omitted instead.
    // (e.g قالُوا الحق will be قالُلحق, and قالَت الحق will be قالَتِلحَق)

    Node qafyah = a.node;
    Node? asSabek = qafyah.parent;

    var next = qafyah.nextHarf();

    bool isWawAljamaaah = qafyah.value == "ا" && asSabek?.value == "و";

    bool isMawsool = next != null && next.isAlifWasl();
    // Al rawy is the last harf in the part of the verse
    // which means it has no child.
    // It tends to form ish-baa'
    // (e.g يُحاوِلُ will become يُحَاوِلُو)
    bool isRawy = qafyah.child == null;

    // print("Node: ${qafyah.value} is at eow");

    String value = "";
    bool combined = false; // did we use the previous and the qafeyah?

    if (isWawAljamaaah) {
      // Waw al jamaa'ah as in قالُوا
      // consists of two letters (وا) both of them are saken
      // if the waw is mawsolah as in (قالُوا ارجِع)
      // then it shall not be written
      // it will be (قالُرْجِع) note the waw and the alif, gone.

      value = isMawsool ? "" : "و";
    }

    if (qafyah.hasShaddah()) {
      // Here we add the saken of the mushaddad
      // Then we determine what we do will the other harakah
      // in the next lines
      value = "${qafyah.value}";

      // But we will add fatha in case that it has no other harakah
      // (e.g عَدّ will treat it as عَدَّ)
      // We will do this unless this is a harf or al rawy
      // because there could be sakenan
      if (qafyah.harakah!.value == shaddah) {
        if (!isRawy) {
          value += "${qafyah.value}$fatha";
        }
      }
    }

    if (asSabek != null &&
        asSabek.isMunawwan() &&
        (asSabek.hasTanweenFath() || qafyah.hasTanweenFath()) &&
        (qafyah.value == "ا" || qafyah.value == "ى")) {
      if (asSabek.hasShaddah()) {
        value = "${asSabek.value}";
      }

      value += "${asSabek.value}$fathaن${isMawsool ? kasrah : ''}";
      combined = true;
    }

    if (qafyah.hasTanween()) {
      if (qafyah.hasTanweenFath() &&
          (qafyah.value == "ا" || qafyah.value == "ى")) {
        value += "${asSabek!.value}$fathaن${isMawsool ? kasrah : ''}";
        combined = true;
      } else {
        String tanween = [
          tanweenDham,
          tanweenKasr,
          tanweenFath,
        ].firstWhere((el) => qafyah.harakah!.value!.contains(el));

        value +=
            "${qafyah.value}${switch (tanween) {
              tanweenDham => dammah,
              tanweenKasr => kasrah,
              tanweenFath => fatha,
              _ => '',
            }}ن${isMawsool ? kasrah : ''}";
      }
    }

    // Sometimes it's okay to write shaddah without another harakah
    // But we will assume it's a fatha, anyway.
    if (qafyah.hasHarakah()) {
      String harakah = [
        dammah,
        kasrah,
        fatha,
      ].firstWhere((el) => qafyah.harakah!.value!.contains(el));

      if (qafyah.isHaa() && !(asSabek?.isSaken() ?? false)) {
        value += "${qafyah.value}$harakah${isMawsool ? '' : 'ي'}";
      } else {
        value += "${qafyah.value}$harakah";
        if (isRawy) {
          value += switch (harakah) {
            dammah => "و",
            kasrah => "ي",
            fatha => "ا",
            _ => '',
          };
        }
      }
    }

    if (qafyah.isSaken()) {
      value = "${qafyah.value}";
      var next = qafyah.nextHarf();
      if (!isRawy && next != null && next.isAlifWasl()) {
        if (qafyah.parent!.value == "ه") {
          value += dammah;
        } else {
          value += kasrah;
        }
      }
    }

    return RuleResult(
      next: next,
      writing: combined
          ? PChunk.combine(asSabek!, qafyah, value)
          : PChunk.fromValue(qafyah, value),
    );
  },
};
