import 'package:appologi_es/models/exampla.dart';
import 'package:tuple/tuple.dart';
import 'package:appologi_es/models/transaction.dart';
import 'package:appologi_es/models/utils.dart';
import 'dart:io';
import 'package:appologi_es/models/obstructionum.dart';
import 'dart:convert';
import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';
import 'package:appologi_es/models/constantes.dart';
import 'package:appologi_es/models/gladiator.dart';
import 'package:appologi_es/models/errors.dart';

class Defensio {
  final String defensio;
  final String probationem;
  Defensio(this.defensio, this.probationem);
  Map<String, dynamic> toJson() =>
      {'defensio': defensio, 'probationem': probationem};
}

class Pera {
  static EllipticCurve curve() => getP256();
  static Future<Defensio> turpiaGladiatoriaDefensione(
      int index, String gladiatorId, Directory directory) async {
    for (int i = 0; i < directory.listSync().length; i++) {
      await for (String line in Utils.fileAmnis(File(
          directory.path + Constantes.fileNomen + i.toString() + '.txt'))) {
        Obstructionum obs =
            Obstructionum.fromJson(json.decode(line) as Map<String, dynamic>);
        if (obs.interioreObstructionum.gladiator.id == gladiatorId) {
          return Defensio(
              obs.interioreObstructionum.gladiator.outputs[index].defensio,
              obs.probationem);
        }
      }
    }
    throw Error(
        code: 0,
        message: "gladiator non inveni",
        english: "gladiator not found");
  }

  static Future<bool> isProbationum(
      String probationum, Directory directory) async {
    List<String> obs = [];
    for (int i = 0; i < directory.listSync().length; i++) {
      await for (String line in Utils.fileAmnis(File(
          directory.path + Constantes.fileNomen + i.toString() + '.txt'))) {
        obs.add(
            Obstructionum.fromJson(json.decode(line) as Map<String, dynamic>)
                .probationem);
      }
    }
    if (obs.contains(probationum)) return true;
    return false;
  }

  static Future<bool> isPublicaClavisDefended(
      String publicaClavis, Directory directory) async {
    List<GladiatorOutput> gladiatorOutputs =
        await Obstructionum.utDifficultas(directory);
    for (List<Propter> propters in gladiatorOutputs.map((g) => g.rationem)) {
      for (Propter propter in propters) {
        if (propter.interioreRationem.publicaClavis == publicaClavis)
          return true;
      }
    }
    return false;
  }

  static Future<String> basisDefensione(
      String probationem, Directory directory) async {
    for (int i = 0; i < directory.listSync().length; i++) {
      await for (String line in Utils.fileAmnis(
          File('${directory.path}${Constantes.fileNomen}$i.txt'))) {
        Obstructionum obs =
            Obstructionum.fromJson(json.decode(line) as Map<String, dynamic>);
        if (obs.probationem == probationem) {
          return obs.interioreObstructionum.defensio!;
        }
      }
    }
    throw Error(
        code: 0, message: "probationem non inveni", english: "proof not found");
  }

  static Future<BigInt> yourBid(bool liber, int index, String probationem,
      String gladiatorId, Directory directory) async {
    Map<String, BigInt> bid =
        await defensiones(liber, index, gladiatorId, directory);
    for (String key in bid.keys) {
      if (key == probationem) {
        return bid[key] ?? BigInt.zero;
      }
    }
    return BigInt.zero;
  }

  static Future<BigInt> summaBid(
      bool liber, int index, String probationem, Directory directory) async {
    List<Map<String, BigInt>> maschaps = [];
    List<String> gladiatorIds = [];
    for (int i = 0; i < directory.listSync().length; i++) {
      await for (String line in Utils.fileAmnis(
          File('${directory.path}${Constantes.fileNomen}$i.txt'))) {
        Obstructionum obs =
            Obstructionum.fromJson(json.decode(line) as Map<String, dynamic>);
        gladiatorIds.add(obs.interioreObstructionum.gladiator.id);
      }
    }
    for (String gid in gladiatorIds) {
      maschaps.add(await defensiones(liber, 0, gid, directory));
      maschaps.add(await defensiones(liber, 1, gid, directory));
    }
    for (Map<String, BigInt> maschap in maschaps) {
      print(maschap.keys);
    }
    BigInt highestBid = BigInt.zero;
    for (Map<String, BigInt> maschap in maschaps) {
      for (String key in maschap.keys.where((k) => k == probationem)) {
        if ((maschap[key] ??= BigInt.zero) >= highestBid) {
          highestBid = maschap[key] ?? BigInt.zero;
        }
      }
    }
    return highestBid;
  }

