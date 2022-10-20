import 'dart:io';
import 'dart:isolate';

import 'package:elliptic/elliptic.dart';
import 'package:appologi_es/models/cash_ex.dart';
import 'package:appologi_es/models/gladiator.dart';
import 'package:appologi_es/models/humanify.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:appologi_es/models/pera.dart';
import 'package:appologi_es/models/scan.dart';
import 'package:appologi_es/models/transaction.dart';
import 'package:appologi_es/models/utils.dart';
import 'package:appologi_es/p2p.dart';
import 'package:tuple/tuple.dart';

import '../models/aboutconfig.dart';
import '../models/constantes.dart';
import 'package:collection/collection.dart';

class Rp {
  static Future efectus(
      bool isSalutaris,
      List<Isolate> efectusThreads,
      Map<String, Isolate> propterIsolates,
      Map<String, Isolate> liberTxIsolates,
      Map<String, Isolate> fixumTxIsolates,
      Map<String, Isolate> scanIsolates,
      Map<String, Isolate> cashExIsolates,
      P2P p2p,
      Aboutconfig aboutconfig,
      Directory directory) async {
    Obstructionum priorObstructionum =
        await Utils.priorObstructionum(directory);
    List<Propter> propters = [];
    propters.addAll(Gladiator.grab(
        priorObstructionum.interioreObstructionum.propterDifficultas,
        p2p.propters));
    List<Transaction> liberTxs = [];
    liberTxs.add(Transaction(
        Constantes.txObstructionumPraemium,
        InterioreTransaction(
            true,
            [],
            [
              TransactionOutput(aboutconfig.publicaClavis!,
                  Constantes.obstructionumPraemium, null)
            ],
            Utils.randomHex(32))));
    liberTxs.addAll(Transaction.grab(
        priorObstructionum.interioreObstructionum.liberDifficultas,
        p2p.liberTxs));
    List<Transaction> fixumTxs = [];
    fixumTxs.addAll(Transaction.grab(
        priorObstructionum.interioreObstructionum.fixumDifficultas,
        p2p.fixumTxs));
    final obstructionumDifficultas =
        await Obstructionum.utDifficultas(directory);
    List<Isolate> newThreads = [];
    int idx = 0;
    BigInt numerus = BigInt.zero;
    for (int nuschum in await Obstructionum.utObstructionumNumerus(directory)) {
      numerus += BigInt.parse(nuschum.toString());
    }
    final cex = priorObstructionum.interioreObstructionum.cashExs;
    for (int i = 0; i < cex.length; i++) {
      fixumTxs.add(Transaction(
          Constantes.cashEx,
          InterioreTransaction(
              false,
              [],
              [
                TransactionOutput(cex[i].interioreCashEx.signumCashEx.public,
                    cex[i].interioreCashEx.signumCashEx.nof, i)
              ],
              Utils.randomHex(32))));
    }
    ReceivePort acciperePortus = ReceivePort();
    for (int i = 0; i < efectusThreads.length; i++) {
      efectusThreads[i].kill();
      efectusThreads.remove(efectusThreads[i]);
      InterioreObstructionum interiore = InterioreObstructionum.efectus(
        obstructionumDifficultas: obstructionumDifficultas.length,
        divisa: (numerus / await Obstructionum.utSummaDifficultas(directory)),
        forumCap: await Obstructionum.accipereForumCap(directory),
        liberForumCap:
            await Obstructionum.accipereForumCapLiberFixum(true, directory),
        fixumForumCap:
            await Obstructionum.accipereForumCapLiberFixum(false, directory),
        propterDifficultas:
            Obstructionum.acciperePropterDifficultas(priorObstructionum),
        liberDifficultas:
            Obstructionum.accipereLiberDifficultas(priorObstructionum),
        fixumDifficultas:
            Obstructionum.accipereFixumDifficultas(priorObstructionum),
        scanDifficultas:
            Obstructionum.accipereScanDifficultas(priorObstructionum),
        cashExDifficultas:
            Obstructionum.accipereCashExDifficultas(priorObstructionum),
        summaObstructionumDifficultas:
            await Obstructionum.utSummaDifficultas(directory),
        obstructionumNumerus:
            await Obstructionum.utObstructionumNumerus(directory),
        producentis: aboutconfig.publicaClavis!,
        priorProbationem: priorObstructionum.probationem,
        gladiator: Gladiator(
            null,
            [
              GladiatorOutput(
                  propters.take((propters.length / 2).round()).toList()),
              GladiatorOutput(
                  propters.skip((propters.length / 2).round()).toList())
            ],
            Utils.randomHex(32)),
        liberTransactions: liberTxs,
        fixumTransactions: fixumTxs,
        expressiTransactions: p2p.expressieTxs
            .where((tx) => liberTxs.any((l) =>
                l.interioreTransaction.id == tx.interioreTransaction.expressi))
            .toList(),
        scans: Scan.grab(
            priorObstructionum.interioreObstructionum.scanDifficultas,
            p2p.scans),
        cashExs: CashEx.grab(
            priorObstructionum.interioreObstructionum.cashExDifficultas,
            p2p.cashExs),
        humanify: Humanify.grab(p2p.humanifies),
      );
      newThreads.add(await Isolate.spawn(Obstructionum.efectus,
          List<dynamic>.from([interiore, acciperePortus.sendPort, idx])));
    }
    newThreads.forEach(efectusThreads.add);

    acciperePortus.listen((nuntius) async {
      while (isSalutaris) {
        await Future.delayed(Duration(seconds: 1));
      }
      isSalutaris = true;
      Obstructionum obstructionum = nuntius as Obstructionum;
      Obstructionum priorObs = await Utils.priorObstructionum(directory);
      if (ListEquality().equals(
          obstructionum.interioreObstructionum.obstructionumNumerus,
          priorObs.interioreObstructionum.obstructionumNumerus)) {
        print('invalid blocknumber retrying');
        isSalutaris = false;
        p2p.efectusRp.sendPort.send("update miner");
        return;
      }
      if (priorObs.probationem !=
          obstructionum.interioreObstructionum.priorProbationem) {
        print('invalid probationem');
        isSalutaris = false;
        p2p.efectusRp.sendPort.send("update miner");
        return;
      }
      List<GladiatorOutput> outputs = [];
      for (GladiatorOutput output
          in obstructionum.interioreObstructionum.gladiator.outputs) {
        output.rationem.map((r) => r.interioreRationem.id).forEach(
            (id) => propterIsolates[id]?.kill(priority: Isolate.immediate));
        outputs.add(output);
      }
      obstructionum.interioreObstructionum.liberTransactions
          .map((e) => e.interioreTransaction.id)
          .forEach(
              (id) => liberTxIsolates[id]?.kill(priority: Isolate.immediate));
      obstructionum.interioreObstructionum.fixumTransactions
          .map((e) => e.interioreTransaction.id)
          .forEach(
              (id) => fixumTxIsolates[id]?.kill(priority: Isolate.immediate));
      obstructionum.interioreObstructionum.cashExs
          .map((c) => c.interioreCashEx.signumCashEx.id)
          .forEach(
              (id) => cashExIsolates[id]?.kill(priority: Isolate.immediate));
      obstructionum.interioreObstructionum.scans
          .map((s) => s.interioreScan.id)
          .forEach((id) => scanIsolates[id]?.kill(priority: Isolate.immediate));
      p2p.removeScans(obstructionum.interioreObstructionum.scans
          .map((s) => s.interioreScan.id)
          .toList());
      p2p.removeCashExs(obstructionum.interioreObstructionum.cashExs
          .map((c) => c.interioreCashEx.signumCashEx.id)
          .toList());
      List<String> gladiatorIds = [];
      for (GladiatorOutput output in outputs) {
        gladiatorIds.addAll(
            output.rationem.map((r) => r.interioreRationem.id).toList());
      }
      p2p.removePropters(gladiatorIds);
      p2p.removeLiberTxs(obstructionum.interioreObstructionum.liberTransactions
          .map((l) => l.interioreTransaction.id)
          .toList());
      p2p.removeFixumTxs(obstructionum.interioreObstructionum.fixumTransactions
          .map((f) => f.interioreTransaction.id)
          .toList());
      p2p.syncBlocks
          .forEach((element) => element.kill(priority: Isolate.immediate));
      p2p.syncBlocks.add(await Isolate.spawn(
          P2P.syncBlock,
          List<dynamic>.from([
            obstructionum,
            p2p.sockets,
            directory,
            '${aboutconfig.internumIp!}:{$aboutconfig.p2pPortus!}'
          ])));
      await obstructionum.salvare(directory);
      p2p.expressieTxs = [];
      p2p.efectusRp.sendPort.send("update miner");
      if (p2p.isExpressiActive) {
        p2p.expressiRp.sendPort.send("update miner");
      }
      isSalutaris = false;
    });
  }

