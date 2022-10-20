import 'dart:convert';
import 'dart:isolate';
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
import 'package:appologi_es/models/constantes.dart';
import 'package:appologi_es/models/scan.dart';
import 'package:appologi_es/models/utils.dart';

class SignumCashEx {
  String public;
  BigInt nof;
  BigInt nonce;
  String id;
  SignumCashEx({required this.public, required this.nof, required this.nonce})
      : id = Utils.randomHex(32);
  Map<String, dynamic> toJson() => {
        'public': public,
        'nof': nof.toString(),
        'nonce': nonce.toString(),
        'id': id
      };
  SignumCashEx.fromJson(Map<String, dynamic> map)
      : public = map['public'].toString(),
        nof = BigInt.parse(map['nof'].toString()),
        nonce = BigInt.parse(map['nonce'].toString()),
        id = map['id'].toString();

  void mine() {
    nonce += BigInt.one;
  }
}

class InterioreCashEx {
  SignumCashEx signumCashEx;
  String signature;
  InterioreCashEx({required this.signumCashEx, required this.signature});
  Map<String, dynamic> toJson() =>
      {'signumCashEx': signumCashEx, 'signature': signature};
  InterioreCashEx.fromJson(Map<String, dynamic> map)
      : signumCashEx =
            SignumCashEx.fromJson(map['signumCashEx'] as Map<String, dynamic>),
        signature = map['signature'].toString();
}

class CashEx {
  InterioreCashEx interioreCashEx;
  String probationem;
  CashEx(this.interioreCashEx, this.probationem);
  Map<String, dynamic> toJson() => {
        'interioreCashEx': interioreCashEx.toJson(),
        'probationem': probationem,
      };
  CashEx.fromJson(Map<String, dynamic> map)
      : interioreCashEx = InterioreCashEx.fromJson(
            map['interioreCashEx'] as Map<String, dynamic>),
        probationem = map['probationem'].toString();

  static void quaestum(List<dynamic> argumentis) {
    InterioreCashEx interiore = argumentis[0] as InterioreCashEx;
    SendPort mitte = argumentis[1] as SendPort;
    String probationem = '';
    int zeros = 1;
    while (true) {
      do {
        interiore.signumCashEx.mine();
        probationem = HEX.encode(
            sha512.convert(utf8.encode(json.encode(interiore.toJson()))).bytes);
      } while (!probationem.startsWith('0' * zeros));
      zeros += 1;
      mitte.send(CashEx(interiore, probationem));
    }
  }

  static List<CashEx> grab(int difficultas, List<CashEx> txs) {
    List<CashEx> reditus = [];
    for (int i = 64; i >= difficultas; i--) {
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
