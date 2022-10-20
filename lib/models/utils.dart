import 'dart:math';
import 'dart:io';
import 'package:hex/hex.dart';
import 'dart:convert';
import 'package:appologi_es/models/gladiator.dart';
import 'package:elliptic/elliptic.dart';
import 'package:appologi_es/models/transaction.dart';
import 'package:ecdsa/ecdsa.dart';
import 'package:appologi_es/models/gladiator.dart';
import 'package:appologi_es/models/constantes.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:appologi_es/models/errors.dart';

class Utils {
  static final Random _random = Random.secure();

  static String randomHex(int length) {
    var values = List<int>.generate(length, (index) => _random.nextInt(256));
    return HEX.encode(values);
  }

  static Stream<String> fileAmnis(File file) =>
      file.openRead().transform(utf8.decoder).transform(LineSplitter());

  static Future<Obstructionum> accipereObstructionNumerus(
      List<int> numerus, Directory directory) async {
    File file =
        File('${directory.path}/${Constantes.fileNomen}${numerus.length - 1}');
    List<String> lines = await fileAmnis(file).toList();
    return Obstructionum.fromJson(
        json.decode(lines[numerus.last]) as Map<String, dynamic>);
  }

  static Future<String> priorObstructionumIndex(
      int index, Directory directory) async {
    List<Obstructionum> obss = await Utils.getObstructionums(directory);
    print(obss.map((x) => x.toJson()));
    return obss.reversed.elementAt(index).probationem;
  }

  static Future<Obstructionum> priorObstructionumProbationem(
      int index, Directory directory) async {
    List<Obstructionum> obss = await Utils.getObstructionums(directory);
    return obss.reversed.elementAt(index);
  }

  static Future<Obstructionum> priorObstructionum(Directory directory) async =>
      Obstructionum.fromJson(json.decode(await Utils.fileAmnis(File(
              directory.path +
                  '/caudices_' +
                  (directory.listSync().isNotEmpty
                          ? directory.listSync().length - 1
                          : 0)
                      .toString() +
                  '.txt'))
          .last) as Map<String, dynamic>);
  static Future<Obstructionum> priorObstructionumEfectus(
      Directory directory) async {
    List<Obstructionum> obss = await Obstructionum.getBlocks(directory);
    return obss[obss.lastIndexWhere(
        (o) => o.interioreObstructionum.generare == Generare.EFECTUS)];
  }

  static String signum(PrivateKey privateKey, dynamic output) =>
      signature(privateKey, utf8.encode(json.encode(output.toJson())))
          .toASN1Hex();

  static bool cognoscereVictusGladiator(PublicKey publicaClavis,
          Signature signature, GladiatorOutput gladiatorOutput) =>
      verify(publicaClavis, utf8.encode(json.encode(gladiatorOutput.toJson())),
          signature);
  static bool cognoscere(PublicKey publicaClavis, Signature signature,
          TransactionOutput txOutput) =>
      verify(publicaClavis, utf8.encode(json.encode(txOutput.toJson())),
          signature);

  static Future removeDonecObstructionum(
      Directory directory, List<int> numerus) async {
    final priorObs = await Utils.priorObstructionum(directory);
    final priorNumerus = priorObs.interioreObstructionum.obstructionumNumerus;
    if (numerus.length - 1 > directory.listSync().length - 1) {
      for (int i = (numerus.length - 1);
          i < directory.listSync().length - 1;
          i++) {
        File('${directory.path}/${Constantes.fileNomen}$i').delete();
      }
    }
    File file = File(
        '${directory.path}/${Constantes.fileNomen}${numerus.length - 1}.txt');
    final lines = await Utils.fileAmnis(file).toList();
    lines.removeRange(numerus.last, lines.length);
    print('lines');
    file.writeAsStringSync('');
    var sink = file.openWrite(mode: FileMode.append);
    for (String line in lines) {
      print(line + '\n');
      sink.write(line + '\n');
    }
    sink.close();
  }