  static Future confussus(
      bool isSalutaris,
      int gladiatorIndex,
      String gladiatorPrivateKey,
      String gladiatorId,
      List<Isolate> confussuses,
      Map<String, Isolate> propterIsolates,
      Map<String, Isolate> liberTxIsolates,
      Map<String, Isolate> fixumTxIsolates,
      Map<String, Isolate> scanIsolates,
      Map<String, Isolate> cashExIsolates,
      P2P p2p,
      Aboutconfig aboutconfig,
      Directory directory) async {
    List<Transaction> fixumTxs = [];
    List<Transaction> liberTxs = [];
    Obstructionum priorObstructionum =
        await Utils.priorObstructionum(directory);
    Gladiator gladiatorToAttack =
        await Obstructionum.grabGladiator(gladiatorId, directory);
    liberTxs.addAll(Transaction.grab(
        priorObstructionum.interioreObstructionum.liberDifficultas,
        p2p.liberTxs));
    fixumTxs.addAll(Transaction.grab(
        priorObstructionum.interioreObstructionum.fixumDifficultas,
        p2p.fixumTxs));
    final obstructionumDifficultas =
        await Obstructionum.utDifficultas(directory);
    for (String acc in gladiatorToAttack.outputs[gladiatorIndex].rationem
        .map((e) => e.interioreRationem.publicaClavis)) {
      final balance = await Pera.statera(true, acc, directory);
      if (balance > BigInt.zero) {
        liberTxs.add(Transaction.burn(await Pera.ardeat(
            PrivateKey.fromHex(Pera.curve(), gladiatorPrivateKey),
            acc,
            priorObstructionum.probationem,
            balance,
            directory)));
      }
    }
    Tuple2<InterioreTransaction?, InterioreTransaction?> transform =
        await Pera.transformFixum(gladiatorPrivateKey, p2p.liberTxs, directory);
    if (transform.item1 != null) {
      liberTxs.add(Transaction(Constantes.transform, transform.item1!));
    }
    if (transform.item2 != null) {
      fixumTxs.add(Transaction(Constantes.transform, transform.item2!));
    }
    // fixumTxs.add(Transaction(Constantes.txObstructionumPraemium, InterioreTransaction(false, [], [TransactionOutput(publicaClavis, Constantes.obstructionumPraemium)], Utils.randomHex(32))));

    List<Defensio> deschef = await Pera.maximeDefensiones(
        true, gladiatorIndex, gladiatorToAttack.id, directory);
    deschef.addAll(await Pera.maximeDefensiones(
        false, gladiatorIndex, gladiatorToAttack.id, directory));
    List<String> toCrack = deschef.map((e) => e.defensio).toList();
    final base = await Pera.turpiaGladiatoriaDefensione(
        gladiatorIndex, gladiatorToAttack.id, directory);
    toCrack.add(base.defensio);
    List<Isolate> newThreads = [];
    BigInt numerus = BigInt.zero;
    for (int nuschum in await Obstructionum.utObstructionumNumerus(directory)) {
      numerus += BigInt.parse(nuschum.toString());
    }
    final cex = priorObstructionum.interioreObstructionum.cashExs;
    for (int i = 0; i < cex.length; i++) {
      liberTxs.add(Transaction(
          Constantes.cashEx,
          InterioreTransaction(
              false,
              [],
              [
                TransactionOutput(cex[i].interioreCashEx.signumCashEx.public,
                    cex[i].interioreCashEx.signumCashEx.nof, i)
              ],
              Utils.randomHex(32))));
    }
    for (int i = 0; i < confussuses.length; i++) {
      confussuses[i].kill();
      confussuses.removeAt(i);
      InterioreObstructionum interiore = InterioreObstructionum.confussus(
          obstructionumDifficultas: obstructionumDifficultas.length,
          divisa: (numerus / await Obstructionum.utSummaDifficultas(directory)),
          forumCap: await Obstructionum.accipereForumCap(directory),
          summaObstructionumDifficultas:
              await Obstructionum.utSummaDifficultas(directory),
          obstructionumNumerus:
              await Obstructionum.utObstructionumNumerus(directory),
          liberForumCap:
              await Obstructionum.accipereForumCapLiberFixum(true, directory),
          fixumForumCap:
              await Obstructionum.accipereForumCapLiberFixum(false, directory),
          propterDifficultas:
              Obstructionum.acciperePropterDifficultas(priorObstructionum),
          liberDifficultas:
              Obstructionum.accipereLiberDifficultas(priorObstructionum),
          fixumDifficultas:
              Obstructionum.accipereFixumDifficultas(priorObstructionum),
          cashExDifficultas:
              Obstructionum.accipereCashExDifficultas(priorObstructionum),
          scanDifficultas:
              Obstructionum.accipereScanDifficultas(priorObstructionum),
          producentis: aboutconfig.publicaClavis!,
          priorProbationem: priorObstructionum.probationem,
          gladiator: Gladiator(
              GladiatorInput(
                  gladiatorIndex,
                  Utils.signum(
                      PrivateKey.fromHex(Pera.curve(), gladiatorPrivateKey),
                      gladiatorToAttack),
                  gladiatorId),
              [],
              Utils.randomHex(32)),
          liberTransactions: liberTxs,
          fixumTransactions: fixumTxs,
          expressiTransactions: [],
          scans: Scan.grab(
              priorObstructionum.interioreObstructionum.scanDifficultas,
              p2p.scans),
          cashExs:
              CashEx.grab(priorObstructionum.interioreObstructionum.cashExDifficultas, p2p.cashExs),
          humanify: Humanify.grab(p2p.humanifies));
      ReceivePort acciperePortus = ReceivePort();
      newThreads.add(await Isolate.spawn(Obstructionum.confussus,
          List<dynamic>.from([interiore, toCrack, acciperePortus.sendPort])));
      p2p.isConfussusActive = true;
      acciperePortus.listen((nuntius) async {
        while (isSalutaris) {
          await Future.delayed(Duration(seconds: 1));
        }
        isSalutaris = true;
        Obstructionum obstructionum = nuntius as Obstructionum;
        Obstructionum priorObs = await Utils.priorObstructionum(directory);
        if (ListEquality().equals(
            obstructionum.interioreObstructionum.obstructionumNumerus,
            priorObs.interioreObstructionum.obstructionumNumerus)) {
          print('invalid blocknumber retrying');
          p2p.confussusRp.sendPort.send("update miner");
          isSalutaris = false;
          return;
        }
        if (priorObs.probationem !=
            obstructionum.interioreObstructionum.priorProbationem) {
          print('invalid probationem');
          p2p.confussusRp.sendPort.send("update miner");
          isSalutaris = false;
          return;
        }
        List<GladiatorOutput> outputs = [];
        for (GladiatorOutput output
            in obstructionum.interioreObstructionum.gladiator.outputs) {
          output.rationem.map((r) => r.interioreRationem.id).forEach(
              (id) => propterIsolates[id]?.kill(priority: Isolate.immediate));
        }
        obstructionum.interioreObstructionum.liberTransactions
            .map((e) => e.interioreTransaction.id)
            .forEach(
                (id) => liberTxIsolates[id]?.kill(priority: Isolate.immediate));
        obstructionum.interioreObstructionum.fixumTransactions
            .map((e) => e.interioreTransaction.id)
            .forEach(
                (id) => fixumTxIsolates[id]?.kill(priority: Isolate.immediate));
        obstructionum.interioreObstructionum.cashExs
            .map((c) => c.interioreCashEx.signumCashEx.id)
            .forEach(
                (id) => cashExIsolates[id]?.kill(priority: Isolate.immediate));
        obstructionum.interioreObstructionum.scans
            .map((s) => s.interioreScan.id)
            .forEach(
                (id) => scanIsolates[id]?.kill(priority: Isolate.immediate));
        p2p.removeScans(obstructionum.interioreObstructionum.scans
            .map((s) => s.interioreScan.id)
            .toList());
        p2p.removeCashExs(obstructionum.interioreObstructionum.cashExs
            .map((c) => c.interioreCashEx.signumCashEx.id)
            .toList());
        List<String> gladiatorIds = [];
        for (GladiatorOutput output in outputs) {
          gladiatorIds.addAll(
              output.rationem.map((r) => r.interioreRationem.id).toList());
        }
        p2p.removePropters(gladiatorIds);
        p2p.removeLiberTxs(obstructionum
            .interioreObstructionum.liberTransactions
            .map((l) => l.interioreTransaction.id)
            .toList());
        p2p.removeFixumTxs(obstructionum
            .interioreObstructionum.fixumTransactions
            .map((f) => f.interioreTransaction.id)
            .toList());
        p2p.syncBlocks.forEach((e) => e..kill(priority: Isolate.immediate));
        p2p.syncBlocks.add(await Isolate.spawn(
            P2P.syncBlock,
            List<dynamic>.from([
              obstructionum,
              p2p.sockets,
              directory,
              '${aboutconfig.internumIp}:${aboutconfig.p2pPortus}'
            ])));
        await obstructionum.salvare(directory);
        isSalutaris = false;
      });
    }
  }

