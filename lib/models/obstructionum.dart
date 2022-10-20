import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:appologi_es/models/cash_ex.dart';
import 'package:appologi_es/models/constantes.dart';
import 'package:appologi_es/models/exampla.dart';
import 'package:appologi_es/models/gladiator.dart';
import 'package:appologi_es/models/humanify.dart';
import 'package:appologi_es/models/scan.dart';
import 'package:appologi_es/models/transaction.dart';
import 'package:appologi_es/models/utils.dart';
import 'package:appologi_es/models/gladiator.dart';
import 'package:appologi_es/models/transaction.dart';
import 'package:hex/hex.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:isolate';
import 'package:appologi_es/models/pera.dart';
import 'package:tuple/tuple.dart';
import 'package:dbcrypt/dbcrypt.dart';

enum Generare { INCIPIO, EFECTUS, CONFUSSUS, EXPRESSI }

extension GenerareFromJson on Generare {
  static fromJson(String name) {
    switch (name) {
      case 'INCIPIO':
        return Generare.INCIPIO;
      case 'EFECTUS':
        return Generare.EFECTUS;
      case 'CONFUSSUS':
        return Generare.CONFUSSUS;
      case 'EXPRESSI':
        return Generare.EXPRESSI;
    }
  }
}

class InterioreObstructionum {
  final Generare generare;
  int obstructionumDifficultas;
  int indicatione;
  BigInt nonce;
  final double divisa;
  final int propterDifficultas;
  final int liberDifficultas;
  final int fixumDifficultas;
  final int scanDifficultas;
  final int cashExDifficultas;
  final BigInt summaObstructionumDifficultas;
  final BigInt forumCap;
  final BigInt liberForumCap;
  final BigInt fixumForumCap;
  final List<int> obstructionumNumerus;
  String? defensio;
  final String producentis;
  final String priorProbationem;
  final Gladiator gladiator;
  final List<Transaction> liberTransactions;
  final List<Transaction> fixumTransactions;
  final List<Transaction> expressiTransactions;
  final List<Scan> scans;
  final List<CashEx> cashExs;
  Humanify? humanify;
  InterioreObstructionum({
    required this.generare,
    required this.obstructionumDifficultas,
    required this.divisa,
    required this.summaObstructionumDifficultas,
    required this.forumCap,
    required this.liberForumCap,
    required this.fixumForumCap,
    required this.propterDifficultas,
    required this.liberDifficultas,
    required this.fixumDifficultas,
    required this.scanDifficultas,
    required this.cashExDifficultas,
    required this.obstructionumNumerus,
    required this.defensio,
    required this.producentis,
    required this.priorProbationem,
    required this.gladiator,
    required this.liberTransactions,
    required this.fixumTransactions,
    required this.expressiTransactions,
    required this.scans,
    required this.cashExs,
    required this.humanify,
  })  : indicatione = DateTime.now().microsecondsSinceEpoch,
        nonce = BigInt.zero {
    BigInt total = BigInt.zero;
    for (int nuschum in obstructionumNumerus) {
      total += BigInt.parse(nuschum.toString());
    }
  }

  InterioreObstructionum.incipio({required this.producentis})
      : generare = Generare.INCIPIO,
        obstructionumDifficultas = 1,
        divisa = 0,
        propterDifficultas = 0,
        liberDifficultas = 0,
        fixumDifficultas = 0,
        scanDifficultas = 0,
        cashExDifficultas = 0,
        indicatione = DateTime.now().microsecondsSinceEpoch,
        nonce = BigInt.zero,
        summaObstructionumDifficultas = BigInt.one,
        forumCap = BigInt.zero,
        liberForumCap = BigInt.zero,
        fixumForumCap = BigInt.zero,
        obstructionumNumerus = [0],
        defensio = Utils.randomHex(1),
        priorProbationem = '',
        gladiator = Gladiator(
            null,
            List<GladiatorOutput>.from([
              GladiatorOutput(List<Propter>.from(
                  [Propter.incipio(InterioreRationem.incipio(producentis))]))
            ]),
            Utils.randomHex(32)),
        liberTransactions = List<Transaction>.from([
          Transaction(
              Constantes.txObstructionumPraemium,
              InterioreTransaction(
                  true,
                  [],
                  [
                    TransactionOutput(
                        producentis, Constantes.obstructionumPraemium, null)
                  ],
                  Utils.randomHex(32)))
        ]),
        fixumTransactions = [],
        expressiTransactions = [],
        cashExs = [],
        scans = [
          Scan(
              InterioreScan(
                  output: ScanOutput(prior: '', novus: producentis),
                  humanifyAnswer: null),
              '')
        ];

