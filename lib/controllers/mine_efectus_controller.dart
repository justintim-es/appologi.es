import 'dart:isolate';
import 'package:conduit/conduit.dart';
import 'package:appologi_es/models/cash_ex.dart';
import 'package:appologi_es/models/humanify.dart';
import 'package:appologi_es/models/scan.dart';
import 'package:appologi_es/appologi_es.dart';
import 'package:appologi_es/models/aboutconfig.dart';
import 'package:appologi_es/models/gladiator.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:appologi_es/models/transaction.dart';
import 'package:appologi_es/p2p.dart';
import '../models/constantes.dart';
import '../models/utils.dart';
import 'package:collection/collection.dart';

class MineEfectusController extends ResourceController {
  Directory directory;
  P2P p2p;
  Aboutconfig aboutconfig;
  bool isSalutaris;
  Map<String, Isolate> propterIsolates;
  Map<String, Isolate> liberTxIsolates;
  Map<String, Isolate> fixumTxIsolates;
  List<Isolate> efectusThreads;
  Map<String, Isolate> humanifyIsolates;
  Map<String, Isolate> scanIsolates;
  Map<String, Isolate> cashExIsolates;
  MineEfectusController(
      this.directory,
      this.p2p,
      this.aboutconfig,
      this.propterIsolates,
      this.liberTxIsolates,
      this.fixumTxIsolates,
      this.isSalutaris,
      this.efectusThreads,
      this.humanifyIsolates,
      this.scanIsolates,
      this.cashExIsolates);

  @Operation.post('loop')
  Future<Response> mine(@Bind.path('loop') String loop) async {
    try {
      if (!File('${directory.path}/${Constantes.fileNomen}0.txt')
          .existsSync()) {
        return Response.badRequest(
            body: {"message": "Still waiting on incipio block"});
      }
      print('gothere');
      Obstructionum priorObstructionum =
          await Utils.priorObstructionum(directory);
      ReceivePort acciperePortus = ReceivePort();
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
      BigInt numerus = BigInt.zero;
      for (int nuschum
          in await Obstructionum.utObstructionumNumerus(directory)) {
        numerus += BigInt.parse(nuschum.toString());
      }
      List<Scan> praemium = priorObstructionum.interioreObstructionum.scans;
      List<List<Scan>> scaschans = [];
      List<Obstructionum> obss = await Utils.getObstructionums(directory);
      for (Obstructionum obs in obss) {
        scaschans.add(obs.interioreObstructionum.scans);
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
                  l.interioreTransaction.id ==
                  tx.interioreTransaction.expressi))
              .toList(),
          scans: Scan.grab(
              priorObstructionum.interioreObstructionum.scanDifficultas,
              p2p.scans),
          humanify: Humanify.grab(p2p.humanifies),
          cashExs: CashEx.grab(
              priorObstructionum.interioreObstructionum.cashExDifficultas,
              p2p.cashExs));
      efectusThreads.add(await Isolate.spawn(Obstructionum.efectus,
          List<dynamic>.from([interiore, acciperePortus.sendPort])));
      p2p.isEfectusActive = true;
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
          p2p.efectusRp.sendPort.send("update miner");
          isSalutaris = false;
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
        List<String> gladiatorIds = [];
        for (GladiatorOutput output in outputs) {
          gladiatorIds.addAll(
              output.rationem.map((r) => r.interioreRationem.id).toList());
        }
        humanifyIsolates[
                obstructionum.interioreObstructionum.humanify?.interiore.id]
            ?.kill(priority: Isolate.immediate);
        if (obstructionum.interioreObstructionum.humanify != null) {
          p2p.removeHumanify(
              obstructionum.interioreObstructionum.humanify!.interiore.id);
        }
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
        p2p.removePropters(gladiatorIds);
        p2p.removeLiberTxs(obstructionum
            .interioreObstructionum.liberTransactions
            .map((l) => l.interioreTransaction.id)
            .toList());
        p2p.removeFixumTxs(obstructionum
            .interioreObstructionum.fixumTransactions
            .map((f) => f.interioreTransaction.id)
            .toList());
        ReceivePort rp = ReceivePort();
        p2p.syncBlocks.forEach((e) => e.kill(priority: Isolate.immediate));
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
        if (loop == 'true') {
          p2p.efectusRp.sendPort.send("update miner");
        }
        if (p2p.isConfussusActive) {
          p2p.confussusRp.sendPort.send('update miner');
        }
        if (p2p.isExpressiActive) {
          p2p.expressiRp.sendPort.send("update miner");
        }
        isSalutaris = false;
      });
      return Response.ok({
        "message": "coepi efectus miner",
        "english": "started efectus miner",
        "threads": efectusThreads.length
      });
    } catch (err, s) {
      print(err);
      print(s);
      return Response.badRequest();
    }
  }

  @Operation.get()
  Future<Response> threads() async {
    return Response.ok({"threads": efectusThreads.length});
  }

  @Operation.delete()
  Future<Response> deschel() async {
    efectusThreads.forEach((e) => e.kill(priority: Isolate.immediate));
    return Response.ok({
      "message": "bene substitit efectus miner",
      "english": "succesfully stopped efectus miner",
    });
  }
}
