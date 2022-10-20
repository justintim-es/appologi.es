import 'dart:convert';
import 'dart:isolate';
import 'package:crypto/crypto.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:hex/hex.dart';
import 'package:appologi_es/models/transaction.dart';
import 'package:appologi_es/models/utils.dart';
import 'package:appologi_es/appologi_es.dart';

class Password {
  int index;
  String passphrase;
  Password(this.index, this.passphrase);
  Map<String, dynamic> toJson() => {'index': index, 'passphrase': passphrase};
  Password.fromJson(Map<String, dynamic> map)
      : index = int.parse(map['index'].toString()),
        passphrase = map['passphrase'].toString();
}

class InterioreHumanify {
  String? dominus;
  List<String> responderes;
  String? quaestio;
  String? img;
  BigInt nonce;
  String id;
  InterioreHumanify(this.dominus, String respondere, this.quaestio, this.img)
      : nonce = BigInt.zero,
        id = Utils.randomHex(32),
        responderes = [] {
    for (int i = 0; i < 51; i++) {
      final pw = Password(i, respondere);
      responderes.add(DBCrypt().hashpw(
          HEX.encode(
              sha512.convert(utf8.encode(json.encode(pw.toJson()))).bytes),
          DBCrypt().gensalt()));
    }
  }

  Map<String, dynamic> toJson() => {
        'dominus': dominus,
        'responderes': responderes,
        'img': img,
        'nonce': nonce.toString(),
        'quaestio': quaestio,
        'id': id
      };
  InterioreHumanify.fromJson(Map<String, dynamic> map)
      : dominus = map['dominus'].toString(),
        responderes = List<String>.from(map['responderes'] as List<dynamic>),
        quaestio = map['quaestio'].toString(),
        img = map['img'].toString(),
        nonce = BigInt.parse(map['nonce'].toString()),
        id = map['id'].toString();

  void mine() {
    nonce += BigInt.one;
  }
}

class Humanify {
  InterioreHumanify interiore;
  String probationem;
  Humanify(this.interiore, this.probationem);

  Map<String, dynamic> toJson() =>
      {'interiore': interiore.toJson(), 'probationem': probationem};
  Humanify.fromJson(Map<String, dynamic> map)
      : interiore = InterioreHumanify.fromJson(
            map['interiore'] as Map<String, dynamic>),
        probationem = map['probationem'].toString();

  static void quaestum(List<dynamic> argumentis) {
    InterioreHumanify interiore = argumentis[0] as InterioreHumanify;
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
      mitte.send(Humanify(interiore, probationem));
    }
  }

  static Humanify? grab(List<Humanify> humanifies) {
    Humanify? reditus;
    for (int i = 128; i >= 0; i--) {
      if (humanifies
          .any((element) => element.probationem.startsWith('0' * i))) {
        reditus = humanifies
            .firstWhere((element) => element.probationem.startsWith('0' * i));
        break;
      }
    }
    return reditus;
  }
}
