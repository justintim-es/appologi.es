import 'dart:convert';
import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';
import 'package:appologi_es/appologi_es.dart';
import 'package:appologi_es/models/gladiator.dart';

class ObstructionumNumerus extends Serializable {
  List<int>? numerus;
  Map<String, dynamic> asMap() => {'numerus': numerus};
  void readFromMap(Map<String, dynamic> map) {
    numerus = List<int>.from(map['numerus'] as List<dynamic>);
  }
}

class KeyPair {
  late String private;
  late String public;
  KeyPair() {
    final ec = getP256();
    final key = ec.generatePrivateKey();
    private = key.toHex();
    public = key.publicKey.toHex();
  }
}

class SubmittereRationem extends Serializable {
  String? publicaClavis;
  Map<String, dynamic> asMap() => {'publicaClavis': publicaClavis};
  void readFromMap(Map<String, dynamic> map) {
    publicaClavis = map['publicaClavis'].toString();
  }
  // SubmittereRationem.fromJson(Map<String, dynamic> jsoschon):
  // publicaClavis = jsoschon['publicaClavis'].toString();

  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object({"publicaClavis": APISchemaObject.string()});
  }
}

class SubmittereTransaction extends Serializable {
  String? from;
  String? to;
  BigInt? nof;

  Map<String, dynamic> asMap() => {
        'from': from,
        'to': to,
        'nof': nof,
      };
  // SubmittereTransaction(this.from, this.to, this.gla, this.unit);
  void readFromMap(Map<String, dynamic> map) {
    to = map['to'].toString();
    from = map['from'].toString();
    nof = BigInt.from(num.parse(map['nof'].toStringAsExponential() as String));
  }

  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object({
      "to": APISchemaObject.string(),
      "from": APISchemaObject.string(),
      "nof": APISchemaObject.number(),
    });
  }
}

class RemoveTransaction {
  final bool liber;
  final String transactionId;
  final String publicaClavis;
  RemoveTransaction(this.liber, this.transactionId, this.publicaClavis);
  RemoveTransaction.fromJson(Map<String, dynamic> jsoschon)
      : liber = jsoschon['liber'] as bool,
        transactionId = jsoschon['transactionId'].toString(),
        publicaClavis = jsoschon['publicaClavis'].toString();
}

class Confussus extends Serializable {
  int? index;
  String? gladiatorId;
  String? privateKey;
  Map<String, dynamic> asMap() =>
      {'index': index, 'gladiatorId': gladiatorId, 'privateKey': privateKey};
  void readFromMap(Map<String, dynamic> map) {
    index = int.parse(map['index'].toString());
    gladiatorId = map['gladiatorId'].toString();
    privateKey = map['privateKey'].toString();
  }

  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object({
      "index": APISchemaObject.string(),
      "gladiatorId": APISchemaObject.string(),
      "privateKey": APISchemaObject.string()
    });
  }
  // Confussus.fromJson(Map<String, dynamic> jsoschon):
  // index = int.parse(jsoschon['index'].toString()),
  // gladiatorId = jsoschon['gladiatorId'].toString(),
  // privateKey = jsoschon['privateKey'].toString();
}

// class FurcaConfussus extends Confussus {
//   List<int> numerus;
//   FurcaConfussus.fromJson(Map<String, dynamic> jsoschon):
//     numerus = List<int>.from(jsoschon['numerus'] as List<int>), super.fromJson(jsoschon);
// }
class TransactionInfo {
  final bool includi;
  final List<String> priorTxIds;
  final int? indicatione;
  final List<int>? obstructionumNumerus;
  final BigInt? confirmationes;
  TransactionInfo(this.includi, this.priorTxIds, this.indicatione,
      this.obstructionumNumerus, this.confirmationes);

  Map<String, dynamic> toJson() => {
        'includi': includi,
        'confirmationes': confirmationes.toString(),
        'priorTxIds': priorTxIds,
        'indicatione': indicatione,
        'obstructionumNumerus': obstructionumNumerus,
      };
}

class PropterInfo {
  final bool includi;
  final int index;
  final int? indicatione;
  final List<int>? obstructionumNumerus;
  final String? defensio;
  PropterInfo(this.includi, this.index, this.indicatione,
      this.obstructionumNumerus, this.defensio);

  Map<String, dynamic> toJson() => {
        'includi': includi,
        'index': index,
        'indicatione': indicatione,
        'obstructionumNumerus': obstructionumNumerus,
        'defensio': defensio,
      };
}

class Probationems extends Serializable {
  List<int>? firstIndex;
  List<int>? lastIndex;
  Probationems();

  Map<String, dynamic> asMap() =>
      {'firstIndex': firstIndex, 'lastIndex': lastIndex};
  void readFromMap(Map<String, dynamic> map) {
    firstIndex = List<int>.from(map['firstIndex'] as List<dynamic>);
    lastIndex = List<int>.from(map['lastIndex'] as List<dynamic>);
  }
}

class InvictosGladiator {
  String id;
  GladiatorOutput output;
  int index;
  InvictosGladiator(this.id, this.output, this.index);

  Map<String, dynamic> toJson() =>
      {'id': id, 'output': output.toJson(), 'index': index};
}

class SubmittereScan extends Serializable {
  String? priorSignum;
  String? privatusIter;
  String? publicaSignum;

  SubmittereScan();

  Map<String, dynamic> asMap() => {
        'priorSignum': priorSignum,
        'privatusIter': privatusIter,
        'publicaSignum': publicaSignum
      };
  void readFromMap(Map<String, dynamic> map) {
    priorSignum = map['priorSignum'].toString();
    privatusIter = map['privatusIter'].toString();
    publicaSignum = map['publicaSignum'].toString();
  }
}

class HumanifyIn extends Serializable {
  String? dominus;
  String? quaestio;
  String? respondere;
  HumanifyIn();

  Map<String, dynamic> asMap() => {
        'dominus': dominus,
        'quaestio': quaestio,
        'respondere': respondere,
      };

  void readFromMap(Map<String, dynamic> map) {
    dominus = map['dominus'].toString();
    quaestio = map['quaestio'].toString();
    respondere = map['respondere'].toString();
  }
}
