import 'package:conduit/conduit.dart';
import 'dart:isolate';
import 'package:conduit/conduit.dart';
import 'package:elliptic/elliptic.dart';
import 'package:appologi_es/models/cash_ex.dart';
import 'package:appologi_es/models/humanify.dart';
import 'package:appologi_es/models/scan.dart';
import 'package:appologi_es/appologi_es.dart';
import 'package:appologi_es/models/aboutconfig.dart';
import 'package:appologi_es/models/exampla.dart';
import 'package:appologi_es/models/gladiator.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:appologi_es/models/pera.dart';
import 'package:appologi_es/models/transaction.dart';
import 'package:appologi_es/p2p.dart';
import 'package:tuple/tuple.dart';
import '../models/constantes.dart';
import '../models/utils.dart';
import 'package:collection/collection.dart';

class MineExpressiController extends ResourceController {
  Directory directory;
  P2P p2p;
  Aboutconfig aboutconfig;
  List<Isolate> expressiThreads;
  List<Isolate> syncExpressiBlocks = [];
  bool isExpressi = false;
  String gladiatorExpressiId = "";
  int gladiatorExpressiIndex = 0;
  String gladiatorExpressiPrivateKey = "";
  bool isSalutaris;
  Map<String, Isolate> propterIsolates;
  Map<String, Isolate> liberTxIsolates;
  Map<String, Isolate> fixumTxIsolates;
  Map<String, Isolate> humanifyIsolates;
  Map<String, Isolate> scanIsolates;
  Map<String, Isolate> cashExIsolates;
  MineExpressiController(
      this.directory,
      this.p2p,
      this.aboutconfig,
      this.isSalutaris,
      this.propterIsolates,
      this.liberTxIsolates,
      this.fixumTxIsolates,
      this.expressiThreads,
      this.humanifyIsolates,
      this.scanIsolates,
      this.cashExIsolates);
  @Operation.post()
  Future<Response> mine(@Bind.body() Confussus conf) async {
    if (!File('${directory.path}/${Constantes.fileNomen}0.txt').existsSync()) {
      return Response.badRequest(
          body: {"message": "Still waiting on incipio block"});
    }
    List<Transaction> liberTxs = [];
    List<Transaction> fixumTxs = [];
    p2p.isExpressiActive = true;
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
    // Confussus conf = Confussus.fromJson(await request!.body.decode());
    Gladiator gladiatorToAttack =
        await Obstructionum.grabGladiator(conf.gladiatorId!, directory);
    if (!await Obstructionum.gladiatorSpiritus(
        conf.index!, gladiatorToAttack.id, directory)) {
      return Response.forbidden(body: {
        "code": 0,
        "message": "Gladiator non inveni",
        "english": "Gladiator not found"
      });
    }
    PrivateKey pk = PrivateKey.fromHex(Pera.curve(), conf.privateKey!);
    print(await Obstructionum.gladiatorConfodiantur(
        conf.gladiatorId!, pk.publicKey.toHex(), directory));
    if (await Obstructionum.gladiatorConfodiantur(
        conf.gladiatorId!, pk.publicKey.toHex(), directory)) {
      return Response.badRequest(body: {
        "code": 0,
        "message": "Non te oppugnare",
        "english": "Can not attack yourself"
      });
    }
    gladiatorExpressiId = gladiatorToAttack.id;
    gladiatorExpressiIndex = 0;
    gladiatorExpressiPrivateKey = conf.privateKey!;
    for (String acc in gladiatorToAttack.outputs[conf.index!].rationem
        .map((e) => e.interioreRationem.publicaClavis)) {
      final balance = await Pera.statera(true, acc, directory);
      if (balance > BigInt.zero) {
        liberTxs.add(Transaction.burn(await Pera.ardeat(
            PrivateKey.fromHex(Pera.curve(), conf.privateKey!),
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
        true, conf.index!, gladiatorToAttack.id, directory);
    deschef.addAll(await Pera.maximeDefensiones(
        false, conf.index!, gladiatorToAttack.id, directory));
    List<String> toCrack = deschef.map((e) => e.defensio).toList();
    final base = await Pera.turpiaGladiatoriaDefensione(
        conf.index!, gladiatorToAttack.id, directory);
    toCrack.add(base.defensio);
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
              conf.index!,
              Utils.signum(PrivateKey.fromHex(Pera.curve(), conf.privateKey!),
                  gladiatorToAttack.outputs[conf.index!]),
              conf.gladiatorId!),
          [],
          Utils.randomHex(32)),
      liberTransactions: liberTxs,
      fixumTransactions: fixumTxs,
      expressiTransactions: [],
      scans: Scan.grab(
          priorObstructionum.interioreObstructionum.scanDifficultas, p2p.scans),
      cashExs: CashEx.grab(
          priorObstructionum.interioreObstructionum.cashExDifficultas,
          p2p.cashExs),
      humanify: Humanify.grab(p2p.humanifies),
    );
    expressiThreads.add(await Isolate.spawn(Obstructionum.expressi,
        List<dynamic>.from([interiore, toCrack, acciperePortus.sendPort])));
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
        //before we return we update the send port is that the problem or should it
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
          .forEach((id) => scanIsolates[id]?.kill(priority: Isolate.immediate));
      p2p.removeScans(obstructionum.interioreObstructionum.scans
          .map((s) => s.interioreScan.id)
          .toList());
      p2p.removeCashExs(obstructionum.interioreObstructionum.cashExs
          .map((c) => c.interioreCashEx.signumCashEx.id)
          .toList());

      p2p.removePropters(gladiatorIds);
      p2p.removeLiberTxs(obstructionum.interioreObstructionum.liberTransactions
          .map((l) => l.interioreTransaction.id)
          .toList());
      p2p.removeFixumTxs(obstructionum.interioreObstructionum.fixumTransactions
          .map((f) => f.interioreTransaction.id)
          .toList());

      syncExpressiBlocks
          .forEach((element) => element.kill(priority: Isolate.immediate));
      syncExpressiBlocks.add(await Isolate.spawn(
          P2P.syncBlock,
          List<dynamic>.from([
            obstructionum,
            p2p.sockets,
            directory,
            '${aboutconfig.internumIp}:${aboutconfig.p2pPortus}'
          ])));
      expressiThreads = [];
      await obstructionum.salvare(directory);
      p2p.expressieTxs = [];
      isExpressi = false;
      isSalutaris = false;
    });
    return Response.ok({
      "message": "coepi expressi miner",
      "english": "started expressi miner",
      "threads": expressiThreads.length
    });
  }

  @Operation.get()
  Future<Response> threads() async {
    return Response.ok({"threads": expressiThreads.length});
  }

  @Operation.delete()
  Future<Response> deschel() async {
    expressiThreads.forEach((e) => e.kill(priority: Isolate.immediate));
    return Response.ok({
      "message": "bene substitit expressi miner",
      "english": "succesfully stopped expressi miner",
    });
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    if (operation.method == "POST") {
      return {
        "200": APIResponse.schema(
            "Started the expressi miner to see confussus explaination and reproduce all transactions of an efectus block (can only be on top)",
            APISchemaObject.object({
              "message": APISchemaObject.string(),
              "english": APISchemaObject.string(),
              "threads": APISchemaObject.integer()
            }))
      };
    } else if (operation.method == 'GET') {
      return {
        "200": APIResponse.schema(
            "Fetch the amount of expressi threads",
            APISchemaObject.object({
              "threads": APISchemaObject.integer(),
            }))
      };
    } else {
      return {
        "200": APIResponse.schema(
            "Stop the expressi miner",
            APISchemaObject.object({
              "message": APISchemaObject.string(),
              "english": APISchemaObject.string(),
            }))
      };
    }
  }

  @override
  void documentComponents(APIDocumentContext context) {
    super.documentComponents(context);

    final personSchema = Confussus().documentSchema(context);
    context.schema.register("Person", personSchema, representation: Confussus);
  }
}
