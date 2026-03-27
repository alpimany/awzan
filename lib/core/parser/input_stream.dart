class InputStream {
  InputStream({required this.text});

  final String text;

  late int _pos = 0;

  // ignore: unnecessary_string_escapes
  final String _eofChar = '\0';

  String next() {
    String n = peek();
    _pos += 1;

    return n;
  }

  String peek() {
    if (text.length <= _pos) {
      return _eofChar;
    }

    return text[_pos];
  }

  bool eof() {
    return peek() == _eofChar;
  }

  String read(bool Function(String) predicate) {
    String temp = "";

    while (!eof() && predicate(peek())) {
      temp += next();
    }

    return temp;
  }

  int getPos() {
    return _pos;
  }
}