  static Future<List<Defensio>> maximeDefensiones(
      bool liber, int index, String gladiatorId, Directory directory) async {
    List<Defensio> def = [];
    Map<String, BigInt> ours = Map();
    List<Map<String, BigInt>> others = [];
    List<Obstructionum> obss = [];
    for (int i = 0; i < directory.listSync().length; i++) {
      await for (String line in Utils.fileAmnis(
          File(directory.path + '/caudices_' + i.toString() + '.txt'))) {
        Obstructionum obs =
            Obstructionum.fromJson(json.decode(line) as Map<String, dynamic>);
        obss.add(obs);
        if (obs.interioreObstructionum.gladiator.id == gladiatorId) {
          ours = await defensiones(liber, index, gladiatorId, directory);
        } else {
          others.add(await defensiones(liber, index,
              obs.interioreObstructionum.gladiator.id, directory));
        }
      }
    }
    Map<String, bool> payedMore = Map();
    for (String key in ours.keys) {
      if (others.any((o) => o.keys.contains(key))) {
        for (Map<String, BigInt> other
            in others.where((e) => e.keys.contains(key))) {
          if ((ours[key] ??= BigInt.zero) > (other[key] ??= BigInt.zero)) {
            payedMore[key] = true;
          }
        }
      } else {
        payedMore[key] = true;
      }
    }
    for (String key in payedMore.keys) {
      def.add(Defensio(
          obss
              .singleWhere((obs) => obs.probationem == key)
              .interioreObstructionum
              .defensio!,
          key));
    }
    return def;
  }

  static Future<Map<String, BigInt>> defensiones(
      bool liber, int index, String gladiatorId, Directory directory) async {
    List<Obstructionum> obstructionums = [];
    for (int i = 0; i < directory.listSync().length; i++) {
      await for (String line in Utils.fileAmnis(
          File(directory.path + '/caudices_' + i.toString() + '.txt'))) {
        obstructionums.add(
            Obstructionum.fromJson(json.decode(line) as Map<String, dynamic>));
        // probationems.add(Obstructionum.fromJson(json.decode(line)).probationem);
        // Obstructionum.fromJson(json.decode(line)).interioreObstructionum.liberTransactions.map((e) => e.interioreTransaction.outputs.where((element) => element.publicKey));
      }
    }
    List<String> publicaClavises = [];
    List<String> probationums = [];
    for (Obstructionum obs in obstructionums) {
      probationums.add(obs.probationem);
      if (obs.interioreObstructionum.gladiator.id == gladiatorId) {
        if (obs.interioreObstructionum.generare == Generare.EFECTUS) {
          publicaClavises.addAll(obs
              .interioreObstructionum.gladiator.outputs[index].rationem
              .map((r) => r.interioreRationem.publicaClavis));
        } else if (obs.interioreObstructionum.generare == Generare.INCIPIO) {
          publicaClavises.addAll(obs
              .interioreObstructionum.gladiator.outputs[0].rationem
              .map((r) => r.interioreRationem.publicaClavis));
        }
      }
    }
    List<TransactionInput> toDerive = [];
    List<Transaction> txsWithOutput = [];
    for (Iterable<Transaction> obs in obstructionums.map((o) => liber
        ? o.interioreObstructionum.liberTransactions
        : o.interioreObstructionum.fixumTransactions.where((e) => e
            .interioreTransaction.outputs
            .any((oschout) => probationums.contains(oschout.publicKey))))) {
      obs.map((e) => e.interioreTransaction.inputs).forEach(toDerive.addAll);
      txsWithOutput.addAll(obs);
    }
    List<String> transactionIds =
        toDerive.map((to) => to.transactionId).toList();
    List<TransactionOutput> outputs = [];
    for (Iterable<Transaction> obs in obstructionums
        .map((o) => liber
            ? o.interioreObstructionum.liberTransactions
            : o.interioreObstructionum.fixumTransactions)
        .toList()) {
      obs
          .where((e) => transactionIds.contains(e.interioreTransaction.id))
          .map((tx) => tx.interioreTransaction.outputs)
          .forEach(outputs.addAll);
    }
    Map<String, BigInt> maschap = Map();
    for (TransactionOutput oschout in outputs
        .where((oschout) => publicaClavises.contains(oschout.publicKey))) {
      for (Transaction tx in txsWithOutput) {
        for (TransactionInput ischin in tx.interioreTransaction.inputs) {
          if (Utils.cognoscere(
              PublicKey.fromHex(Pera.curve(), oschout.publicKey),
              Signature.fromASN1Hex(ischin.signature),
              oschout)) {
            for (TransactionOutput oschoutoschout in tx
                .interioreTransaction.outputs
                .where((element) => probationums.contains(element.publicKey))) {
              BigInt prevValue =
                  maschap[oschoutoschout.publicKey] ?? BigInt.zero;
              maschap[oschoutoschout.publicKey] =
                  prevValue + oschoutoschout.app;
            }
          }
        }
      }
    }
    return maschap;
  }

