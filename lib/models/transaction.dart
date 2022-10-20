import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:isolate';
import 'package:hex/hex.dart';
import 'package:appologi_es/models/utils.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:elliptic/elliptic.dart';
import 'package:ecdsa/ecdsa.dart';
import 'package:appologi_es/models/pera.dart';
import 'package:appologi_es/models/constantes.dart';

class TransactionInput {
  final int index;
  final String signature;
  final String transactionId;
  TransactionInput(this.index, this.signature, this.transactionId);
  Map<String, dynamic> toJson() =>
      {'index': index, 'signature': signature, 'transactionId': transactionId};
  TransactionInput.fromJson(Map<String, dynamic> jsoschon)
      : index = int.parse(jsoschon['index'].toString()),
        signature = jsoschon['signature'].toString(),
        transactionId = jsoschon['transactionId'].toString();
}

class TransactionOutput {
  final String publicKey;
  final BigInt app;
  final int? cashExIndex;
  TransactionOutput(this.publicKey, this.app, this.cashExIndex);
  Map<String, dynamic> toJson() => {
        'publicKey': publicKey,
        'app': app.toString(),
        'cashExIndex': cashExIndex,
      }..removeWhere((key, value) => value == null);
  TransactionOutput.fromJson(Map<String, dynamic> jsoschon)
      : publicKey = jsoschon['publicKey'].toString(),
        app = BigInt.parse(jsoschon['app'].toString()),
        cashExIndex = (jsoschon['cashExIndex'] != null &&
                jsoschon['cashExIndex'] != 'null')
            ? int.parse(jsoschon['cashExIndex'].toString())
            : null;
}

class InterioreTransaction {
  final bool liber;
  final List<TransactionInput> inputs;
  final List<TransactionOutput> outputs;
  final String random;
  final String id;
  String? expressi;
  BigInt nonce;
  InterioreTransaction(this.liber, this.inputs, this.outputs, this.random)
      : nonce = BigInt.zero,
        id = Utils.randomHex(32);

  InterioreTransaction.expressi(
      this.liber, this.inputs, this.outputs, this.random, this.expressi)
      : nonce = BigInt.zero,
        id = Utils.randomHex(32);
  mine() {
    nonce += BigInt.one;
  }

  Map<String, dynamic> toJson() => {
        'liber': liber,
        'inputs': inputs.map((i) => i.toJson()).toList(),
        'outputs': outputs.map((o) => o.toJson()).toList(),
        'random': random,
        'id': id,
        'nonce': nonce.toString(),
        'expressi': expressi
      }..removeWhere((key, value) => value == null);
  InterioreTransaction.fromJson(Map<String, dynamic> jsoschon)
      : liber = jsoschon['liber'] as bool,
        inputs = List<TransactionInput>.from(jsoschon['inputs'].map(
                (i) => TransactionInput.fromJson(i as Map<String, dynamic>))
            as Iterable<dynamic>),
        outputs = List<TransactionOutput>.from(jsoschon['outputs'].map(
                (o) => TransactionOutput.fromJson(o as Map<String, dynamic>))
            as Iterable<dynamic>),
        random = jsoschon['random'].toString(),
        id = jsoschon['id'].toString(),
        nonce = BigInt.parse(jsoschon['nonce'].toString()),
        expressi =
            (jsoschon['expressi'] == 'null' || jsoschon['expressi'] == null)
                ? null
                : jsoschon['expressi'].toString();
}

