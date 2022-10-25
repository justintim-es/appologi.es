import 'dart:core';
import 'dart:isolate';

import 'package:appologi_es/controllers/answer_controller.dart';
import 'package:appologi_es/controllers/defensio_bid_controller.dart';
import 'package:appologi_es/controllers/defensio_controller.dart';
import 'package:appologi_es/controllers/gladiator_controller.dart';
import 'package:appologi_es/controllers/hash_controller.dart';
import 'package:appologi_es/controllers/humanify_controller.dart';
import 'package:appologi_es/controllers/mine_confussus_controller.dart';
import 'package:appologi_es/controllers/mine_efectus_controller.dart';
import 'package:appologi_es/controllers/mine_expressi_controller.dart';
import 'package:appologi_es/controllers/network_controller.dart';
import 'package:appologi_es/controllers/obstructionum_controller.dart';
import 'package:appologi_es/controllers/quaestio_controller.dart';
import 'package:appologi_es/controllers/rationem_controller.dart';
import 'package:appologi_es/controllers/rationem_stagnum_controller.dart';
import 'package:appologi_es/controllers/respondere_controller.dart';
import 'package:appologi_es/controllers/scan_controller.dart';
import 'package:appologi_es/controllers/scans_controller.dart';
import 'package:appologi_es/controllers/statera_controller.dart';
import 'package:appologi_es/controllers/transaction_controller.dart';
import 'package:appologi_es/controllers/transaction_expressi_controller.dart';
import 'package:appologi_es/controllers/transaction_fixum_controller.dart';
import 'package:appologi_es/controllers/transaction_liber_controller.dart';
import 'package:appologi_es/appologi_es.dart';
import 'package:appologi_es/helpers/rp.dart';
import 'package:appologi_es/models/aboutconfig.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:appologi_es/controllers/numerus_controller.dart';
import 'package:appologi_es/models/utils.dart';
import 'package:appologi_es/p2p.dart';
import 'package:appologi_es/controllers/probationem_controller.dart';
import 'package:appologi_es/controllers/cash_ex_controller.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://conduit.io/docs/http/channel/.
class AppologiEsChannel extends ApplicationChannel {
  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  Aboutconfig? aboutconfig;
  Directory? directory;
  P2P? p2p;
  Map<String, Isolate> propterIsolates = Map();
  Map<String, Isolate> liberTxIsolates = Map();
  Map<String, Isolate> fixumTxIsolates = Map();
  Map<String, Isolate> humanifyIsolates = Map();
  Map<String, Isolate> scanIsolates = Map();
  Map<String, Isolate> cashExIsolates = Map();
  List<Isolate> efectusThreads = [];
  List<Isolate> confussuses = [];
  List<Isolate> expressiThreads = [];
  bool isSalutaris = false;
  String confussusGladiatorId = "";
  int confussusGladiatorIndex = 0;
  String confussusGladiatorPrivateKey = "";
  String expressiGladiatorId = "";
  int expressiGladiatorIndex = 0;
  String expressiGladiatorPrivateKey = "";
  bool isExpressi = false;
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    CORSPolicy.defaultPolicy.allowedOrigins = ["*"];
    aboutconfig = Aboutconfig(options!.configurationFilePath!);
    directory =
        await Directory(aboutconfig!.directory!).create(recursive: true);
    if (aboutconfig!.novus! && directory!.listSync().isEmpty) {
      Obstructionum obs = Obstructionum.incipio(InterioreObstructionum.incipio(
          producentis: aboutconfig!.publicaClavis!));
      await obs.salvareIncipio(directory!);
    }
    p2p = P2P(
        aboutconfig!.maxPares!,
        Utils.randomHex(32),
        '${aboutconfig!.internumIp!}:${aboutconfig!.p2pPortus}',
        directory!,
        [0]);
    p2p!.listen(aboutconfig!.internumIp!, int.parse(aboutconfig!.p2pPortus!));
    if (aboutconfig!.bootnode != null) {
      p2p!.connect(aboutconfig!.bootnode!,
          '${aboutconfig!.externalIp!}:${aboutconfig!.p2pPortus}');
    }
    p2p!.efectusRp.listen((message) {
      Rp.efectus(
          isSalutaris,
          efectusThreads,
          propterIsolates,
          liberTxIsolates,
          fixumTxIsolates,
          scanIsolates,
          cashExIsolates,
          p2p!,
          aboutconfig!,
          directory!);
    });
    p2p!.confussusRp.listen((message) {
      Rp.confussus(
          isSalutaris,
          confussusGladiatorIndex,
          confussusGladiatorPrivateKey,
          confussusGladiatorId,
          confussuses,
          propterIsolates,
          liberTxIsolates,
          fixumTxIsolates,
          scanIsolates,
          cashExIsolates,
          p2p!,
          aboutconfig!,
          directory!);
    });
    p2p!.expressiRp.listen((message) {
      if (message == false) {
        isExpressi = false;
        expressiThreads.forEach((e) => e.kill(priority: Isolate.immediate));
        return;
      }
      Rp.expressi(
          isExpressi,
          isSalutaris,
          expressiGladiatorIndex,
          expressiGladiatorPrivateKey,
          expressiGladiatorId,
          confussuses,
          propterIsolates,
          liberTxIsolates,
          fixumTxIsolates,
          scanIsolates,
          cashExIsolates,
          p2p!,
          aboutconfig!,
          directory!);
    });
  }

  /// Construct the request chann
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://conduit.io/docs/http/request_controller/
    router.route("/example").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });
    router
        .route('/defensio-bid/:liber/:index/:probationem/[:gladiatorId]')
        .link(() => DefensioBidController(directory!));
    router
        .route('/defensio/:index/:gladiatorId/[:liber]')
        .link(() => DefensioController(directory!));
    router
        .route('/gladiators/[:publica]')
        .link(() => GladiatorsController(directory!));
    router.route('/mine-efectus/[:loop]').link(() => MineEfectusController(
        directory!,
        p2p!,
        aboutconfig!,
        propterIsolates,
        liberTxIsolates,
        fixumTxIsolates,
        isSalutaris,
        efectusThreads,
        humanifyIsolates,
        scanIsolates,
        cashExIsolates));
    router.route('/mine-confussus').link(() => MineConfussusController(
        directory!,
        p2p!,
        aboutconfig!,
        isSalutaris,
        propterIsolates,
        liberTxIsolates,
        fixumTxIsolates,
        confussuses,
        humanifyIsolates,
        scanIsolates,
        cashExIsolates));
    router.route('/mine-expressi').link(() => MineExpressiController(
        directory!,
        p2p!,
        aboutconfig!,
        isSalutaris,
        propterIsolates,
        liberTxIsolates,
        fixumTxIsolates,
        expressiThreads,
        humanifyIsolates,
        scanIsolates,
        cashExIsolates));
    router.route('/network').link(() => NetworkController(p2p!));
    router.route('/numerus').link(() => NumerusController(directory!));
    router
        .route('/rationem/[:identitatis]')
        .link(() => RationemController(directory!, p2p!, propterIsolates));
    router
        .route('/rationem-stagnum')
        .link(() => RationemStagnumController(p2p!));
    router
        .route('/obstructionum[/:probationem]')
        .link(() => ObstructionumController(directory!, p2p!));
    router
        .route('/statera/:liber/:publica')
        .link(() => StateraController(directory!));
    router
        .route('/transaction/:identitatis')
        .link(() => TransactionController(directory!, p2p!));
    router.route('/transaction-liber').link(
        () => TransactionLiberController(directory!, p2p!, liberTxIsolates));
    router.route('/transaction-fixum').link(
        () => TransactionFixumController(directory!, p2p!, fixumTxIsolates));
    router
        .route('/transaction-expressi')
        .link(() => TransactionExpressiController(p2p!));
    router.route('/probationem').link(() => ProbationemController(directory!));
    // router.route('/scan/:privatus').link(() => ScanController(directory!, p2p!));
    router
        .route('/humanify/[:dominus[/:quaestio[/:respondere]]]')
        .link(() => HumanifyController(directory!, p2p!, humanifyIsolates));
    router.route('/respondere/:answer').link(() => RespondereController());
    router
        .route('/scan/[:probationem]')
        .link(() => ScanController(directory!, p2p!));
    router.route('/hash/:index/:answer').link(() => HashController());
    router
        .route('/answer')
        .link(() => AnswerController(directory!, p2p!, scanIsolates));
    router
        .route('/cash-ex/[:key]')
        .link(() => CashExController(directory!, p2p!, cashExIsolates));
    router
        .route('/quaestio/:probationem')
        .link(() => QuaestioController(directory!));
    router.route('/scans').link(() => ScansController(p2p!));
    return router;
  }
}