  //left off
  static Future<Tuple2<InterioreTransaction?, InterioreTransaction?>>
      transformFixum(String privatus, List<Transaction> txStagnum,
          Directory directory) async {
    String publica =
        PrivateKey.fromHex(Pera.curve(), privatus).publicKey.toHex();
    List<Tuple3<int, String, TransactionOutput>> outs =
        await inconsumptusOutputs(true, publica, directory);
    for (Transaction tx
        in txStagnum.where((t) => t.interioreTransaction.liber == true)) {
      outs.removeWhere((element) => tx.interioreTransaction.inputs
          .any((ischin) => ischin.transactionId == element.item2));
      for (int i = 0; i < tx.interioreTransaction.outputs.length; i++) {
        PrivateKey pk = PrivateKey.fromHex(Pera.curve(), privatus);
        if (tx.interioreTransaction.outputs[i].publicKey ==
            pk.publicKey.toHex()) {
          outs.add(Tuple3<int, String, TransactionOutput>(i,
              tx.interioreTransaction.id, tx.interioreTransaction.outputs[i]));
        }
      }
    }
    if (outs.isEmpty) {
      return Tuple2(null, null);
    }
    List<TransactionOutput> outputs = [];
    List<TransactionInput> inputs = [];
    for (Tuple3<int, String, TransactionOutput> out in outs) {
      outputs.add(TransactionOutput(publica, out.item3.app, null));
      inputs.add(TransactionInput(
          out.item1,
          Utils.signum(PrivateKey.fromHex(Pera.curve(), privatus), out.item3),
          out.item2));
    }
    return Tuple2<InterioreTransaction, InterioreTransaction>(
        InterioreTransaction(true, inputs, [], Utils.randomHex(32)),
        InterioreTransaction(false, [], outputs, Utils.randomHex(32)));
  }

  static Future<List<Tuple3<int, String, TransactionOutput>>>
      inconsumptusOutputs(
          bool liber, String publicKey, Directory directory) async {
    List<Tuple3<int, String, TransactionOutput>> outputs = [];
    List<TransactionInput> initibus = [];
    List<Transaction> txs = [];
    for (int i = 0; i < directory.listSync().length; i++) {
      await for (var line in Utils.fileAmnis(
          File(directory.path + '/caudices_' + i.toString() + '.txt'))) {
        txs.addAll(liber
            ? Obstructionum.fromJson(json.decode(line) as Map<String, dynamic>)
                .interioreObstructionum
                .liberTransactions
            : Obstructionum.fromJson(json.decode(line) as Map<String, dynamic>)
                .interioreObstructionum
                .fixumTransactions);
      }
    }
    Iterable<List<TransactionInput>> initibuses =
        txs.map((tx) => tx.interioreTransaction.inputs);
    for (List<TransactionInput> init in initibuses) {
      initibus.addAll(init);
    }
    for (Transaction tx in txs.where((tx) =>
        tx.interioreTransaction.outputs.any((e) => e.publicKey == publicKey))) {
      for (int t = 0; t < tx.interioreTransaction.outputs.length; t++) {
        if (tx.interioreTransaction.outputs[t].publicKey == publicKey) {
          outputs.add(Tuple3<int, String, TransactionOutput>(t,
              tx.interioreTransaction.id, tx.interioreTransaction.outputs[t]));
        }
      }
    }
    outputs.removeWhere((output) => initibus.any((init) =>
        init.transactionId == output.item2 && init.index == output.item1));
    return outputs;
  }