  static Future expressi(
    bool isExpressi,
    bool isSalutaris,
    int gladiatorExpressiIndex,
    String gladiatorExpressiPrivateKey,
    String gladiatorExpressiId,
    List<Isolate> expressiThreads,
    Map<String, Isolate> propterIsolates,
    Map<String, Isolate> liberTxIsolates,
    Map<String, Isolate> fixumTxIsolates,
    Map<String, Isolate> scanIsolates,
    Map<String, Isolate> cashExIsolates,
    P2P p2p,
    Aboutconfig aboutconfig,
    Directory directory,
  ) async {
    print('expressirptriggered');

    List<Transaction> fixumTxs = [];
    List<Transaction> liberTxs = [];

    isExpressi = true;
    Obstructionum priorObstructionum =
        await Utils.priorObstructionumEfectus(directory);
    ReceivePort acciperePortus = ReceivePort();
    // List<Propter> propters = [];
    // propters.addAll(Gladiator.grab(priorObstructionum.interioreObstructionum.propterDifficultas, p2p.propters));
    fixumTxs.addAll(Transaction.grab(
        priorObstructionum.interioreObstructionum.fixumDifficultas,
        p2p.fixumTxs));
    final obstructionumDifficultas =
        await Obstructionum.utDifficultas(directory);
    liberTxs
        .addAll(priorObstructionum.interioreObstructionum.expressiTransactions);
    // List<Propter> propters = [];
    // propters.addAll(Gladiator.grab(priorObstructionum.interioreObstructionum.propterDifficultas, p2p.propters));
    Gladiator gladiatorToAttack =
        await Obstructionum.grabGladiator(gladiatorExpressiId, directory);
    for (String acc in gladiatorToAttack
        .outputs[gladiatorExpressiIndex].rationem
        .map((e) => e.interioreRationem.publicaClavis)) {
      final balance = await Pera.statera(true, acc, directory);
      if (balance > BigInt.zero) {
        liberTxs.add(Transaction.burn(await Pera.ardeat(
            PrivateKey.fromHex(Pera.curve(), gladiatorExpressiPrivateKey),
            acc,
            priorObstructionum.probationem,
            balance,
            directory)));
      }
    }
    Tuple2<InterioreTransaction?, InterioreTransaction?> transform =
        await Pera.transformFixum(
            gladiatorExpressiPrivateKey, p2p.liberTxs, directory);
    if (transform.item1 != null) {
      liberTxs.add(Transaction(Constantes.transform, transform.item1!));
    }
    if (transform.item2 != null) {
      fixumTxs.add(Transaction(Constantes.transform, transform.item2!));
    }
    List<Defensio> deschef = await Pera.maximeDefensiones(
        true, gladiatorExpressiIndex, gladiatorExpressiId, directory);
    deschef.addAll(await Pera.maximeDefensiones(
        false, gladiatorExpressiIndex, gladiatorExpressiId, directory));
    List<String> toCrack = deschef.map((e) => e.defensio).toList();
    final base = await Pera.turpiaGladiatoriaDefensione(
        gladiatorExpressiIndex, gladiatorExpressiId, directory);
    toCrack.add(base.defensio);
    List<Isolate> newThreads = [];
    BigInt numerus = BigInt.zero;
    for (int nuschum in await Obstructionum.utObstructionumNumerus(directory)) {
      numerus += BigInt.parse(nuschum.toString());
    }
    final cex = priorObstructionum.interioreObstructionum.cashExs;
    for (int i = 0; i < cex.length; i++) {
      fixumTxs.add(Transaction(
          Constantes.cashEx,
          InterioreTransaction(
              false,
              [],
              [
                TransactionOutput(cex[i].interioreCashEx.signumCashEx.public,
                    cex[i].interioreCashEx.signumCashEx.nof, i)
              ],
              Utils.randomHex(32))));
    }
    for (int i = 0; i < expressiThreads.length; i++) {
      expressiThreads[i].kill();
      expressiThreads.removeAt(i);
      InterioreObstructionum interiore = InterioreObstructionum.expressi(
          obstructionumDifficultas: obstructionumDifficultas.length,
          divisa: (numerus / await Obstructionum.utSummaDifficultas(directory)),
          forumCap: await Obstructionum.accipereForumCap(directory),
          liberForumCap:
              await Obstructionum.accipereForumCapLiberFixum(true, directory),
          fixumForumCap:
              await Obstructionum.accipereForumCapLiberFixum(false, directory),
          propterDifficultas:
              Obstructionum.acciperePropterDifficultas(priorObstructionum),
          liberDifficultas:
              Obstructionum.accipereLiberDifficultas(priorObstructionum),
          fixumDifficultas:
              Obstructionum.accipereFixumDifficultas(priorObstructionum),
          scanDifficultas:
              Obstructionum.accipereScanDifficultas(priorObstructionum),
          cashExDifficultas:
              Obstructionum.accipereCashExDifficultas(priorObstructionum),
          summaObstructionumDifficultas:
              await Obstructionum.utSummaDifficultas(directory),
          obstructionumNumerus:
              await Obstructionum.utObstructionumNumerus(directory),
          producentis: aboutconfig.publicaClavis!,
          priorProbationem: priorObstructionum.probationem,
          gladiator: Gladiator(
              GladiatorInput(
                  gladiatorExpressiIndex,
                  Utils.signum(
                      PrivateKey.fromHex(
                          Pera.curve(), gladiatorExpressiPrivateKey),
                      gladiatorToAttack.outputs[gladiatorExpressiIndex]),
                  gladiatorExpressiId),
              [],
              Utils.randomHex(32)),
          liberTransactions: liberTxs,
          fixumTransactions: fixumTxs,
          expressiTransactions: [],
          scans: Scan.grab(
              priorObstructionum.interioreObstructionum.scanDifficultas,
              p2p.scans),
          humanify: Humanify.grab(p2p.humanifies),
          cashExs: CashEx.grab(
              priorObstructionum.interioreObstructionum.cashExDifficultas, p2p.cashExs));
      //the bug is that we add it to efectus threads
      // efectusThreads
      newThreads.add(await Isolate.spawn(Obstructionum.expressi,
          List<dynamic>.from([interiore, toCrack, acciperePortus.sendPort])));
      // if (i == efectusThreads.length) {
      //     newThreads.forEach(efectusThreads.add);
      // }
    }
    newThreads.forEach(expressiThreads.add);
    acciperePortus.listen((nuntius) async {
      while (isSalutaris) {
        await Future.delayed(Duration(seconds: 1));
      }
      isSalutaris = true;
      Obstructionum obstructionum = nuntius as Obstructionum;
      Obstructionum priorObs = await Utils.priorObstructionum(directory);
      if (ListEquality().equals(
          obstructionum.interioreObstructionum.obstructionumNumerus,
          priorObs.interioreObstructionum.obstructionumNumerus)) {
        print('invalid blocknumber retrying');
        p2p.expressiRp.sendPort.send("update miner");
        isSalutaris = false;
        return;
      }
      if (priorObs.probationem !=
          obstructionum.interioreObstructionum.priorProbationem) {
        print('invalid probationem');
        p2p.expressiRp.sendPort.send("update miner");
        isSalutaris = false;
        return;
      }
      if (priorObs.interioreObstructionum.generare != Generare.EFECTUS) {
        print('expressi must be on top of efectus');
        p2p.expressiRp.sendPort.send("update miner");
        isSalutaris = false;
        return;
      }
      Gladiator gladiator = obstructionum.interioreObstructionum.gladiator;
      if (!await Obstructionum.gladiatorSpiritus(
          gladiator.input!.index, gladiator.input!.gladiatorId, directory)) {
        print('gladiator not found');
        return;
      }
      List<GladiatorOutput> outputs = [];
      for (GladiatorOutput output
          in obstructionum.interioreObstructionum.gladiator.outputs) {
        output.rationem.map((r) => r.interioreRationem.id).forEach(
            (id) => propterIsolates[id]?.kill(priority: Isolate.immediate));
      }
      obstructionum.interioreObstructionum.liberTransactions
          .map((e) => e.interioreTransaction.id)
          .forEach(
              (id) => liberTxIsolates[id]?.kill(priority: Isolate.immediate));
      obstructionum.interioreObstructionum.fixumTransactions
          .map((e) => e.interioreTransaction.id)
          .forEach(
              (id) => fixumTxIsolates[id]?.kill(priority: Isolate.immediate));
      obstructionum.interioreObstructionum.cashExs
          .map((c) => c.interioreCashEx.signumCashEx.id)
          .forEach(
              (id) => cashExIsolates[id]?.kill(priority: Isolate.immediate));
      obstructionum.interioreObstructionum.scans
          .map((s) => s.interioreScan.id)
          .forEach((id) => scanIsolates[id]?.kill(priority: Isolate.immediate));
      p2p.removeScans(obstructionum.interioreObstructionum.scans
          .map((s) => s.interioreScan.id)
          .toList());
      p2p.removeCashExs(obstructionum.interioreObstructionum.cashExs
          .map((c) => c.interioreCashEx.signumCashEx.id)
          .toList());
      List<String> gladiatorIds = [];
      for (GladiatorOutput output in outputs) {
        gladiatorIds.addAll(
            output.rationem.map((r) => r.interioreRationem.id).toList());
      }
      p2p.removePropters(gladiatorIds);
      p2p.removeLiberTxs(obstructionum.interioreObstructionum.liberTransactions
          .map((l) => l.interioreTransaction.id)
          .toList());
      p2p.removeFixumTxs(obstructionum.interioreObstructionum.fixumTransactions
          .map((f) => f.interioreTransaction.id)
          .toList());
      await Isolate.spawn(
          P2P.syncBlock,
          List<dynamic>.from([
            obstructionum,
            p2p.sockets,
            directory,
            '${aboutconfig.internumIp}:${aboutconfig.p2pPortus}'
          ]));
      expressiThreads = [];
      await obstructionum.salvare(directory);
      p2p.expressieTxs = [];
      isSalutaris = false;
    });
  }
}