  InterioreObstructionum.efectus({
    required this.obstructionumDifficultas,
    required this.summaObstructionumDifficultas,
    required this.divisa,
    required this.forumCap,
    required this.liberForumCap,
    required this.fixumForumCap,
    required this.propterDifficultas,
    required this.liberDifficultas,
    required this.fixumDifficultas,
    required this.cashExDifficultas,
    required this.scanDifficultas,
    required this.obstructionumNumerus,
    required this.producentis,
    required this.priorProbationem,
    required this.gladiator,
    required this.liberTransactions,
    required this.fixumTransactions,
    required this.expressiTransactions,
    required this.scans,
    required this.cashExs,
    required this.humanify,
  })  : generare = Generare.EFECTUS,
        indicatione = DateTime.now().microsecondsSinceEpoch,
        nonce = BigInt.zero,
        defensio = Utils.randomHex(1);

  InterioreObstructionum.confussus(
      {required this.obstructionumDifficultas,
      required this.summaObstructionumDifficultas,
      required this.divisa,
      required this.forumCap,
      required this.fixumForumCap,
      required this.liberForumCap,
      required this.propterDifficultas,
      required this.liberDifficultas,
      required this.fixumDifficultas,
      required this.scanDifficultas,
      required this.cashExDifficultas,
      required this.obstructionumNumerus,
      required this.producentis,
      required this.priorProbationem,
      required this.gladiator,
      required this.liberTransactions,
      required this.fixumTransactions,
      required this.expressiTransactions,
      required this.scans,
      required this.cashExs,
      required this.humanify})
      : generare = Generare.CONFUSSUS,
        indicatione = DateTime.now().microsecondsSinceEpoch,
        nonce = BigInt.zero;
  InterioreObstructionum.expressi({
    required this.obstructionumDifficultas,
    required this.summaObstructionumDifficultas,
    required this.forumCap,
    required this.liberForumCap,
    required this.fixumForumCap,
    required this.divisa,
    required this.propterDifficultas,
    required this.liberDifficultas,
    required this.fixumDifficultas,
    required this.cashExDifficultas,
    required this.scanDifficultas,
    required this.obstructionumNumerus,
    required this.producentis,
    required this.priorProbationem,
    required this.gladiator,
    required this.liberTransactions,
    required this.fixumTransactions,
    required this.expressiTransactions,
    required this.scans,
    required this.cashExs,
    required this.humanify,
  })  : generare = Generare.EXPRESSI,
        indicatione = DateTime.now().microsecondsSinceEpoch,
        nonce = BigInt.zero;

  mine() {
    indicatione = DateTime.now().microsecondsSinceEpoch;
    nonce += BigInt.one;
  }