  static Future<BigInt> acccipereForumCap(
      bool liber, Directory directory) async {
    List<Tuple3<int, String, TransactionOutput>> outputs = [];
    List<TransactionInput> initibus = [];
    List<Transaction> txs = [];
    for (int i = 0; i < directory.listSync().length; i++) {
      await for (var line in Utils.fileAmnis(
          File(directory.path + '/caudices_' + i.toString() + '.txt'))) {
        txs.addAll(liber
            ? Obstructionum.fromJson(json.decode(line) as Map<String, dynamic>)
                .interioreObstructionum
                .liberTransactions
            : Obstructionum.fromJson(json.decode(line) as Map<String, dynamic>)
                .interioreObstructionum
                .fixumTransactions);
      }
    }
    Iterable<List<TransactionInput>> initibuses =
        txs.map((tx) => tx.interioreTransaction.inputs);
    for (List<TransactionInput> init in initibuses) {
      initibus.addAll(init);
    }
    for (Transaction tx in txs) {
      for (int t = 0; t < tx.interioreTransaction.outputs.length; t++) {
        outputs.add(Tuple3<int, String, TransactionOutput>(
            t, tx.interioreTransaction.id, tx.interioreTransaction.outputs[t]));
      }
    }
    outputs.removeWhere((output) => initibus.any((init) =>
        init.transactionId == output.item2 && init.index == output.item1));
    BigInt forumCap = BigInt.zero;
    for (TransactionOutput output in outputs.map((output) => output.item3)) {
      forumCap += output.app;
    }
    return forumCap;
  }

  static Future<BigInt> statera(
      bool liber, String publicKey, Directory directory) async {
    List<Tuple3<int, String, TransactionOutput>> outputs =
        await inconsumptusOutputs(liber, publicKey, directory);
    BigInt balance = BigInt.zero;
    for (Tuple3<int, String, TransactionOutput> inOut in outputs) {
      balance += inOut.item3.app;
    }
    return balance;
  }

  static Future<InterioreTransaction> ardeat(
      PrivateKey privatus,
      String publica,
      String probationum,
      BigInt value,
      Directory directory) async {
    List<Tuple3<int, String, TransactionOutput>> outs =
        await inconsumptusOutputs(true, publica, directory);
    return calculateTransaction(
        true, false, privatus, probationum, value, outs, null);
  }

  static Future<InterioreTransaction> novamRem(
      bool liber,
      bool tx,
      String ex,
      BigInt value,
      String to,
      List<Transaction> txStagnum,
      Directory directory,
      String? expressiId) async {
    PrivateKey privatusClavis = PrivateKey.fromHex(Pera.curve(), ex);
    List<Tuple3<int, String, TransactionOutput>> inOuts =
        await inconsumptusOutputs(
            liber, privatusClavis.publicKey.toHex(), directory);
    for (Transaction tx
        in txStagnum.where((t) => t.interioreTransaction.liber == liber)) {
      inOuts.removeWhere((element) => tx.interioreTransaction.inputs
          .any((ischin) => ischin.transactionId == element.item2));
      for (int i = 0; i < tx.interioreTransaction.outputs.length; i++) {
        if (tx.interioreTransaction.outputs[i].publicKey ==
            privatusClavis.publicKey.toHex()) {
          inOuts.add(Tuple3<int, String, TransactionOutput>(i,
              tx.interioreTransaction.id, tx.interioreTransaction.outputs[i]));
        }
      }
    }
    return calculateTransaction(
        liber, tx, privatusClavis, to, value, inOuts, expressiId);
  }

  static InterioreTransaction calculateTransaction(
      bool liber,
      bool tx,
      PrivateKey privatus,
      String to,
      BigInt value,
      List<Tuple3<int, String, TransactionOutput>> outs,
      String? expressiId) {
    BigInt balance = BigInt.zero;
    for (Tuple3<int, String, TransactionOutput> inOut in outs) {
      balance += inOut.item3.app;
    }
    print(balance);
    print(value);
    print(tx);
    if (tx ? (balance < (value * BigInt.two)) : (balance < value)) {
      throw Error(
          code: 1, message: "Satis pecunia", english: "Insufficient funds");
    }
    BigInt implere = value;
    List<TransactionInput> inputs = [];
    List<TransactionOutput> outputs = [];
    for (Tuple3<int, String, TransactionOutput> inOut in outs) {
      inputs.add(TransactionInput(
          inOut.item1, Utils.signum(privatus, inOut.item3), inOut.item2));
      if (inOut.item3.app < implere) {
        outputs.add(TransactionOutput(to, inOut.item3.app, null));
        implere -= inOut.item3.app;
      } else if (inOut.item3.app > implere) {
        outputs.add(TransactionOutput(to, implere, null));
        outputs.add(TransactionOutput(
            privatus.publicKey.toHex(), inOut.item3.app - implere, null));
        break;
      } else {
        outputs.add(TransactionOutput(to, implere, null));
        break;
      }
    }
    if (expressiId != null) {
      return InterioreTransaction.expressi(
          liber, inputs, outputs, Utils.randomHex(32), expressiId);
    } else {
      return InterioreTransaction(liber, inputs, outputs, Utils.randomHex(32));
    }
  }
}
