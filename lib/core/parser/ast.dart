import 'package:awzan/core/parser/constants.dart';
import 'package:awzan/core/parser/input_stream.dart';
import 'package:awzan/core/parser/token_stream.dart';

class Ast {
  Ast({required this.input});

  final String input;
  late Node? parent;
  late TokenStream stream;

  Node? parse() {
    stream = TokenStream(InputStream(text: input));
    parent = null;

    return _tryReadChild();
  }

  Node? _tryReadChild() {
    if (stream.eof()) {
      return null;
    } else {
      final token = stream.next();
      late Node? node;
      if (token?.type == "Harf") {
        node = Node(
          type: .harf,
          value: token!.value,
          parent: parent,
          pos: token.pos,
          harakah: _tryParseHarakah(),
        );
      } else if (token?.type == "Masafah") {
        node = Node(type: .masafah, parent: parent, pos: token!.pos);
      } else {
        node = _tryReadChild();
      }

      parent = node;
      if (node != null) node.child = _tryReadChild();

      return node;
    }
  }

  Node? _tryParseHarakah() {
    final token = stream.peek();

    if (token?.type == "Harakah") {
      final harakah = Node(type: .harakah, value: token!.value, pos: token.pos);

      stream.next();

      return harakah;
    } else {
      return null;
    }
  }
}

class Node {
  Node({
    required this.type,
    this.child,
    this.parent,
    required this.pos,
    this.value = "",
    this.harakah,
  });

  NodeType type;
  String? value;
  int pos;
  Node? harakah;
  Node? child;
  Node? parent;

  Map toJson() {
    Map json = {"type": type.toString()};

    if (type == NodeType.harakah) {
      json.addAll({"value": value});
    }

    if (type == NodeType.harf) {
      json.addAll({"value": value, "harakah": harakah, "child": child});
    }

    if (type == NodeType.masafah) {
      json.addAll({"child": child});
    }

    return json;
  }

  Node? previousHarf() {
    Node? current = this;

    while (current != null) {
      current = current.parent;

      if (current != null && current.type == .harf) break;
    }

    return current;
  }

  Node? nextHarf() {
    Node? current = this;

    while (current != null) {
      current = current.child;

      if (current != null && current.type == .harf) break;
    }

    return current;
  }

  bool isMasafah() => type == .masafah;

  bool isVowel() {
    // The vowel is one of (ا، و، ي، ى)
    // The vowel must be preceded by a letter
    // and not preceded by al t'rif (ال) or (لل)
    // The vowel is saken
    Node? previous = previousHarf();
    if (previous == null ||
        parent!.isMasafah() ||
        !isOneOfVowels() ||
        isStartOfMuarraf() ||
        !isSaken()) {
      return false;
    }

    // Alif (ا، ى) is most likely a vowel because it is strong
    // others depend on the harakah of the previous harf
    if (value == 'ا' || value == 'ى') {
      // Tanween al fath will prevent alif from working as a vowel,
      // so check for it, and check if the alif isn't alif al wasl
      if (!previous.isMunawwanBelFath()) {
        // at this point alif maqsorah is always a vowel
        if (value == 'ى') return true;
        // for alif (ا)
        if (!(isAlifWasl() || isAlifWawAlJamaaAh())) return true;

        return false;
      }

      return false;
    } else {
      String requiredHarakah = switch (value) {
        'و' => dammah,
        _ => kasrah, // ي
      };

      return previous.harakah?.value?.contains(requiredHarakah) ?? false;
    }
  }

  bool isMushaddad() {
    if (isShamsy() && child != null) {
      // Some letters after lam shamseyyah always has a shaddah
      // The lam shamseyyah comes in two forms, (ال) and (لل)
      // And what makes it shamseyyah is the letter after it
      // The letters are determined by isShamsy()

      var lam = parent;
      if (lam != null && lam.isLam() && lam.isSaken()) {
        // So here we have a lam, and it can be shamseyyah
        // if it's a part of al ta'rif (ال) or a part
        // of two lams that do the same work of al ta'rif

        var beforeLam = lam.parent;
        if (beforeLam != null) {
          // Note: in (لل) the first lam must be mutaharrekah
          // and the other is sakenah, but it can be sakenah
          // if it's child is alif alwasl so it's a part of (ال)
          if ((beforeLam.isLam() && beforeLam.isSaken()) ||
              beforeLam.isAlifWasl()) {
            return true;
          }
        }
      }
    }

    if (hasShaddah()) {
      return true;
    }

    return false;
  }

  bool isStartOfMuarraf() {
    Node? lam = parent;
    Node? beforeLam = lam?.parent;

    if (beforeLam == null) return false;

    /*     

    bool conditionA = (lam != null && lam.isLam());
    bool conditionB =
        ((lam!.isSaken() && beforeLam.isAlifWasl()) || beforeLam.isLamTarif());

    if (conditionA && conditionB) {
      return true;
    }

    return false; */

    return beforeLam.isAlifTarif() || beforeLam.isLamTarif();
  }

  bool isMunawwan() {
    if (hasTanween()) {
      return true;
    }

    if (harakah == null ||
        harakah?.value == sukoon ||
        harakah?.value == shaddah) {
      if (child != null &&
          child!.hasTanweenFath() &&
          (child!.value == "ا" || child!.value == "ى")) {
        return true;
      }
    }

    return false;
  }

