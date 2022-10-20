import 'dart:io';
import 'dart:isolate';

import 'package:elliptic/elliptic.dart';
import 'package:appologi_es/models/cash_ex.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:appologi_es/models/pera.dart';
import 'package:appologi_es/models/scan.dart';
import 'package:appologi_es/models/utils.dart';
import 'package:collection/collection.dart';
import 'package:appologi_es/appologi_es.dart';
import 'package:appologi_es/models/errors.dart';
import 'package:appologi_es/p2p.dart';
import 'package:appologi_es/models/pera.dart';

class CashExController extends ResourceController {
  Directory directory;
  P2P p2p;
  Map<String, Isolate> cashExIsolates;
  CashExController(this.directory, this.p2p, this.cashExIsolates);

  @Operation.get('key')
  Future<Response> balance(@Bind.path('key') String publica) async {
    List<Obstructionum> lobstructionum =
        await Utils.getObstructionums(directory);
    List<List<CashEx>> llcashex =
        lobstructionum.map((e) => e.interioreObstructionum.cashExs).toList();
    BigInt statera = await staschatescherascha(publica);
    BigInt redimitur = statera;
    List<List<BigInt>> exs = llcashex
        .where((w) =>
            w.any((a) => a.interioreCashEx.signumCashEx.public == publica))
        .map((m) => m.map((im) => im.interioreCashEx.signumCashEx.nof).toList())
        .toList();
    List<BigInt> exss = [];
    BigInt redempti = BigInt.zero;
    exs.forEach(exss.addAll);
    for (BigInt ex in exss) {
      redimitur -= ex;
      redempti += BigInt.one;
    }
    return Response.ok({
      "redimitur": redimitur.toString(),
      "redempti": redempti.toString(),
      "total": statera.toString()
    });
  }

  @Operation.post('key')
  Future<Response> ex(@Bind.path('key') String privatus) async {
    final PrivateKey pk = PrivateKey.fromHex(Pera.curve(), privatus);
    final String publicKey = pk.publicKey.toHex();
    if (!await Pera.isPublicaClavisDefended(publicKey, directory)) {
      return Response.badRequest(
          body: Error(
                  code: 0,
                  message: "accipientis non defenditur",
                  english: "public key is not defended")
              .toJson());
    }
    final List<Obstructionum> lobstructionum =
        await Utils.getObstructionums(directory);
    List<List<CashEx>> llcashex =
        lobstructionum.map((e) => e.interioreObstructionum.cashExs).toList();
    BigInt statera = await staschatescherascha(publicKey);
    final List<List<BigInt>> exs = llcashex
        .where((w) =>
            w.any((a) => a.interioreCashEx.signumCashEx.public == publicKey))
        .map((m) => m.map((im) => im.interioreCashEx.signumCashEx.nof).toList())
        .toList();
    final List<BigInt> exss = [];
    exs.forEach(exss.addAll);
    for (BigInt ex in exss) {
      statera -= ex;
    }
    final signumCashEx =
        SignumCashEx(nof: statera, public: publicKey, nonce: BigInt.zero);
    InterioreCashEx interiore = InterioreCashEx(
        signumCashEx: signumCashEx, signature: Utils.signum(pk, signumCashEx));
    ReceivePort acciperePortus = ReceivePort();
    cashExIsolates[interiore.signumCashEx.id] = await Isolate.spawn(
        CashEx.quaestum,
        List<dynamic>.from([interiore, acciperePortus.sendPort]));
    acciperePortus.listen((data) {
      p2p.syncCashEx(data as CashEx);
    });
    return Response.ok({"redempti": statera.toString()});
  }

  @Operation.get()
  Future<Response> pool() async {
    return Response.ok(p2p.cashExs);
  }

  Future<BigInt> staschatescherascha(String basis) async {
    List<Obstructionum> lo = await Utils.getObstructionums(directory);
    List<List<Scan>> llscanm =
        lo.map((e) => e.interioreObstructionum.scans).toList();
    Scan? scanBasis = llscanm.firstWhereOrNull((element) =>
        element.any((a) => a.interioreScan.output.prior == basis))?[0];
    if (scanBasis == null) {
      return BigInt.zero;
      throw (Error(
          message: "publica clavem non lustrabat lumine adhuc",
          english: 'Public key is not scanned yet',
          code: 0));
    }

    List<String> novuses = [scanBasis.interioreScan.output.prior];
    List<String> todos = [];
    BigInt statera = BigInt.zero;
    while (true) {
      todos = [];
      print('novuses');
      print(novuses);
      for (String novus in novuses) {
        llscanm
            .where((w) => w.any((a) => a.interioreScan.output.prior == novus))
            .map((m) => m.map((im) => im.interioreScan.output.novus))
            .forEach((element) {
          todos.addAll(element);
          statera += BigInt.one;
        });
      }
      if (todos.isEmpty) {
        break;
      }
      print('todos');
      print(todos);
      novuses = [];
      for (String todo in todos) {
        llscanm
            .where((w) => w.any((a) => a.interioreScan.output.prior == todo))
            .map((m) => m.map((im) => im.interioreScan.output.novus))
            .forEach((element) {
          novuses.addAll(element);
          statera += BigInt.one;
        });
      }
    }
    return statera;
  }
}
