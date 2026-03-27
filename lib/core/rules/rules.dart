import 'package:awzan/core/parser/ast.dart';
import 'package:awzan/core/rules/alawakher.dart';
import 'package:awzan/core/rules/albawade.dart';
import 'package:awzan/core/rules/almawsolat.dart';
import 'package:awzan/core/rules/almuharrakat.dart';
import 'package:awzan/core/rules/almukhtalifat.dart';
import 'package:awzan/core/rules/almunawwanat.dart';
import 'package:awzan/core/rules/almushaddadat.dart';
import 'package:awzan/core/utils/prosody_writing/prosody_chunk.dart';

List<Map> rules = [
  ...almukhtalifat,
  almawsolat,
  almunawwanat,
  almuharrakat,
  albawade,
  alawakher,
  almushaddadat,
];

class RuleArgs {
  RuleArgs({required this.node, this.isMawsool = false});

  final Node node;
  final bool isMawsool;
}

class RuleResult {
  RuleResult({
    required this.next,
    required this.writing,
    this.isMawsool = false,
  });

  final Node? next;
  final PChunk writing;
  final bool isMawsool;
}

Node? harakah(Node node) => node.harakah;
