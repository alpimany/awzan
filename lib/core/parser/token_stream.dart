import 'package:awzan/core/parser/input_stream.dart';

class TokenStream {
  TokenStream(InputStream inst) {
    _inst = inst;

    current = Token();
  }

  late InputStream _inst;
  late Token current;

  Token readnext() {
    if (_inst.eof()) {
      return Token();
    }

    String ch = _inst.peek();
    Token t = Token(type: "Unknown", value: ch, pos: _inst.getPos());

    if (isHarf(ch)) {
      readHarf(t);
    } else if (isHarakah(ch)) {
      readHarakah(t);
    } else if (isMasafah(ch)) {
      readMasafah(t);
    } else {
      _inst.next();
    }

    return t;
  }

  Token? next() {
    Token? tmp;

    if (!current.isEmpty()) {
      tmp = current;
      current = Token();
    } else {
      tmp = readnext();
    }

    return tmp;
  }

  Token? peek() {
    if (current.isEmpty()) {
      current = readnext();
    }

    return current;
  }

  bool eof() {
    var token = peek();
    return token == null || token.isEmpty();
  }

  bool isHarf(String ch) => ch != 'ـ' && RegExp(r'[ء-ي]').hasMatch(ch);

  bool isHarakah(String ch) =>
      RegExp(r'[\u0617-\u061A\u064B-\u0652]').hasMatch(ch);

  bool isMasafah(String ch) => ch.contains(RegExp(r'[ \n\r\t]'));

  void readHarf(Token t) {
    t.value = _inst.next();
    t.type = "Harf";
  }

  void readHarakah(Token t) {
    t.value = _inst.read((ch) => isHarakah(ch));
    t.type = "Harakah";
  }

  void readMasafah(Token t) {
    t.type = "Masafah";
    t.value = null;

    _inst.read((String ch) => isMasafah(ch));
  }
}

class Token {
  Token({this.type, this.value, this.pos = 0});

  late int pos;
  late String? type;
  late String? value;

  Map toJson() => {'type': type, 'value': value, 'pos': pos};

  bool isEmpty() => (type == null);
}