  Map toJson() => {
        'generare': generare.name.toString(),
        'obstructionumDifficultas': obstructionumDifficultas,
        'divisa': divisa.toString(),
        'propterDifficultas': propterDifficultas,
        'liberDifficultas': liberDifficultas,
        'fixumDifficultas': fixumDifficultas,
        'scanDifficultas': scanDifficultas,
        'cashExDifficultas': cashExDifficultas,
        'indicatione': indicatione,
        'nonce': nonce.toString(),
        'summaObstructionumDifficultas':
            summaObstructionumDifficultas.toString(),
        'forumCap': forumCap.toString(),
        'liberForumCap': liberForumCap.toString(),
        'fixumForumCap': fixumForumCap.toString(),
        'obstructionumNumerus': obstructionumNumerus.toList(),
        'defensio': defensio,
        'producentis': producentis,
        'priorProbationem': priorProbationem,
        'gladiator': gladiator.toJson(),
        'liberTransactions': liberTransactions.map((e) => e.toJson()).toList(),
        'fixumTransactions': fixumTransactions.map((e) => e.toJson()).toList(),
        'expressiTransactions':
            expressiTransactions.map((e) => e.toJson()).toList(),
        'scans': scans.map((e) => e.toJson()).toList(),
        'humanify': humanify?.toJson(),
        'cashExs': cashExs.map((e) => e.toJson()).toList(),
      }..removeWhere((key, value) => value == null);
  InterioreObstructionum.fromJson(Map jsoschon)
      : generare = GenerareFromJson.fromJson(jsoschon['generare'].toString())
            as Generare,
        obstructionumDifficultas =
            int.parse(jsoschon['obstructionumDifficultas'].toString()),
        propterDifficultas =
            int.parse(jsoschon['propterDifficultas'].toString()),
        divisa = double.parse(jsoschon['divisa'].toString()),
        liberDifficultas = int.parse(jsoschon['liberDifficultas'].toString()),
        fixumDifficultas = int.parse(jsoschon['fixumDifficultas'].toString()),
        cashExDifficultas = int.parse(jsoschon['cashExDifficultas'].toString()),
        scanDifficultas = int.parse(jsoschon['scanDifficultas'].toString()),
        indicatione = int.parse(jsoschon['indicatione'].toString()),
        nonce = BigInt.parse(jsoschon['nonce'].toString()),
        summaObstructionumDifficultas =
            BigInt.parse(jsoschon['summaObstructionumDifficultas'].toString()),
        forumCap = BigInt.parse(jsoschon['forumCap'].toString()),
        liberForumCap = BigInt.parse(jsoschon['liberForumCap'].toString()),
        fixumForumCap = BigInt.parse(jsoschon['fixumForumCap'].toString()),
        obstructionumNumerus =
            List<int>.from(jsoschon['obstructionumNumerus'] as List<dynamic>),
        defensio = jsoschon['defensio'].toString() == 'null'
            ? null
            : jsoschon['defensio'].toString(),
        producentis = jsoschon['producentis'].toString(),
        priorProbationem = jsoschon['priorProbationem'].toString(),
        gladiator =
            Gladiator.fromJson(jsoschon['gladiator'] as Map<String, dynamic>),
        liberTransactions = List<Transaction>.from(jsoschon['liberTransactions']
                .map((l) => Transaction.fromJson(l as Map<String, dynamic>))
            as Iterable<dynamic>),
        fixumTransactions = List<Transaction>.from(jsoschon['fixumTransactions']
                .map((f) => Transaction.fromJson(f as Map<String, dynamic>))
            as Iterable<dynamic>),
        expressiTransactions = List<Transaction>.from(
            jsoschon['expressiTransactions']
                    .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
                as Iterable<dynamic>),
        scans = List<Scan>.from(jsoschon['scans']
                .map((s) => Scan.fromJson(s as Map<String, dynamic>))
            as Iterable<dynamic>),
        humanify = (jsoschon['humanify'] != null &&
                jsoschon['humanify'] != 'null')
            ? Humanify.fromJson(jsoschon['humanify'] as Map<String, dynamic>)
            : null,
        cashExs = List<CashEx>.from(jsoschon['cashExs']
                .map((c) => CashEx.fromJson(c as Map<String, dynamic>))
            as Iterable<dynamic>);
}

class Obstructionum {
  final InterioreObstructionum interioreObstructionum;
  late String probationem;
  Obstructionum(this.interioreObstructionum, this.probationem);
  Obstructionum.incipio(this.interioreObstructionum) {
    do {
      interioreObstructionum.mine();
      probationem = HEX.encode(sha512
          .convert(utf8.encode(json.encode(interioreObstructionum.toJson())))
          .bytes);
    } while (!probationem.startsWith('0'));
  }
  static Future efectus(List<dynamic> args) async {
    InterioreObstructionum interioreObstructionum =
        args[0] as InterioreObstructionum;
    SendPort mitte = args[1] as SendPort;
    String probationem = '';
    do {
      interioreObstructionum.mine();
      probationem = HEX.encode(sha512
          .convert(utf8.encode(json.encode(interioreObstructionum.toJson())))
          .bytes);
    } while (!probationem
        .startsWith('0' * interioreObstructionum.obstructionumDifficultas));
    mitte.send(Obstructionum(interioreObstructionum, probationem));
  }

  static Future confussus(List<dynamic> args) async {
    InterioreObstructionum interioreObstructionum =
        args[0] as InterioreObstructionum;
    List<String> toCrack = args[1] as List<String>;
    SendPort mitte = args[2] as SendPort;
    String probationem = '';
    bool doschoes = false;
    while (true) {
      do {
        interioreObstructionum.mine();
        probationem = HEX.encode(sha512
            .convert(utf8.encode(json.encode(interioreObstructionum.toJson())))
            .bytes);
      } while (!probationem
          .startsWith('0' * interioreObstructionum.obstructionumDifficultas));
      for (int i = 0; i < toCrack.length; i++) {
        if (probationem.contains(toCrack[i])) {
          doschoes = true;
        } else {
          doschoes = false;
          break;
        }
      }
      if (doschoes) {
        break;
      } else {
        continue;
      }
    }
    mitte.send(Obstructionum(interioreObstructionum, probationem));
  }