class Transaction {
  late String probationem;
  final InterioreTransaction interioreTransaction;
  Transaction(this.probationem, this.interioreTransaction);
  Transaction.fromJson(Map<String, dynamic> jsoschon)
      : probationem = jsoschon['probationem'].toString(),
        interioreTransaction = InterioreTransaction.fromJson(
            jsoschon['interioreTransaction'] as Map<String, dynamic>);
  Transaction.expressi(this.interioreTransaction)
      : probationem = HEX.encode(sha512
            .convert(utf8.encode(json.encode(interioreTransaction.toJson())))
            .bytes);
  static void quaestum(List<dynamic> argumentis) {
    InterioreTransaction interiore = argumentis[0] as InterioreTransaction;
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
      mitte.send(Transaction(probationem, interiore));
    }
  }

  Transaction.burn(this.interioreTransaction) : probationem = Constantes.ardeat;
  bool validateBlockreward() {
    if (interioreTransaction.outputs.length != 1) {
      return false;
    }
    if (interioreTransaction.outputs[0].app !=
        Constantes.obstructionumPraemium) {
      return false;
    }
    if (interioreTransaction.inputs.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future<bool> validateBurn(Directory dir) async {
    List<Obstructionum> obs = await Obstructionum.getBlocks(dir);
    BigInt spendable = BigInt.zero;
    for (TransactionInput input in interioreTransaction.inputs) {
      Obstructionum prevObs = obs.singleWhere((ob) =>
          ob.interioreObstructionum.liberTransactions.any(
              (liber) => liber.interioreTransaction.id == input.transactionId));
      TransactionOutput output = prevObs
          .interioreObstructionum.liberTransactions
          .singleWhere(
              (liber) => liber.interioreTransaction.id == input.transactionId)
          .interioreTransaction
          .outputs[input.index];
      spendable = output.app;
    }
    BigInt spended = BigInt.zero;
    for (TransactionOutput output in interioreTransaction.outputs) {
      spended += output.app;
    }
    if (spendable > spended) {
      return false;
    }
    return true;
  }

  Future<bool> validateLiber(Directory dir) async {
    List<Obstructionum> obs = await Obstructionum.getBlocks(dir);
    BigInt spendable = BigInt.zero;
    for (TransactionInput input in interioreTransaction.inputs) {
      Obstructionum referObstructionum = obs.singleWhere((o) =>
          o.interioreObstructionum.liberTransactions.any(
              (liber) => liber.interioreTransaction.id == input.transactionId));
      Transaction tx = referObstructionum
          .interioreObstructionum.liberTransactions
          .singleWhere(
              (liber) => liber.interioreTransaction.id == input.transactionId);
      if (!Utils.cognoscere(
          PublicKey.fromHex(Pera.curve(),
              tx.interioreTransaction.outputs[input.index].publicKey),
          Signature.fromASN1Hex(input.signature),
          tx.interioreTransaction.outputs[input.index])) {
        print('non subscribere');
        return false;
      }
      spendable += tx.interioreTransaction.outputs[input.index].app;
    }
    BigInt spended = BigInt.zero;
    for (TransactionOutput output in interioreTransaction.outputs) {
      spended += output.app;
    }
    if (spendable != spended) {
      print('insf');
      return false;
    }
    return true;
  }

  Future<bool> validateFixum(Directory dir) async {
    List<Obstructionum> obs = await Obstructionum.getBlocks(dir);
    BigInt spendable = BigInt.zero;
    for (TransactionInput input in interioreTransaction.inputs) {
      Obstructionum referObstructionum = obs.singleWhere((o) =>
          o.interioreObstructionum.fixumTransactions.any(
              (fixum) => fixum.interioreTransaction.id == input.transactionId));
      Transaction tx = referObstructionum
          .interioreObstructionum.fixumTransactions
          .singleWhere(
              (fixum) => fixum.interioreTransaction.id == input.transactionId);
      if (!Utils.cognoscere(
          PublicKey.fromHex(Pera.curve(),
              tx.interioreTransaction.outputs[input.index].publicKey),
          Signature.fromASN1Hex(input.signature),
          tx.interioreTransaction.outputs[input.index])) {
        return false;
      }
      spendable += tx.interioreTransaction.outputs[input.index].app;
    }
    BigInt spended = BigInt.zero;
    for (TransactionOutput output in interioreTransaction.outputs) {
      spended += output.app;
    }
    if (spendable != spended) {
      return false;
    }
    return true;
  }

  Map toJson() => {
        'probationem': probationem,
        'interioreTransaction': interioreTransaction.toJson()
      };
  static List<Transaction> grab(int difficultas, List<Transaction> txs) {
    List<Transaction> reditus = [];
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

  bool validateProbationem() {
    if (probationem !=
        HEX.encode(sha512
            .convert(utf8.encode(json.encode(interioreTransaction.toJson())))
            .bytes)) {
      return false;
    }
    return true;
  }
}
