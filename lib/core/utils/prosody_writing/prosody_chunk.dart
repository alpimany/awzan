import 'package:awzan/core/parser/ast.dart';

class PChunk {
  PChunk({required this.from, required this.extent, required this.value});

  final int from;
  final int extent;
  final String value;

  static PChunk empty() => PChunk(from: 0, extent: 0, value: "");

  static PChunk make(Node node) => PChunk(
    from: node.pos,
    extent: _extent(node),
    value: "${node.value}${node.harakah?.value ?? ""}",
  );

  static PChunk fromValue(Node node, String value) =>
      PChunk(from: node.pos, extent: _extent(node), value: value);

  static PChunk combine(Node a, Node b, String value) =>
      PChunk(from: a.pos, extent: _extent(a) + _extent(b), value: value);

  static PChunk fromHarfOnly(Node node) =>
      PChunk(from: node.pos, extent: _len(node), value: node.value ?? "");

  static int _extent(Node node) =>
      ((node.harakah != null) ? _len(node.harakah) : 0) + _len(node);

  static int _len(Node? node) => node?.value?.length ?? 0;

  Map toJson() => {"from": from, "extent": extent, "value": value};
}