  static Future expressi(List<dynamic> args) async {
    InterioreObstructionum interioreObstructionum =
        args[0] as InterioreObstructionum;
    List<String> toCrack = args[1] as List<String>;
    SendPort mitte = args[2] as SendPort;
    String probationem = '';
    bool doschoes = false;
    while (true) {
      do {
        interioreObstructionum.mine();
        probationem = HEX.encode(sha512
            .convert(utf8.encode(json.encode(interioreObstructionum.toJson())))
            .bytes);
      } while (!probationem.startsWith('0' *
              (interioreObstructionum.obstructionumDifficultas / 2).floor()) ||
          !probationem.endsWith('0' *
              (interioreObstructionum.obstructionumDifficultas / 2).floor()));
      for (int i = 0; i < toCrack.length; i++) {
        if (probationem.contains(toCrack[i])) {
          doschoes = true;
        } else {
          doschoes = false;
          break;
        }
      }
      if (doschoes) {
        break;
      } else {
        continue;
      }
    }
    mitte.send(Obstructionum(interioreObstructionum, probationem));
  }

  Map<String, dynamic> toJson() => {
        'interioreObstructionum': interioreObstructionum.toJson(),
        'probationem': probationem
      };
  Obstructionum.fromJson(Map<String, dynamic> jsoschon)
      : interioreObstructionum = InterioreObstructionum.fromJson(
            jsoschon['interioreObstructionum'] as Map<String, dynamic>),
        probationem = jsoschon['probationem'].toString();

  bool isProbationem() {
    if (probationem ==
        HEX.encode(sha512
            .convert(utf8.encode(json.encode(interioreObstructionum.toJson())))
            .bytes)) {
      return true;
    }
    return false;
  }

  Future salvareIncipio(Directory dir) async {
    File file = await File('${dir.path}${Constantes.fileNomen}0.txt')
        .create(recursive: true);
    interioreSalvare(file);
  }

  Future salvare(Directory dir) async {
    File file = File(dir.path +
        Constantes.fileNomen +
        (dir.listSync().length - 1).toString() +
        '.txt');
    if (await Utils.fileAmnis(file).length > Constantes.maximeCaudicesFile) {
      file = await File(dir.path +
              Constantes.fileNomen +
              (dir.listSync().length).toString() +
              '.txt')
          .create(recursive: true);
      interioreSalvare(file);
    } else {
      interioreSalvare(file);
    }
  }

  void interioreSalvare(File file) {
    var sink = file.openWrite(mode: FileMode.append);
    sink.write(json.encode(toJson()) + '\n');
    sink.close();
  }

  static Future<List<GladiatorOutput>> utDifficultas(
      Directory directory) async {
    List<Obstructionum> caudices = [];
    List<GladiatorInput?> gladiatorInitibus = [];
    List<Tuple3<String, GladiatorOutput, int>> gladiatorOutputs = [];
    for (int i = 0; i < directory.listSync().length; i++) {
      caudices.addAll(await Utils.fileAmnis(
              File(directory.path + '/caudices_' + i.toString() + '.txt'))
          .map((b) =>
              Obstructionum.fromJson(json.decode(b) as Map<String, dynamic>))
          .toList());
    }
    caudices.forEach((obstructionum) {
      gladiatorInitibus
          .add(obstructionum.interioreObstructionum.gladiator.input);
    });
    caudices.forEach((obstructionum) {
      for (int i = 0;
          i < obstructionum.interioreObstructionum.gladiator.outputs.length;
          i++) {
        gladiatorOutputs.add(Tuple3<String, GladiatorOutput, int>(
            obstructionum.interioreObstructionum.gladiator.id,
            obstructionum.interioreObstructionum.gladiator.outputs[i],
            i));
      }
    });
    gladiatorOutputs.removeWhere((element) => gladiatorInitibus.any((init) =>
        init?.gladiatorId == element.item1 && init?.index == element.item3));
    return gladiatorOutputs.map((g) => g.item2).toList();
  }