  static Future<List<Obstructionum>> getObstructionums(
      Directory directory) async {
    List<Obstructionum> obs = [];
    for (int i = 0; i < directory.listSync().length; i++) {
      await for (String obstructionum in Utils.fileAmnis(
          File('${directory.path}/${Constantes.fileNomen}$i.txt'))) {
        obs.add(Obstructionum.fromJson(
            json.decode(obstructionum) as Map<String, dynamic>));
      }
    }
    return obs;
  }

  static Future removeObstructionumsUntilProbationem(
      Directory directory) async {
    // Obstructionum? obs = await Utils.accipereObstructionumProbationem(probationem, directory);
    // if(obs == null) return;
    // if((obs.interioreObstructionum.obstructionumNumerus.length -1) > directory.listSync().length-1) {
    //   for(int i = (obs.interioreObstructionum.obstructionumNumerus.length -1); i < directory.listSync().length-1; i++) {
    //     File('${directory.path}/${Constantes.fileNomen}$i.txt').delete();
    //     print('deletedfile');
    //   }
    // }
    //because right
    Obstructionum obs = await Utils.priorObstructionum(directory);
    print('fails here');
    File file = File(
        '${directory.path}/${Constantes.fileNomen}${obs.interioreObstructionum.obstructionumNumerus.length - 1}.txt');
    final lines = await Utils.fileAmnis(file).toList();
    if (lines.isNotEmpty &&
        obs.interioreObstructionum.generare != Generare.INCIPIO) {
      lines.removeRange(
          obs.interioreObstructionum.obstructionumNumerus.last, lines.length);
    }
    print('lines');
    if (lines.isNotEmpty) {
      file.writeAsStringSync('');
      var sink = file.openWrite(mode: FileMode.append);
      for (String line in lines) {
        print(line + '\n');
        sink.write(line + '\n');
      }
      sink.close();
    } else {
      file.deleteSync();
    }
  }

  static Future<Obstructionum?> accipereObstructionumPriorProbationem(
      String probationem, Directory directory) async {
    // List<Obstructionum> obss = [];
    // for (int i = 0; i < directory.listSync().length; i++) {
    //   await for (String obstructionum in Utils.fileAmnis(File('${directory.path}${Constantes.fileNomen}$i.txt'))) {
    //     Obstructionum obs = Obstructionum.fromJson(json.decode(obstructionum));
    //     if (obs.interioreObstructionum.priorProbationem == probationem) {
    //       return obs;
    //     }
    //   }
    // }
    // return null;
    Obstructionum obstructionum = await Utils.priorObstructionum(directory);
  }

  static Future<Obstructionum> accipereObstructionumProbationem(
      String probationem, Directory directory) async {
    List<Obstructionum> obss = [];
    for (int i = 0; i < directory.listSync().length; i++) {
      await for (String obstructionum in Utils.fileAmnis(
          File('${directory.path}${Constantes.fileNomen}$i.txt'))) {
        Obstructionum obs = Obstructionum.fromJson(
            json.decode(obstructionum) as Map<String, dynamic>);
        if (obs.probationem == probationem) {
          return obs;
        }
      }
    }
    throw Error(
        code: 0,
        message: 'angustos non pro probationem',
        english: 'block not found for proof');
  }

  static Future removeObstructionumsInter(
      String priorProbationem, Directory directory) async {
    for (int i = 0; i < directory.listSync().length; i++) {
      File file = File('${directory.path}/${Constantes.fileNomen}$i.txt');
      await for (String line in fileAmnis(file)) {
        Obstructionum obs =
            Obstructionum.fromJson(json.decode(line) as Map<String, dynamic>);
        if (obs.probationem == priorProbationem) {}
      }
    }
  }

  static Future<int> obstructionemsLongitudo(Directory directory) async {
    List<Obstructionum> obss = await Utils.getObstructionums(directory);
    return obss.length;
  }

  static Future removeSummumObstructionum(Directory directory) async {
    List<Obstructionum> obss = await Utils.getObstructionums(directory);
  }

  static BigInt confirmationes(List<int> from, List<int> to) {
    if (from.length == to.length) {}
    BigInt counter = BigInt.zero;
    while (to.length != from.length) {
      counter += BigInt.parse(
          ((Constantes.maximeCaudicesFile + 1) - from.last).toString());
      from.add(0);
    }
    counter += BigInt.parse((to.last - from.last).toString());
    return counter;
  }
}