  bool isMunawwanBelFath() {
    if (hasTanweenFath()) {
      return true;
    }

    if (harakah == null || harakah!.value == sukoon) {
      if (child != null &&
          child!.hasTanweenFath() &&
          (child!.value == "ا" || child!.value == "ى")) {
        return true;
      }
    }

    return false;
  }

  bool isStartOfSequence(String sequence) {
    Node? n = this;
    String joins = "";

    while (n != null && joins.length < sequence.length) {
      if (n.isMasafah()) {
        n = n.child;
      } else {
        joins += n.value ?? '';
        n = n.child;
      }
    }

    return joins.compareTo(sequence) == 0;
  }

  bool makesWord(String word) {
    Node? n = this;
    String joins = "";

    while (n != null && !n.isMasafah()) {
      joins += n.value ?? '';
      n = n.child;
    }

    bool result = joins.compareTo(word) == 0;

    return result;
  }

  bool isShamsy() => [
    'ت',
    'ث',
    'د',
    'ذ',
    'ر',
    'ز',
    'س',
    'ش',
    'ص',
    'ض',
    'ط',
    'ظ',
    'ن',
    'ل',
  ].contains(value);

  bool isOneOfVowels() => ['ا', 'ى', 'و', 'ي'].contains(value);

  bool isMutaharrek() => hasHarakah() || (child != null && child!.isVowel());
  bool isEndOfWord() => child == null ? true : child!.isMasafah();
  bool isStartOfWord() => parent == null || parent!.isMasafah();

  bool isLam() => value == 'ل';
  bool isAlifWasl() {
    if (value != 'ا') return false;

    Node? n = nextHarf();

    return (n != null) &&
        !(n.isAlifWawAlJamaaAh() || n.isAlifTarif()) &&
        (n.isSaken() || n.hasShaddah());
  }

  bool isAlifTarif() {
    var afterAlif = nextHarf();
    return value == "ا" &&
        afterAlif != null &&
        afterAlif.isLam() &&
        (afterAlif.harakah == null ||
            afterAlif.harakah!.value == sukoon ||
            // There are special case for
            // الَّذي، الَّذين، الَّتي
            // The lam can have a shaddah
            [
              'ذين',
              'تي',
              'ذي',
            ].any((el) => afterAlif.child?.makesWord(el) ?? false));
  }

  bool isLamTarif() {
    var afterLam = nextHarf();
    return isLam() &&
        afterLam != null &&
        afterLam.isLam() &&
        (afterLam.harakah == null || afterLam.harakah!.value == sukoon);
  }

  bool isWawAlJamaaAh() {
    return value == 'و' && (nextHarf()?.isAlifWawAlJamaaAh() ?? false);
  }

  bool isAlifWawAlJamaaAh() {
    if (value != "ا") return false;

    Node? previous = previousHarf();

    // in سِواكُم
    // The alif is alif mad' and it should be written
    // the difference betweem قالُوا and سِواكُم
    // is that, in the first, after the last alif, there's a masafah or null
    // so make sure there's a masafah or nothing, otherwise it's not
    // alif waw aljamaa'ah

    if (previous?.value == "و" && (child?.isMasafah() ?? true)) {
      return true;
    }

    return false;
  }

  bool isMeemAljama() {
    return isMeem() &&
        parent != null &&
        (parent!.isHaa() || parent!.isKaf()) &&
        parent!.harakah?.value == dammah;
  }

  bool isEii() => value == 'إ';
  bool isHaa() => value == 'ه';
  bool isMeem() => value == 'م';
  bool isKaf() => value == 'ك';
  bool isWaw() => value == 'و';
  bool isRaa() => value == 'ر';

  bool hasTanweenFath() =>
      harakah != null && harakah!.value!.contains(tanweenFath);

  bool isSaken() {
    // this applies for huroof only
    if (type != .harf) return false;

    // The saken is any letter that we stop in it while reading
    // If the letter has a sukoon then it is saken
    if (harakah != null) {
      if (harakah!.value == sukoon) return true;

      return false;
    } else {
      // if it doesn't have a harakah, then this isn't the end
      // The letter can still be muharrak
      // if it's parent is vowel
      // (e. g حاجاتٌ the jeem is muharrakh without harakah)
      // or if it's parent is munawwan bel fath
      // (e. g شُعاعاً)
      // or if it's at the end of the word
      return isEndOfWord() || !(isMunawwanBelFath() || child!.isVowel());
    }
  }

  bool hasTanween() =>
      harakah != null &&
      [
        tanweenDham,
        tanweenKasr,
        tanweenFath,
      ].any((el) => harakah!.value!.contains(el));

  bool hasHarakah() =>
      harakah != null &&
      [fatha, kasrah, dammah].any((el) => harakah!.value!.contains(el));

  bool hasShaddah() {
    return harakah != null && harakah!.value!.contains(shaddah);
  }

  Node? nthChild(int nth) {
    Node? currentChild = child;
    nth--;

    while (currentChild != null && (nth-- - 1) >= 0) {
      currentChild = currentChild.child;
    }

    return currentChild;
  }
}

enum NodeType { harf, harakah, masafah }