  static Future<List<Tuple3<String, GladiatorOutput, int>>> invictosGladiatores(
      Directory directory) async {
    List<Obstructionum> caudices = [];
    List<GladiatorInput?> gladiatorInitibus = [];
    List<Tuple3<String, GladiatorOutput, int>> gladiatorOutputs = [];
    for (int i = 0; i < directory.listSync().length; i++) {
      caudices.addAll(await Utils.fileAmnis(
              File(directory.path + '/caudices_' + i.toString() + '.txt'))
          .map((b) =>
              Obstructionum.fromJson(json.decode(b) as Map<String, dynamic>))
          .toList());
    }
    caudices.forEach((obstructionum) {
      gladiatorInitibus
          .add(obstructionum.interioreObstructionum.gladiator.input);
    });
    caudices.forEach((obstructionum) {
      for (int i = 0;
          i < obstructionum.interioreObstructionum.gladiator.outputs.length;
          i++) {
        gladiatorOutputs.add(Tuple3<String, GladiatorOutput, int>(
            obstructionum.interioreObstructionum.gladiator.id,
            obstructionum.interioreObstructionum.gladiator.outputs[i],
            i));
      }
    });
    gladiatorOutputs.removeWhere((element) => gladiatorInitibus.any((init) =>
        init?.gladiatorId == element.item1 && init?.index == element.item3));
    return gladiatorOutputs;
  }

  static Future<BigInt> utSummaDifficultas(Directory directory) async {
    BigInt total = BigInt.zero;
    for (int i = 0; i < directory.listSync().length; i++) {
      await Utils.fileAmnis(
              File(directory.path + '/caudices_' + i.toString() + '.txt'))
          .map((b) =>
              Obstructionum.fromJson(json.decode(b) as Map<String, dynamic>))
          .forEach((obstructionum) {
        total += BigInt.from(
            obstructionum.interioreObstructionum.obstructionumDifficultas);
      });
    }
    return total;
  }

  static Future<List<int>> utObstructionumNumerus(Directory directory) async {
    Obstructionum obstructionum = await Utils.priorObstructionum(directory);
    final int priorObstructionumNumerus = obstructionum
            .interioreObstructionum.obstructionumNumerus[
        obstructionum.interioreObstructionum.obstructionumNumerus.length - 1];
    if (priorObstructionumNumerus < Constantes.maximeCaudicesFile) {
      obstructionum.interioreObstructionum.obstructionumNumerus[
          obstructionum.interioreObstructionum.obstructionumNumerus.length -
              1]++;
    } else if (priorObstructionumNumerus == Constantes.maximeCaudicesFile) {
      obstructionum.interioreObstructionum.obstructionumNumerus.add(0);
    }
    return obstructionum.interioreObstructionum.obstructionumNumerus;
  }

  static Future<List<Obstructionum>> getBlocks(Directory directory) async {
    List<Obstructionum> obs = [];
    for (int i = 0; i < directory.listSync().length; i++) {
      await for (String line in Utils.fileAmnis(File(
          directory.path + Constantes.fileNomen + i.toString() + '.txt'))) {
        obs.add(
            Obstructionum.fromJson(json.decode(line) as Map<String, dynamic>));
      }
    }
    return obs;
  }

  static Future<bool> gladiatorSpiritus(
      int index, String gladiatorId, Directory dir) async {
    List<Obstructionum> obs = await getBlocks(dir);
    List<GladiatorInput?> gis =
        obs.map((o) => o.interioreObstructionum.gladiator.input).toList();
    if (gis.any((g) => g?.gladiatorId == gladiatorId && g?.index == index)) {
      return false;
    }
    return true;
  }

  static Future<bool> gladiatorConfodiantur(
      String gladiatorId, String publicaClavis, Directory dir) async {
    List<Obstructionum> obs = await getBlocks(dir);
    Obstructionum obsGladiator = obs.singleWhere((element) =>
        element.interioreObstructionum.gladiator.id == gladiatorId);
    Gladiator gladiator = obsGladiator.interioreObstructionum.gladiator;
    return gladiator.outputs.any((o) => o.rationem
        .any((r) => r.interioreRationem.publicaClavis == publicaClavis));
  }

  static Future<Gladiator> grabGladiator(
      String gladiatorId, Directory dir) async {
    List<Obstructionum> obs = await getBlocks(dir);
    return obs
        .singleWhere(
            (ob) => ob.interioreObstructionum.gladiator.id == gladiatorId)
        .interioreObstructionum
        .gladiator;
  }

