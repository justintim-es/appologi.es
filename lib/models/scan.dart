import 'dart:convert';
import 'dart:isolate';

import 'package:elliptic/elliptic.dart';
import 'package:hex/hex.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:appologi_es/models/constantes.dart';
import 'package:appologi_es/models/utils.dart';

class ScanOutput {
  String prior;
  String novus;
  ScanOutput({required this.prior, required this.novus});
  Map<String, dynamic> toJson() => {'prior': prior, 'novus': novus};
  ScanOutput.fromJson(Map<String, dynamic> map)
      : prior = map['prior'].toString(),
        novus = map['novus'].toString();
}

class HumanifyAnswer {
  int passphraseIndex;
  String passphrase;
  String probationem;
  HumanifyAnswer(
      {required this.passphraseIndex,
      required this.passphrase,
      required this.probationem});
  Map<String, dynamic> toJson() => {
        'passphraseIndex': passphraseIndex,
        'passphrase': passphrase,
        'probationem': probationem
      };
  HumanifyAnswer.fromJson(Map<String, dynamic> map)
      : passphraseIndex = int.parse(map['passphraseIndex'].toString()),
        passphrase = map['passphrase'].toString(),
        probationem = map['probationem'].toString();
}

class InterioreScan {
  ScanOutput output;
  HumanifyAnswer? humanifyAnswer;
  BigInt nonce;
  String id;
  InterioreScan({required this.output, required this.humanifyAnswer})
      : nonce = BigInt.zero,
        id = Utils.randomHex(32);
  Map<String, dynamic> toJson() => {
        'output': output.toJson(),
        'humanifyAnswer': humanifyAnswer?.toJson(),
        'nonce': nonce.toString(),
        'id': id
      }..removeWhere((key, value) => value == null);
  InterioreScan.fromJson(Map<String, dynamic> map)
      : output = ScanOutput.fromJson(map['output'] as Map<String, dynamic>),
        humanifyAnswer = map['humanifyAnswer'] != null
            ? HumanifyAnswer.fromJson(
                map['humanifyAnswer'] as Map<String, dynamic>)
            : null,
        nonce = BigInt.parse(map['nonce'].toString()),
        id = map['id'].toString();

  void mine() {
    nonce += BigInt.one;
  }
}

class Scan {
  InterioreScan interioreScan;
  String probationem;
  Scan(this.interioreScan, this.probationem);
  Map<String, dynamic> toJson() =>
      {'interioreScan': interioreScan.toJson(), 'probationem': probationem};
  Scan.fromJson(Map<String, dynamic> map)
      : interioreScan = InterioreScan.fromJson(
            map['interioreScan'] as Map<String, dynamic>),
        probationem = map['probationem'].toString();

  static void quaestum(List<dynamic> argumentis) {
    InterioreScan interiore = argumentis[0] as InterioreScan;
    SendPort mitte = argumentis[1] as SendPort;
    String probationem = '';
    int zeros = 1;
    while (true) {
      do {
        interiore.mine();
        probationem = HEX.encode(
            sha512.convert(utf8.encode(json.encode(interiore.toJson()))).bytes);
      } while (!probationem.startsWith('0' * zeros));
      zeros += 1;
      mitte.send(Scan(interiore, probationem));
    }
  }

  static List<Scan> grab(int difficultas, List<Scan> txs) {
    List<Scan> reditus = [];
    for (int i = 128; i >= difficultas; i--) {
      if (txs.any((tx) => tx.probationem.startsWith('0' * i))) {
        if (reditus.length < Constantes.txCaudice) {
          reditus.addAll(txs.where((tx) =>
              tx.probationem.startsWith('0' * i) && !reditus.contains(tx)));
        } else {
          break;
        }
      }
    }
    return reditus;
  }
}