  static int acciperePropterDifficultas(Obstructionum priorObstructionum) {
    if (priorObstructionum.interioreObstructionum.generare ==
            Generare.INCIPIO ||
        priorObstructionum.interioreObstructionum.generare ==
            Generare.EFECTUS) {
      for (GladiatorOutput output
          in priorObstructionum.interioreObstructionum.gladiator.outputs) {
        if (output.rationem.length <= Constantes.perRationesObstructionum) {
          if (priorObstructionum.interioreObstructionum.propterDifficultas >
              0) {
            return (priorObstructionum
                    .interioreObstructionum.propterDifficultas +
                1);
          } else {
            return 0;
          }
        } else if (priorObstructionum
                .interioreObstructionum.propterDifficultas >
            0) {
          return (priorObstructionum.interioreObstructionum.propterDifficultas -
              1);
        }
      }
    }
    return priorObstructionum.interioreObstructionum.propterDifficultas;
  }

  static int accipereLiberDifficultas(Obstructionum priorObstructionum) {
    if (priorObstructionum.interioreObstructionum.liberTransactions.length <
        Constantes.txCaudice) {
      if (priorObstructionum.interioreObstructionum.liberDifficultas > 0) {
        return (priorObstructionum.interioreObstructionum.liberDifficultas - 1);
      } else {
        return 0;
      }
    }
    return (priorObstructionum.interioreObstructionum.liberDifficultas + 1);
  }

  static int accipereFixumDifficultas(Obstructionum priorObstructionum) {
    if (priorObstructionum.interioreObstructionum.fixumTransactions.length <
        Constantes.txCaudice) {
      if (priorObstructionum.interioreObstructionum.fixumDifficultas > 0) {
        return (priorObstructionum.interioreObstructionum.fixumDifficultas - 1);
      } else {
        return 0;
      }
    }
    return (priorObstructionum.interioreObstructionum.fixumDifficultas + 1);
  }

  static int accipereScanDifficultas(Obstructionum priorObstructionum) {
    if (priorObstructionum.interioreObstructionum.scans.length <
        Constantes.scanCaudice) {
      if (priorObstructionum.interioreObstructionum.scanDifficultas > 0) {
        return priorObstructionum.interioreObstructionum.scanDifficultas - 1;
      } else {
        return 0;
      }
    }
    return priorObstructionum.interioreObstructionum.scanDifficultas + 1;
  }

  static int accipereCashExDifficultas(Obstructionum priorObstructionum) {
    if (priorObstructionum.interioreObstructionum.cashExs.length <
        Constantes.scanCaudice) {
      if (priorObstructionum.interioreObstructionum.cashExDifficultas > 0) {
        return priorObstructionum.interioreObstructionum.cashExDifficultas - 1;
      } else {
        return 0;
      }
    }
    return priorObstructionum.interioreObstructionum.cashExDifficultas + 1;
  }

  static Future<BigInt> accipereForumCap(Directory directory) async {
    List<Obstructionum> obss = await getBlocks(directory);
    final obstructionumPraemium = obss
        .where((obs) =>
            obs.interioreObstructionum.generare == Generare.INCIPIO ||
            obs.interioreObstructionum.generare == Generare.EFECTUS)
        .length;
    List<List<CashEx>> llcashExs =
        obss.map((o) => o.interioreObstructionum.cashExs).toList();
    List<CashEx> lcashex = [];
    llcashExs.forEach(lcashex.addAll);
    BigInt exes = BigInt.zero;
    for (CashEx cx in lcashex) {
      exes += cx.interioreCashEx.signumCashEx.nof;
    }

    return (BigInt.parse(obstructionumPraemium.toString()) *
            Constantes.obstructionumPraemium) +
        exes;
  }

  static Future<BigInt> accipereForumCapLiberFixum(
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
    if (liber) {
      List<Obstructionum> obss = await getBlocks(directory);
      List<List<CashEx>> llcashExs =
          obss.map((o) => o.interioreObstructionum.cashExs).toList();
      List<CashEx> lcashex = [];
      llcashExs.forEach(lcashex.addAll);
      BigInt exes = BigInt.zero;
      for (CashEx cx in lcashex) {
        exes += cx.interioreCashEx.signumCashEx.nof;
      }
      return forumCap + exes;
    }
    return forumCap;
  }
}
