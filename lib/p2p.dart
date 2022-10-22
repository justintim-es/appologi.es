import 'dart:io';
import 'dart:convert';
import 'dart:isolate';
import 'package:appologi_es/models/cash_ex.dart';
import 'package:appologi_es/models/gladiator.dart';
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
import 'package:appologi_es/models/humanify.dart';
import 'package:appologi_es/models/pera.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:appologi_es/models/constantes.dart';
import 'package:appologi_es/models/scan.dart';
import 'package:appologi_es/models/utils.dart';
import 'package:appologi_es/models/transaction.dart';
import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';

class P2PMessage {
  String type;
  List<String> recieved;
  P2PMessage(this.type, this.recieved);
  P2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : type = jsoschon['type'].toString(),
        recieved = List<String>.from(jsoschon['recieved'] as Iterable<dynamic>);
  Map<String, dynamic> toJson() => {
        'type': type,
        'recieved': recieved,
      };
}

class SingleSocketP2PMessage extends P2PMessage {
  String socket;
  SingleSocketP2PMessage(this.socket, String type, List<String> recieved)
      : super(type, recieved);
  SingleSocketP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : socket = jsoschon['socket'].toString(),
        super.fromJson(jsoschon);
  @override
  Map<String, dynamic> toJson() =>
      {'socket': socket, 'type': type, 'recieved': recieved};
}

class ConnectBootnodeP2PMessage extends P2PMessage {
  String socket;
  ConnectBootnodeP2PMessage(this.socket, String type, List<String> recieved)
      : super(type, recieved);
  ConnectBootnodeP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : socket = jsoschon['socket'].toString(),
        super.fromJson(jsoschon);
  @override
  Map<String, dynamic> toJson() =>
      {'socket': socket, 'type': type, 'recieved': recieved};
}

class OnConnectP2PMessage extends P2PMessage {
  List<String> sockets;
  List<Propter> propters;
  List<Transaction> liberTxs;
  List<Transaction> fixumTxs;
  OnConnectP2PMessage(this.sockets, this.propters, this.liberTxs, this.fixumTxs,
      String type, List<String> recieved)
      : super(type, recieved);
  OnConnectP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : sockets = List<String>.from(jsoschon['sockets'] as List<dynamic>),
        propters = List<Propter>.from(jsoschon['propters']
                .map((x) => Propter.fromJson(x as Map<String, dynamic>))
            as Iterable<dynamic>),
        liberTxs = List<Transaction>.from(jsoschon['liberTxs']
                .map((x) => Transaction.fromJson(x as Map<String, dynamic>))
            as Iterable<dynamic>),
        fixumTxs = List<Transaction>.from(jsoschon['fixumTxs']
                .map((x) => Transaction.fromJson(x as Map<String, dynamic>))
            as Iterable<dynamic>),
        super.fromJson(jsoschon);
  @override
  Map<String, dynamic> toJson() => {
        'sockets': sockets,
        'propters': propters.map((p) => p.toJson()).toList(),
        'liberTxs': liberTxs.map((liber) => liber.toJson()).toList(),
        'fixumTxs': fixumTxs.map((liber) => liber.toJson()).toList(),
        'type': type,
        'recieved': recieved
      };
}

class SocketsP2PMessage extends P2PMessage {
  List<String> sockets;
  SocketsP2PMessage(this.sockets, String type, List<String> recieved)
      : super(type, recieved);
  SocketsP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : sockets = List<String>.from(jsoschon['sockets'] as List<dynamic>),
        super.fromJson(jsoschon);
  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'sockets': sockets, 'recieved': recieved};
}

class ScanP2PMessage extends P2PMessage {
  Scan scan;
  ScanP2PMessage(this.scan, String type, List<String> recieved)
      : super(type, recieved);
  ScanP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : scan = Scan.fromJson(jsoschon['scan'] as Map<String, dynamic>),
        super.fromJson(jsoschon);

  @override
  Map<String, dynamic> toJson() =>
      {'scan': scan.toJson(), 'type': type, 'recieved': recieved};
}

class RemoveScansP2PMessage extends P2PMessage {
  List<String> ids;
  RemoveScansP2PMessage(this.ids, String type, List<String> recieved)
      : super(type, recieved);
  RemoveScansP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : ids = List<String>.from(jsoschon['ids'] as List<dynamic>),
        super.fromJson(jsoschon);
  Map<String, dynamic> toJson() =>
      {'ids': ids, 'type': type, 'recieved': recieved};
}

class HumanifyP2PMessage extends P2PMessage {
  Humanify humanify;
  HumanifyP2PMessage(this.humanify, String type, List<String> recieved)
      : super(type, recieved);
  HumanifyP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : humanify =
            Humanify.fromJson(jsoschon['humanify'] as Map<String, dynamic>),
        super.fromJson(jsoschon);

  @override
  Map<String, dynamic> toJson() => {
        'humanify': humanify.toJson(),
        'type': type,
        'recieved': recieved,
      };
}

class RemoveHumanifyP2PMessage extends P2PMessage {
  String id;
  RemoveHumanifyP2PMessage(this.id, String type, List<String> recieved)
      : super(type, recieved);
  RemoveHumanifyP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : id = jsoschon['id'].toString(),
        super.fromJson(jsoschon);
  @override
  Map<String, dynamic> toJson() =>
      {'id': 'id', 'type': type, 'recieved': recieved};
}

class CashExP2PMessage extends P2PMessage {
  CashEx cashEx;
  CashExP2PMessage(this.cashEx, String type, List<String> recieved)
      : super(type, recieved);
  CashExP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : cashEx = CashEx.fromJson(jsoschon['cashEx'] as Map<String, dynamic>),
        super.fromJson(jsoschon);
  @override
  Map<String, dynamic> toJson() => {
        'cashEx': cashEx.toJson(),
        'type': type,
        'recieved': recieved,
      };
}

class RemoveCashExP2PMessage extends P2PMessage {
  List<String> ids;
  RemoveCashExP2PMessage(this.ids, String type, List<String> recieved)
      : super(type, recieved);
  RemoveCashExP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : ids = List<String>.from(jsoschon['id'] as List<dynamic>),
        super.fromJson(jsoschon);
  @override
  Map<String, dynamic> toJson() => {
        'ids': ids,
        'type': type,
        'recieved': recieved,
      };
}

class PropterP2PMessage extends P2PMessage {
  Propter propter;
  PropterP2PMessage(this.propter, String type, List<String> recieved)
      : super(type, recieved);
  PropterP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : propter = Propter.fromJson(jsoschon['propter'] as Map<String, dynamic>),
        super.fromJson(jsoschon);
  @override
  Map<String, dynamic> toJson() => {
        'propter': propter.toJson(),
        'type': type,
        'recieved': recieved,
      };
}

class RemoveProptersP2PMessage extends P2PMessage {
  List<String> ids;
  RemoveProptersP2PMessage(this.ids, String type, List<String> recieved)
      : super(type, recieved);
  RemoveProptersP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : ids = List<String>.from(jsoschon['ids'] as List<dynamic>),
        super.fromJson(jsoschon);
  @override
  Map<String, dynamic> toJson() => {
        'ids': ids,
        'type': type,
      };
}

class TransactionP2PMessage extends P2PMessage {
  Transaction tx;
  TransactionP2PMessage(this.tx, String type, List<String> recieved)
      : super(type, recieved);
  TransactionP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : tx = Transaction.fromJson(jsoschon['tx'] as Map<String, dynamic>),
        super.fromJson(jsoschon);
  @override
  Map<String, dynamic> toJson() =>
      {'tx': tx.toJson(), 'type': type, 'recieved': recieved};
}

class RemoveTransactionsP2PMessage extends P2PMessage {
  List<String> ids;
  RemoveTransactionsP2PMessage(this.ids, String type, List<String> recieved)
      : super(type, recieved);
  RemoveTransactionsP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : ids = List<String>.from(jsoschon['ids'] as List<dynamic>),
        super.fromJson(jsoschon);
  @override
  Map<String, dynamic> toJson() => {
        'ids': ids,
        'recieved': recieved,
      };
}

class ObstructionumP2PMessage extends P2PMessage {
  String secret;
  Obstructionum obstructionum;
  ObstructionumP2PMessage(
      this.secret, this.obstructionum, String type, List<String> recieved)
      : super(type, recieved);
  ObstructionumP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : obstructionum = Obstructionum.fromJson(
            jsoschon['obstructionum'] as Map<String, dynamic>),
        secret = jsoschon['secret'] as String,
        super.fromJson(jsoschon);
  @override
  Map<String, dynamic> toJson() => {
        'obstructionum': obstructionum.toJson(),
        'secret': secret,
        'type': type,
        'recieved': recieved
      };
}

class RequestObstructionumP2PMessage extends P2PMessage {
  List<int> numerus;
  RequestObstructionumP2PMessage(
      this.numerus, String type, List<String> recieved)
      : super(type, recieved);
  RequestObstructionumP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : numerus = List<int>.from(jsoschon['numerus'] as List<dynamic>),
        super.fromJson(jsoschon);
  @override
  Map<String, dynamic> toJson() =>
      {'numerus': numerus, 'type': type, 'recieved': recieved};
}

class ProbationemP2PMessage extends P2PMessage {
  String probationem;
  String secret;
  ProbationemP2PMessage(
      this.probationem, this.secret, String type, List<String> recieved)
      : super(type, recieved);
  ProbationemP2PMessage.fromJson(Map<String, dynamic> jsoschon)
      : probationem = jsoschon['probationem'].toString(),
        secret = jsoschon['secret'].toString(),
        super.fromJson(jsoschon);
  @override
  Map<String, dynamic> toJson() => {
        'probationem': probationem,
        'secret': secret,
        'type': type,
        'recieved': recieved
      };
}

class P2P {
  int maxPeers;
  String secret;
  String from;
  List<String> sockets = [];
  List<Propter> propters = [];
  List<Transaction> liberTxs = [];
  List<Transaction> fixumTxs = [];
  List<Transaction> expressieTxs = [];
  List<Isolate> syncBlocks = [];
  Directory dir;
  ReceivePort efectusRp = ReceivePort();
  ReceivePort confussusRp = ReceivePort();
  ReceivePort expressiRp = ReceivePort();
  bool isEfectusActive = false;
  bool isConfussusActive = false;
  bool isExpressiActive = false;

  List<Scan> scans = [];
  List<Humanify> humanifies = [];
  List<CashEx> cashExs = [];

  List<int> summaNumerus;
  P2P(this.maxPeers, this.secret, this.from, this.dir, this.summaNumerus);

  listen(String internalIp, int port) async {
    ServerSocket serverSocket = await ServerSocket.bind(internalIp, port);
    print(serverSocket.address);
    print(serverSocket.port);
    serverSocket.listen((client) {
      utf8.decoder.bind(client).listen((data) async {
        print(client.address.address);
        print(client.port);
        P2PMessage msg =
            P2PMessage.fromJson(json.decode(data) as Map<String, dynamic>);
        print(msg.toJson());

        if (msg.type == 'connect-bootnode') {
          ConnectBootnodeP2PMessage cbp2pm = ConnectBootnodeP2PMessage.fromJson(
              json.decode(data) as Map<String, dynamic>);
          client.write(json.encode(OnConnectP2PMessage(
              sockets,
              propters,
              liberTxs,
              fixumTxs,
              'on-connect',
              List<String>.from(
                  ['${client.address.address}:${client.port}'])).toJson()));
          // client.destroy();
          for (String socket in sockets) {
            Socket s = await Socket.connect(
                socket.split(':')[0], int.parse(socket.split(':')[1]));
            s.write(json.encode(SingleSocketP2PMessage(
                cbp2pm.socket,
                'single-socket',
                List<String>.from(
                    ['${client.address.address}:${client.port}']))));
          }
          if (sockets.length < maxPeers &&
              !sockets.contains(cbp2pm.socket) &&
              cbp2pm.socket != '$internalIp:$port') {
            sockets.add(cbp2pm.socket);
          }
        } else if (msg.type == 'single-socket') {
          SingleSocketP2PMessage ssp2pm = SingleSocketP2PMessage.fromJson(
              json.decode(data) as Map<String, dynamic>);
          if (sockets.length < maxPeers &&
              ssp2pm.socket != '$internalIp:$port') {
            sockets.add(ssp2pm.socket);
          }
          client.destroy();
        } else if (msg.type == 'humanify') {
          HumanifyP2PMessage hp2pm = HumanifyP2PMessage.fromJson(
              json.decode(data) as Map<String, dynamic>);
          if (hp2pm.humanify.probationem ==
              HEX.encode(sha512
                  .convert(utf8
                      .encode(json.encode(hp2pm.humanify.interiore.toJson())))
                  .bytes)) {
            if (humanifies
                .any((h) => h.interiore.id == hp2pm.humanify.interiore.id)) {
              humanifies.removeWhere((element) =>
                  element.interiore.id == hp2pm.humanify.interiore.id);
            }
            humanifies.add(hp2pm.humanify);
          }
          hp2pm.recieved.add('${client.address.address}:${client.port}');
          for (String socket
              in sockets.where((s) => !hp2pm.recieved.contains(s))) {
            Socket soschock = await Socket.connect(
                socket.split(':')[0], int.parse(socket.split(':')[1]));
            soschock.write(json.encode(hp2pm.toJson()));
          }
          client.destroy();
        } else if (msg.type == 'remove-humanify') {
          RemoveHumanifyP2PMessage rhp2pm = RemoveHumanifyP2PMessage.fromJson(
              json.decode(data) as Map<String, dynamic>);
          humanifies.removeWhere((h) => h.interiore.id == rhp2pm.id);
          rhp2pm.recieved.add('${client.address.address}:${client.port}');
          for (String socket
              in sockets.where((s) => !rhp2pm.recieved.contains(s))) {
            Socket soschock = await Socket.connect(
                socket.split(':')[0], int.parse(socket.split(':')[1]));
            soschock.write(json.encode(rhp2pm.toJson()));
          }
          client.destroy();
        } else if (msg.type == 'scan') {
          ScanP2PMessage sp2pm = ScanP2PMessage.fromJson(
              json.decode(data) as Map<String, dynamic>);
          List<Obstructionum> obss = await Utils.getObstructionums(dir);
          for (List<Scan> scans
              in obss.map((e) => e.interioreObstructionum.scans)) {
            if (!scans.any((element) =>
                element.interioreScan.humanifyAnswer?.passphraseIndex ==
                    sp2pm.scan.interioreScan.humanifyAnswer?.passphraseIndex &&
                element.interioreScan.humanifyAnswer?.probationem ==
                    sp2pm.scan.interioreScan.humanifyAnswer?.probationem)) {
              scans.add(sp2pm.scan);
            }
            sp2pm.recieved.add('${client.address.address}:${client.port}');
            for (String socket
                in sockets.where((s) => !sp2pm.recieved.contains(s))) {
              Socket soschock = await Socket.connect(
                  socket.split(':')[0], int.parse(socket.split(':')[1]));
              soschock.write(json.encode(sp2pm.toJson()));
            }
          }
          client.destroy();
        } else if (msg.type == 'remove-scans') {
          RemoveScansP2PMessage rsp2pm = RemoveScansP2PMessage.fromJson(
              json.decode(data) as Map<String, dynamic>);
          scans.removeWhere(
              (s) => rsp2pm.ids.any((id) => id == s.interioreScan.id));
          rsp2pm.recieved.add('${client.address.address}:${client.port}');
          for (String socket
              in sockets.where((s) => !rsp2pm.recieved.contains(s))) {
            Socket soschock = await Socket.connect(
                socket.split(':')[0], int.parse(socket.split(':')[1]));
            soschock.write(json.encode(rsp2pm.toJson()));
          }
          client.destroy();
        } else if (msg.type == 'propter') {
          PropterP2PMessage pp2pm = PropterP2PMessage.fromJson(
              json.decode(data) as Map<String, dynamic>);
          if (pp2pm.propter.probationem ==
              HEX.encode(sha512
                  .convert(utf8.encode(
                      json.encode(pp2pm.propter.interioreRationem.toJson())))
                  .bytes)) {
            if (propters.any((p) =>
                p.interioreRationem.id == pp2pm.propter.interioreRationem.id)) {
              propters.removeWhere((p) =>
                  p.interioreRationem.id == pp2pm.propter.interioreRationem.id);
            }
            propters.add(pp2pm.propter);
          }
          pp2pm.recieved.add('${client.address.address}:${client.port}');
          for (String socket
              in sockets.where((s) => !pp2pm.recieved.contains(s))) {
            Socket soschock = await Socket.connect(
                socket.split(':')[0], int.parse(socket.split(':')[1]));
            soschock.write(json.encode(pp2pm.toJson()));
          }
          client.destroy();
        } else if (msg.type == 'remove-propters') {
          RemoveProptersP2PMessage rpp2pm = RemoveProptersP2PMessage.fromJson(
              json.decode(data) as Map<String, dynamic>);
          propters.removeWhere(
              (p) => rpp2pm.ids.any((id) => id == p.interioreRationem.id));
          rpp2pm.recieved.add('${client.address.address}:${client.port}');
          for (String socket
              in sockets.where((s) => !rpp2pm.recieved.contains(s))) {
            Socket soschock = await Socket.connect(
                socket.split(':')[0], int.parse(socket.split(':')[1]));
            soschock.write(json.encode(rpp2pm.toJson()));
          }
          client.destroy();
        } else if (msg.type == 'cash-ex') {
          CashExP2PMessage cep2pm = CashExP2PMessage.fromJson(
              json.decode(data) as Map<String, dynamic>);
          if (cep2pm.cashEx.probationem ==
              HEX.encode(sha512
                  .convert(utf8.encode(
                      json.encode(cep2pm.cashEx.interioreCashEx.toJson())))
                  .bytes)) {
            if (cashExs.any((c) =>
                c.interioreCashEx.signumCashEx.id ==
                cep2pm.cashEx.interioreCashEx.signumCashEx.id)) {
              cashExs.removeWhere((c) =>
                  c.interioreCashEx.signumCashEx.id ==
                  cep2pm.cashEx.interioreCashEx.signumCashEx.id);
            }
          }
          cep2pm.recieved.add('${client.address.address}:${client.port}');
          for (String socket
              in sockets.where((s) => !cep2pm.recieved.contains(s))) {
            Socket soschock = await Socket.connect(
                socket.split(':')[0], int.parse(socket.split(':')[1]));
            soschock.write(json.encode(cep2pm.toJson()));
          }
          client.destroy();
        } else if (msg.type == 'remove-cash-exs') {
          RemoveCashExP2PMessage rcep2pm = RemoveCashExP2PMessage.fromJson(
              json.decode(data) as Map<String, dynamic>);
          cashExs.removeWhere((c) =>
              rcep2pm.ids.any((a) => a == c.interioreCashEx.signumCashEx.id));
          rcep2pm.recieved.add('${client.address.address}:${client.port}');
          for (String socket
              in sockets.where((s) => !rcep2pm.recieved.contains(s))) {
            Socket soschock = await Socket.connect(
                socket.split(':')[0], int.parse(socket.split(':')[1]));
            soschock.write(json.encode(rcep2pm.toJson()));
          }
          client.destroy();
        } else if (msg.type == 'expressi-tx') {
          TransactionP2PMessage tp2pm = TransactionP2PMessage.fromJson(
              json.decode(data) as Map<String, dynamic>);
          //maby some validation
          //todo`
          expressieTxs.add(tp2pm.tx);
          tp2pm.recieved.add('${client.address.address}:${client.port}');
          for (String socket
              in sockets.where((s) => !tp2pm.recieved.contains(s))) {
            Socket soschock = await Socket.connect(
                socket.split(':')[0], int.parse(socket.split(':')[1]));
            soschock.write(json.encode(tp2pm.toJson()));
          }
        } else if (msg.type == 'liber-tx') {
          TransactionP2PMessage tp2pm = TransactionP2PMessage.fromJson(
              json.decode(data) as Map<String, dynamic>);
          List<Obstructionum> obs = await Obstructionum.getBlocks(dir);
          if (await tp2pm.tx.validateLiber(dir)) {
            if (liberTxs.any((tx) =>
                tx.interioreTransaction.id ==
                tp2pm.tx.interioreTransaction.id)) {
              liberTxs.removeWhere((tx) =>
                  tx.interioreTransaction.id ==
                  tp2pm.tx.interioreTransaction.id);
            }
            liberTxs.add(tp2pm.tx);
          } else {
            client.write(json.encode(RemoveTransactionsP2PMessage(
                List<String>.from([tp2pm.tx.interioreTransaction.id]),
                'remove-liber-txs',
                List<String>.from(
                    ['${client.address.address}:${client.port}'])).toJson()));
          }
          tp2pm.recieved.add('${client.address.address}:${client.port}');
          for (String socket
              in sockets.where((s) => !tp2pm.recieved.contains(s))) {
            Socket soschock = await Socket.connect(
                socket.split(':')[0], int.parse(socket.split(':')[1]));
            soschock.write(json.encode(tp2pm.toJson()));
          }
        } else if (msg.type == 'fixum-tx') {
          TransactionP2PMessage tp2pm = TransactionP2PMessage.fromJson(
              json.decode(data) as Map<String, dynamic>);
          List<Obstructionum> obs = await Obstructionum.getBlocks(dir);
          if (await tp2pm.tx.validateFixum(dir)) {
            if (fixumTxs.any((tx) =>
                tx.interioreTransaction.id ==
                tp2pm.tx.interioreTransaction.id)) {
              fixumTxs.removeWhere((tx) =>
                  tx.interioreTransaction.id ==
                  tp2pm.tx.interioreTransaction.id);
            }
            fixumTxs.add(tp2pm.tx);
          } else {
            client.write(json.encode(RemoveTransactionsP2PMessage(
                List<String>.from([tp2pm.tx.interioreTransaction.id]),
                'remove-fixum-txs',
                List<String>.from(
                    ['${client.address.address}:${client.port}'])).toJson()));
          }
          tp2pm.recieved.add('${client.address.address}:${client.port}');
          for (String socket
              in sockets.where((s) => !tp2pm.recieved.contains(s))) {
            Socket soschock = await Socket.connect(
                socket.split(':')[0], int.parse(socket.split(':')[1]));
            soschock.write(json.encode(tp2pm.toJson()));
          }
        } else if (msg.type == 'remove-liber-txs') {
          RemoveTransactionsP2PMessage rtp2pm =
              RemoveTransactionsP2PMessage.fromJson(
                  json.decode(data) as Map<String, dynamic>);
          liberTxs.removeWhere(
              (l) => rtp2pm.ids.any((id) => id == l.interioreTransaction.id));
          for (String socket
              in sockets.where((s) => !rtp2pm.recieved.contains(s))) {
            Socket soschock = await Socket.connect(
                socket.split(':')[0], int.parse(socket.split(':')[1]));
            soschock.write(json.encode(rtp2pm.toJson()));
          }
          client.destroy();
        } else if (msg.type == 'remove-fixum-txs') {
          RemoveTransactionsP2PMessage rtp2pm =
              RemoveTransactionsP2PMessage.fromJson(
                  json.decode(data) as Map<String, dynamic>);
          fixumTxs.removeWhere(
              (l) => rtp2pm.ids.any((id) => id == l.interioreTransaction.id));
          for (String socket
              in sockets.where((s) => !rtp2pm.recieved.contains(s))) {
            Socket soschock = await Socket.connect(
                socket.split(':')[0], int.parse(socket.split(':')[1]));
            soschock.write(json.encode(rtp2pm.toJson()));
          }
          client.destroy();
        } else if (msg.type == 'obstructionum') {
          ObstructionumP2PMessage op2pm = ObstructionumP2PMessage.fromJson(
              json.decode(data) as Map<String, dynamic>);
          print(
              'recieved obstructionum ${op2pm.obstructionum.interioreObstructionum.obstructionumNumerus}');
          if (dir.listSync().isEmpty &&
              op2pm.obstructionum.interioreObstructionum.generare ==
                  Generare.INCIPIO) {
            await op2pm.obstructionum.salvareIncipio(dir);
            client.write(json.encode(RequestObstructionumP2PMessage(
                [1],
                'request-obstructionum',
                List<String>.from(
                    ['${client.address.address}:${client.port}'])).toJson()));
            print('requested incipio block');
          } else if (dir.listSync().isEmpty &&
              op2pm.obstructionum.interioreObstructionum.generare !=
                  Generare.INCIPIO) {
            client.write(json.encode(RequestObstructionumP2PMessage(
                [0],
                'request-obstructionum',
                List<String>.from(
                    ['${client.address.address}:${client.port}'])).toJson()));
            print('requested block one');
          } else {
            Obstructionum obs = await Utils.priorObstructionum(dir);
            summaNumerus = obs.interioreObstructionum.obstructionumNumerus;
            if (!op2pm.obstructionum.isProbationem()) {
              print('invalid probationem');
              return;
            }
            // because here the difficulty isnt reater
            if (op2pm.obstructionum.interioreObstructionum
                        .summaObstructionumDifficultas >=
                    obs.interioreObstructionum.summaObstructionumDifficultas ||
                op2pm.secret == secret) {
              List<Obstructionum> obss = await Obstructionum.getBlocks(dir);
              print(obs.probationem);
              print(
                  op2pm.obstructionum.interioreObstructionum.priorProbationem);
              if (obs.probationem ==
                  op2pm.obstructionum.interioreObstructionum.priorProbationem) {
                secret = Utils.randomHex(32);
                if (op2pm.obstructionum.interioreObstructionum.forumCap !=
                    await Obstructionum.accipereForumCap(dir)) {
                  print("Corrumpere forum cap");
                  return;
                }
                if (op2pm.obstructionum.interioreObstructionum
                        .summaObstructionumDifficultas !=
                    await Obstructionum.utSummaDifficultas(dir)) {
                  print("corrumpere summaObstructionumDifficultas");
                  return;
                }
                BigInt nuschum = BigInt.zero;
                for (int n in await Obstructionum.utObstructionumNumerus(dir)) {
                  nuschum += BigInt.parse(n.toString());
                }
                if ((nuschum / (await Obstructionum.utSummaDifficultas(dir)) !=
                    op2pm.obstructionum.interioreObstructionum.divisa)) {
                  print('corrumpere divisa');
                  print('corrupt divisa');
                  return;
                }
                for (Transaction tx in op2pm
                    .obstructionum.interioreObstructionum.liberTransactions) {
                  for (TransactionOutput output
                      in tx.interioreTransaction.outputs) {
                    if (!await Pera.isPublicaClavisDefended(
                        output.publicKey, dir)) {
                      print('publicarum clavium non defenditur');
                      print('one of the public keys is not defended');
                      return;
                    }
                  }
                  if (tx.probationem == Constantes.cashEx) {
                    if (obs
                            .interioreObstructionum
                            .cashExs[tx.interioreTransaction.outputs.first
                                .cashExIndex!]
                            .interioreCashEx
                            .signumCashEx
                            .nof !=
                        tx.interioreTransaction.outputs.first.app) {
                      print('invalid cashex');
                      return;
                    }
                  }
                }
                List<Transaction> transformOutputs = [];
                for (Transaction tx in op2pm
                    .obstructionum.interioreObstructionum.fixumTransactions) {
                  if (tx.probationem == 'transform') {
                    transformOutputs.add(tx);
                  } else {
                    if (!await tx.validateFixum(dir) ||
                        !tx.validateProbationem()) {
                      print("Corrumpere negotium in obstructionum");
                    }
                  }
                }
                List<Transaction> transformInputs = [];
                for (Transaction tx in op2pm
                    .obstructionum.interioreObstructionum.liberTransactions) {
                  switch (tx.probationem) {
                    case 'ardeat':
                      {
                        if (!await tx.validateBurn(dir)) {
                          print("irritum ardeat");
                          return;
                        }
                        break;
                      }
                    case 'transform':
                      {
                        transformInputs.add(tx);
                        break;
                      }
                    case 'obstructionum praemium':
                      {
                        if (!tx.validateBlockreward()) {
                          print('irritum obstructionum praemium');
                          return;
                        }
                        break;
                      }
                    case 'cashEx':
                      {
                        if (obs
                                .interioreObstructionum
                                .cashExs[tx.interioreTransaction.outputs.first
                                    .cashExIndex!]
                                .interioreCashEx
                                .signumCashEx
                                .nof !=
                            tx.interioreTransaction.outputs.first.app) {
                          print('irritum cash ex');
                          return;
                        }
                        break;
                      }
                    default:
                      {
                        if (!await tx.validateLiber(dir) ||
                            !tx.validateProbationem()) {
                          print("irritum tx");
                          return;
                        }
                        ;
                        break;
                      }
                  }
                }
                BigInt transformAble = BigInt.zero;
                for (List<TransactionInput> inputs in transformInputs
                    .map((tx) => tx.interioreTransaction.inputs)) {
                  for (TransactionInput input in inputs) {
                    obss.add(op2pm.obstructionum);
                    Obstructionum obstructionum = obss.singleWhere((ob) =>
                        ob.interioreObstructionum.liberTransactions.any((tx) =>
                            tx.interioreTransaction.id == input.transactionId));
                    Transaction tx = obstructionum
                        .interioreObstructionum.liberTransactions
                        .singleWhere((liber) =>
                            liber.interioreTransaction.id ==
                            input.transactionId);
                    if (!Utils.cognoscere(
                        PublicKey.fromHex(
                            Pera.curve(),
                            tx.interioreTransaction.outputs[input.index]
                                .publicKey),
                        Signature.fromASN1Hex(input.signature),
                        tx.interioreTransaction.outputs[input.index])) {
                      print("irritum tx");
                      return;
                    } else {
                      transformAble +=
                          tx.interioreTransaction.outputs[input.index].app;
                    }
                  }
                }
                BigInt transformed = BigInt.zero;

                for (List<TransactionOutput> outputs in transformOutputs
                    .map((tx) => tx.interioreTransaction.outputs)) {
                  for (TransactionOutput output in outputs) {
                    transformed += output.app;
                  }
                }
                if (transformAble != transformed) {
                  print("irritum transform");
                  return;
                }
                if (op2pm.obstructionum.interioreObstructionum.generare ==
                    Generare.EFECTUS) {
                  if (isExpressiActive) {
                    expressiRp.sendPort.send(true);
                  }
                  for (GladiatorOutput output in op2pm
                      .obstructionum.interioreObstructionum.gladiator.outputs) {
                    for (Propter propter in output.rationem) {
                      if (!propter.isProbationem()) {
                        print('invalidum probationem pro ratione');
                        return;
                      }
                    }
                  }
                  if (op2pm.obstructionum.interioreObstructionum
                          .liberTransactions
                          .where((liber) =>
                              liber.probationem ==
                              Constantes.txObstructionumPraemium)
                          .length !=
                      1) {
                    print("Insufficient obstructionum munera");
                    return;
                  }
                  // if (op2pm.obstructionum.interioreObstructionum.liberTransactions.where((liber) => liber.probationem == Constantes.transform).isNotEmpty) {
                  //   print("Insufficient transforms");
                  //   return;
                  // }
                  if (!op2pm.obstructionum.probationem.startsWith('0' *
                      op2pm.obstructionum.interioreObstructionum
                          .obstructionumDifficultas)) {
                    print("Insufficient leading zeros");
                  }
                } else if (op2pm
                        .obstructionum.interioreObstructionum.generare ==
                    Generare.CONFUSSUS) {
                  String gladiatorId = op2pm.obstructionum
                      .interioreObstructionum.gladiator.input!.gladiatorId;
                  int index = op2pm.obstructionum.interioreObstructionum
                      .gladiator.input!.index;
                  if (op2pm.obstructionum.interioreObstructionum.gladiator
                      .outputs.isNotEmpty) {
                    print("outputs arent liceat ad confossum");
                    return;
                  } else if (await Obstructionum.gladiatorConfodiantur(
                      op2pm.obstructionum.interioreObstructionum.gladiator
                          .input!.gladiatorId,
                      op2pm.obstructionum.interioreObstructionum.producentis,
                      dir)) {
                    print('clausus potest non oppugnare publica clavem');
                    print("block can't attack the same public key");
                    return;
                  }
                  Defensio turpiaDefensio =
                      await Pera.turpiaGladiatoriaDefensione(
                          index, gladiatorId, dir);
                  List<Defensio> deschefLiber = await Pera.maximeDefensiones(
                      true, index, gladiatorId, dir);
                  List<Defensio> deschefFixum = await Pera.maximeDefensiones(
                      false, index, gladiatorId, dir);
                  List<String> defensionesLiber =
                      deschefLiber.map((x) => x.defensio).toList();
                  List<String> defensionesFixum =
                      deschefFixum.map((x) => x.defensio).toList();
                  List<String> defensiones = [];
                  defensiones.add(turpiaDefensio.defensio);
                  defensiones.addAll(defensionesLiber);
                  defensiones.addAll(defensionesFixum);
                  bool coschon = false;
                  for (int i = 0; i < defensiones.length; i++) {
                    if (op2pm.obstructionum.probationem
                        .contains(defensiones[i])) {
                      coschon = true;
                    } else {
                      coschon = false;
                      break;
                    }
                  }
                  if (!coschon) {
                    print('gladiator non defeaten');
                    return;
                  }
                  int ardet = 0;
                  for (GladiatorOutput output
                      in obs.interioreObstructionum.gladiator.outputs) {
                    for (String propter in output.rationem
                        .map((x) => x.interioreRationem.publicaClavis)) {
                      final balance = await Pera.statera(true, propter, dir);
                      if (balance > BigInt.zero) {
                        ardet += 1;
                      }
                    }
                  }
                  if (op2pm.obstructionum.interioreObstructionum
                          .liberTransactions
                          .where(
                              (liber) => liber.probationem == Constantes.ardeat)
                          .length !=
                      ardet) {
                    print("Insufficiens ardet");
                    return;
                  }
                  // if (op2pm.obstructionum.interioreObstructionum.liberTransactions.where((liber) => liber.probationem == Constantes.transform).length != 1) {
                  //   print("Insufficiens transforms");
                  //   return;
                  // }
                  Obstructionum utCognoscereObstructionum = obss.singleWhere(
                      (o) =>
                          o.interioreObstructionum.gladiator.id ==
                          op2pm.obstructionum.interioreObstructionum.gladiator
                              .input!.gladiatorId);
                  GladiatorOutput utCognoscere = utCognoscereObstructionum
                          .interioreObstructionum.gladiator.outputs[
                      op2pm.obstructionum.interioreObstructionum.gladiator
                          .input!.index];
                  if (!Utils.cognoscereVictusGladiator(
                      PublicKey.fromHex(
                          Pera.curve(),
                          op2pm.obstructionum.interioreObstructionum
                              .producentis),
                      Signature.fromASN1Hex(op2pm.obstructionum
                          .interioreObstructionum.gladiator.input!.signature),
                      utCognoscere)) {
                    print('invalidum confossus gladiator');
                    print('invalid stabbed gladiator');
                  }
                } else if (op2pm
                        .obstructionum.interioreObstructionum.generare ==
                    Generare.EXPRESSI) {
                  expressiRp.sendPort.send(false);
                  String gladiatorId = op2pm.obstructionum
                      .interioreObstructionum.gladiator.input!.gladiatorId;
                  int index = op2pm.obstructionum.interioreObstructionum
                      .gladiator.input!.index;
                  if (op2pm.obstructionum.interioreObstructionum.gladiator
                      .outputs.isNotEmpty) {
                    print("outputs arent liceat ad confossum");
                    return;
                  } else if (await Obstructionum.gladiatorConfodiantur(
                      op2pm.obstructionum.interioreObstructionum.gladiator
                          .input!.gladiatorId,
                      op2pm.obstructionum.interioreObstructionum.producentis,
                      dir)) {
                    print('clausus potest non oppugnare publica clavem');
                    print("block can't attack the same public key");
                    return;
                  } else if (obs.interioreObstructionum.generare !=
                      Generare.EFECTUS) {
                    print(
                        'reproducat scandalum non potest esse nisi super efectus fi');
                    print(
                        'reproduce block can only be on top of an efectus block');
                    return;
                  }
                  Defensio turpiaDefensio =
                      await Pera.turpiaGladiatoriaDefensione(
                          index, gladiatorId, dir);
                  List<Defensio> deschefLiber = await Pera.maximeDefensiones(
                      true, index, gladiatorId, dir);
                  List<Defensio> deschefFixum = await Pera.maximeDefensiones(
                      false, index, gladiatorId, dir);
                  List<String> defensionesLiber =
                      deschefLiber.map((x) => x.defensio).toList();
                  List<String> defensionesFixum =
                      deschefFixum.map((x) => x.defensio).toList();
                  List<String> defensiones = [];
                  defensiones.add(turpiaDefensio.defensio);
                  defensiones.addAll(defensionesLiber);
                  defensiones.addAll(defensionesFixum);
                  bool coschon = false;
                  for (int i = 0; i < defensiones.length; i++) {
                    if (op2pm.obstructionum.probationem
                        .contains(defensiones[i])) {
                      coschon = true;
                    } else {
                      coschon = false;
                      break;
                    }
                  }
                  if (!coschon) {
                    print('gladiator non defeaten');
                    return;
                  }
                  int ardet = 0;
                  for (GladiatorOutput output
                      in obs.interioreObstructionum.gladiator.outputs) {
                    for (String propter in output.rationem
                        .map((x) => x.interioreRationem.publicaClavis)) {
                      final balance = await Pera.statera(true, propter, dir);
                      if (balance > BigInt.zero) {
                        ardet += 1;
                      }
                    }
                  }
                  if (op2pm.obstructionum.interioreObstructionum
                          .liberTransactions
                          .where(
                              (liber) => liber.probationem == Constantes.ardeat)
                          .length !=
                      ardet) {
                    print("Insufficiens ardet");
                    return;
                  }
                  // if (op2pm.obstructionum.interioreObstructionum.liberTransactions.where((liber) => liber.probationem == Constantes.transform).length != 1) {
                  //   print("Insufficiens transforms");
                  //   return;
                  // }
                  Obstructionum utCognoscereObstructionum = obss.singleWhere(
                      (o) =>
                          o.interioreObstructionum.gladiator.id ==
                          op2pm.obstructionum.interioreObstructionum.gladiator
                              .input!.gladiatorId);
                  GladiatorOutput utCognoscere = utCognoscereObstructionum
                          .interioreObstructionum.gladiator.outputs[
                      op2pm.obstructionum.interioreObstructionum.gladiator
                          .input!.index];
                  if (!Utils.cognoscereVictusGladiator(
                      PublicKey.fromHex(
                          Pera.curve(),
                          op2pm.obstructionum.interioreObstructionum
                              .producentis),
                      Signature.fromASN1Hex(op2pm.obstructionum
                          .interioreObstructionum.gladiator.input!.signature),
                      utCognoscere)) {
                    print('invalidum confossus gladiator');
                    print('invalid stabbed gladiator');
                  }
                  if (!op2pm.obstructionum.probationem.startsWith('0' *
                      (op2pm.obstructionum.interioreObstructionum
                                  .obstructionumDifficultas /
                              2)
                          .floor())) {
                    print('Insufficient leading zxeros');
                    return;
                  } else if (!op2pm.obstructionum.probationem.endsWith('0' *
                      (op2pm.obstructionum.interioreObstructionum
                                  .obstructionumDifficultas /
                              2)
                          .floor())) {
                    print('Insufficient trailing zeros');
                    return;
                  } else if (op2pm
                      .obstructionum.interioreObstructionum.liberTransactions
                      .where((liber) =>
                          liber.probationem ==
                          Constantes.txObstructionumPraemium)
                      .isNotEmpty) {
                    print("Insufficient obstructionum praemium");
                    return;
                  } else if (obs.interioreObstructionum.generare ==
                      Generare.EXPRESSI) {
                    print('non duo expressi cursus sustentabatur');
                    print('cannot produce two expressi blocks in a row');
                    return;
                  } else if (await Obstructionum.gladiatorConfodiantur(
                      op2pm.obstructionum.interioreObstructionum.gladiator
                          .input!.gladiatorId,
                      op2pm.obstructionum.interioreObstructionum.producentis,
                      dir)) {
                    print('clausus potest non oppugnare publica clavem');
                    print("block can't attack the same public key");
                    return;
                  }
                }
                await op2pm.obstructionum.salvare(dir);
                print(
                    'synced block ${op2pm.obstructionum.interioreObstructionum.obstructionumNumerus}');
                print(
                    'synced obstructionum ${op2pm.obstructionum.interioreObstructionum.obstructionumNumerus}');
                summaNumerus = op2pm
                    .obstructionum.interioreObstructionum.obstructionumNumerus;
                if (isEfectusActive) {
                  efectusRp.sendPort.send("");
                }
                if (isConfussusActive) {
                  confussusRp.sendPort.send("");
                }
                op2pm.recieved.add('${client.address.address}:${client.port}');
                List<String> to_send = sockets;
                to_send
                    .removeWhere((element) => op2pm.recieved.contains(element));
                for (String socket in to_send) {
                  Socket soschock = await Socket.connect(
                      socket.split(':')[0], int.parse(socket.split(':')[1]));
                  soschock.write(json.encode(op2pm.toJson()));
                  soschock.listen((data) async {
                    // List<List<String>> lines = [];
                    // for (int i = dir.listSync().length-1; i > -1 ; i--) {
                    //   List<String> lines = await Utils.fileAmnis(File('${dir.path}/${Constantes.fileNomen}$i.txt')).toList();
                    //   lines.addAll(lines);
                    // }
                    P2PMessage p2pm = P2PMessage.fromJson(
                        json.decode(String.fromCharCodes(data).trim())
                            as Map<String, dynamic>);
                    if (p2pm.type == 'request-obstructionum') {
                      RequestObstructionumP2PMessage rop2pm =
                          RequestObstructionumP2PMessage.fromJson(
                              json.decode(String.fromCharCodes(data).trim())
                                  as Map<String, dynamic>);
                      print('recieved request obstructionum ${rop2pm.numerus}');
                      print(rop2pm.numerus.length);
                      File caudices = File(
                          '${dir.path}/${Constantes.fileNomen}${rop2pm.numerus.length - 1}.txt');

                      // if (await Utils.fileAmnis(caudices).length > rop2pm.numerus.last) {
                      if (rop2pm.numerus.last <=
                          Constantes.maximeCaudicesFile) {
                        String obs = await Utils.fileAmnis(caudices)
                            .elementAt(rop2pm.numerus.last);
                        Obstructionum obsObs = Obstructionum.fromJson(
                            json.decode(obs) as Map<String, dynamic>);
                        soschock.write(json.encode(ObstructionumP2PMessage(
                                '', obsObs, 'obstructionum', sockets)
                            .toJson()));
                        print('sended block ${rop2pm.numerus}');
                      } else {
                        rop2pm.numerus.add(0);
                        String obs = await Utils.fileAmnis(caudices)
                            .elementAt(rop2pm.numerus.last);
                        Obstructionum obsObs = Obstructionum.fromJson(
                            json.decode(obs) as Map<String, dynamic>);
                        soschock.write(json.encode(ObstructionumP2PMessage(
                                '', obsObs, 'obstructionum', sockets)
                            .toJson()));
                        print('sended block ${rop2pm.numerus}');
                      }
                    } else if (p2pm.type == 'probationem') {
                      ProbationemP2PMessage ropp2pm =
                          ProbationemP2PMessage.fromJson(
                              json.decode(String.fromCharCodes(data).trim())
                                  as Map<String, dynamic>);
                      print('recieved probationem ${ropp2pm.probationem}');
                      //all you have todo is find out the difference in numbers of that array we speak of
                      //
                      // Obstructionum? obst = await Utils.accipereObstructionumPriorProbationem(ropp2pm.probationem, dir);
                      // the prior obstructionum is our highest block and we wanna have the prior obstructionum of the nodes highest block
                      // we have to compare arrays of blocknumbers and find out the difference
                      // so we have this index and if it is thhis index we would like to increment the index
                      // is it time for the difference
                      // as soon as the difficulty is greater than one it still fails
                      // we just grab a prior probationem untill we found it and then we should send it
                      // we have more right so we will find the s
                      Obstructionum priorObstructionumProbationem =
                          await Utils.priorObstructionumProbationem(0, dir);
                      // if the probationem euals the priorProbationem of the block we have to send
                      //
                      int index = 0;
                      bool found = true;
                      //when it doesnt find a match here it sends the incipio block of which the total difficulty isnt greater than-
                      while (ropp2pm.probationem !=
                          priorObstructionumProbationem
                              .interioreObstructionum.priorProbationem) {
                        // its kind a double
                        // this is mroe ore like a obstructionum
                        //maby this is enough
                        // if it found the incipio we go one block back
                        // it does remove for each block we press sync but this should be a loop to sync
                        // so actually it should find the first efectus instead of the incipio and quit there
                        if (priorObstructionumProbationem
                                .interioreObstructionum.generare ==
                            Generare.INCIPIO) {
                          index--;
                          priorObstructionumProbationem =
                              await Utils.priorObstructionumProbationem(
                                  index, dir);
                          break;
                        }
                        priorObstructionumProbationem =
                            await Utils.priorObstructionumProbationem(
                                index, dir);
                        print(priorObstructionumProbationem.toJson());
                        index++;
                      }
                      // so that remove probationem was handy because we cant remove if the difficulty isnt greater than
                      //so wif we send the incipio block the difficulty isnt greater so it does nothing
                      // one of the solutions would be a different obstructionum listener to accept blocks with a lower difficulty
                      // but the problem that occurs is that everyone can hit this endpoint and replace the chain
                      // so you would need a certain proof too proof your total chain has a greater difficulty
                      // so we need to invent a proof
                      // how do we proof we have a greater difficulty without a greater difficulty
                      // maby we dont need a proof like that because when it syncs it keeps on checking for a greater difficulty
                      // once we sync the greater difficulty we can create a secret and resude that secret when we send a block with a lower difficulty
                      // a different approach would be to delete so that total difficulty decreases too too messy
                      soschock.write(json.encode(ObstructionumP2PMessage(
                              ropp2pm.secret,
                              priorObstructionumProbationem,
                              'obstructionum',
                              sockets)
                          .toJson()));
                      print(
                          'sended ${priorObstructionumProbationem.interioreObstructionum.obstructionumNumerus}');
                      // if (ropp2pm.probationem != priorObstructionum.interioreObstructionum.probationem) {
                      //   soschock.write(json.encode(RequestProbationemP2PMessage(ropp2pm.index, 'request-probationem').toJson()));
                      //   print('couldnt find block with probationem request previous probationem');
                      // } else {
                      //   soschock.write(json.encode(ObstructionumP2PMessage(priorObstructionum, hashes, 'obstructionum').toJson()));
                      //   print('sended block ${obst.interioreObstructionum.obstructionumNumerus}');
                      // }
                    }
                    client.destroy();
                  }); //
                }
                // P2P.syncBlock(List<dynamic>.from([op2pm.obstructionum, sockets.length > 1 ? sockets.skip(sockets.indexOf('$from')).toList() : sockets, dir, '${client.address.address}:${client.port}']));
                // for (ReceivePort rp in efectusMiners) {
                //
                // }
                // sp.send("yupdate miner");

                // obs = await Utils.priorObstructionum(dir);
                if (summaNumerus.last < Constantes.maximeCaudicesFile) {
                  summaNumerus[summaNumerus.length - 1] = summaNumerus.last + 1;
                } else {
                  summaNumerus.add(0);
                }

                client.write(json.encode(RequestObstructionumP2PMessage(
                        summaNumerus,
                        'request-obstructionum',
                        List<String>.from(
                            ['${client.address.address}:${client.port}']))
                    .toJson()));
                print('requested block $summaNumerus');
                // await syncBlock(obs);
              } else {
                print('secrets');
                print(op2pm.secret);
                print(secret);
                if (op2pm.obstructionum.interioreObstructionum.divisa >
                        obs.interioreObstructionum.divisa &&
                    op2pm.secret != secret) {
                  print('divisa is greater than block to replace');
                  print('divisa est maior quam obstructionum reponere');
                  return;
                }
                print('had lover divisa');
                // we remove our highest probationem
                // here it could remove block one or the latest block
                // it works with one blocks difference
                // we dont have the matching probationem here we only have the prior probationem
                // and so we remove one block from our chain which could work to
                // ut it has to stay in the loop untill it found a matching one-
                // we send back the highest probationem but stays the difficulty greater than
                // yes it does but if the probationem doesnt match any
                //but than we remove the block that is new
                print(
                    'remota summum obstructionum cum probationem ${obs.probationem}');
                await Utils.removeObstructionumsUntilProbationem(dir);
                client.write(json.encode(ProbationemP2PMessage(
                        obs.probationem,
                        secret,
                        'probationem',
                        List<String>.from(
                            ['${client.address.address}:${client.port}']))
                    .toJson()));
              }
            }
          }
        }

        // client.destroy();
        //  else if (msg.type == 'remove-obstructionum') {
        //     ProbationemP2PMessage pp2pm = ProbationemP2PMessage.fromJson(json.decode(String.fromCharCodes(data).trim()));
        //     await Utils.removeObstructionumsUntilProbationem(pp2pm.probationem, dir);
        //     print('remota obstructionum cum probationem ${pp2pm.probationem}');
        //     Obstructionum prior = await Utils.priorObstructionum(dir);
        //     client.write(json.encode(ProbationemP2PMessage(prior.interioreObstructionum.priorProbationem, 'probationem').toJson()));
        // }
      }).onError(print);
    });
  }

  void connect(String bootnode, String me) async {
    sockets.add(bootnode);
    Socket socket = await Socket.connect(
        bootnode.split(':')[0], int.parse(bootnode.split(':')[1]));
    socket.write(json.encode(ConnectBootnodeP2PMessage(
        me, 'connect-bootnode', List<String>.from([me])).toJson()));
    socket.listen((data) async {
      OnConnectP2PMessage ocp2pm = OnConnectP2PMessage.fromJson(json
          .decode(String.fromCharCodes(data).trim()) as Map<String, dynamic>);
      if (sockets.length < maxPeers) {
        sockets.addAll(ocp2pm.sockets.take((maxPeers - sockets.length)));
      }
      propters.addAll(ocp2pm.propters);
      liberTxs.addAll(ocp2pm.liberTxs);
      fixumTxs.addAll(ocp2pm.fixumTxs);
    });
  }

  void syncPropter(Propter propter) async {
    if (propters
        .any((p) => p.interioreRationem.id == propter.interioreRationem.id)) {
      propters.removeWhere(
          (p) => p.interioreRationem.id == propter.interioreRationem.id);
    }
    propters.add(propter);
    for (String socket in sockets) {
      Socket soschock = await Socket.connect(
          socket.split(':')[0], int.parse(socket.split(':')[1]));
      soschock.write(
          json.encode(PropterP2PMessage(propter, 'propter', sockets).toJson()));
    }
  }

  void syncHumanify(Humanify humanify) async {
    if (humanifies
        .any((element) => element.interiore.id == humanify.interiore.id)) {
      humanifies.removeWhere(
          (element) => element.interiore.id == humanify.interiore.id);
    }
    humanifies.add(humanify);
    for (String socket in sockets) {
      Socket soschock = await Socket.connect(
          socket.split(':')[0], int.parse(socket.split(':')[1]));
      soschock.write(json
          .encode(HumanifyP2PMessage(humanify, 'humanify', sockets).toJson()));
      await soschock.close();
    }
  }

  void syncCashEx(CashEx cashEx) async {
    if (cashExs.any((element) =>
        element.interioreCashEx.signumCashEx.id ==
        cashEx.interioreCashEx.signumCashEx.id)) {
      cashExs.removeWhere((element) =>
          element.interioreCashEx.signumCashEx.id ==
          cashEx.interioreCashEx.signumCashEx.id);
    }
    cashExs.add(cashEx);
    for (String socket in sockets) {
      Socket soschock = await Socket.connect(
          socket.split(':')[0], int.parse(socket.split(':')[1]));
      soschock.write(
          json.encode(CashExP2PMessage(cashEx, 'cash-ex', sockets).toJson()));
    }
  }

  void syncLiberTx(Transaction tx) async {
    if (liberTxs
        .any((t) => t.interioreTransaction.id == tx.interioreTransaction.id)) {
      liberTxs.removeWhere(
          (t) => t.interioreTransaction.id == tx.interioreTransaction.id);
    }
    liberTxs.add(tx);
    for (String socket in sockets) {
      Socket soschock = await Socket.connect(
          socket.split(':')[0], int.parse(socket.split(':')[1]));
      soschock.write(
          json.encode(TransactionP2PMessage(tx, 'liber-tx', sockets).toJson()));
      soschock.listen((data) async {
        RemoveTransactionsP2PMessage rtp2pm =
            RemoveTransactionsP2PMessage.fromJson(
                json.decode(String.fromCharCodes(data).trim())
                    as Map<String, dynamic>);
        liberTxs.removeWhere(
            (liber) => rtp2pm.ids.contains(liber.interioreTransaction.id));
      });
    }
  }

  void syncExpressiTx(Transaction tx) async {
    expressieTxs.add(tx);
    for (String socket in sockets) {
      Socket soschock = await Socket.connect(
          socket.split(':')[0], int.parse(socket.split(':')[1]));
      soschock.write(json
          .encode(TransactionP2PMessage(tx, 'expressi-tx', sockets).toJson()));
    }
  }

  void syncFixumTx(Transaction tx) async {
    if (fixumTxs
        .any((t) => t.interioreTransaction.id == tx.interioreTransaction.id)) {
      fixumTxs.removeWhere(
          (t) => t.interioreTransaction.id == tx.interioreTransaction.id);
    }
    fixumTxs.add(tx);
    for (String socket in sockets) {
      Socket soschock = await Socket.connect(
          socket.split(':')[0], int.parse(socket.split(':')[1]));
      soschock.write(
          json.encode(TransactionP2PMessage(tx, 'fixum-tx', sockets).toJson()));
      soschock.listen((data) async {
        RemoveTransactionsP2PMessage rtp2pm =
            RemoveTransactionsP2PMessage.fromJson(
                json.decode(String.fromCharCodes(data).trim())
                    as Map<String, dynamic>);
        fixumTxs.removeWhere(
            (fixum) => rtp2pm.ids.contains(fixum.interioreTransaction.id));
      });
    }
  }

  void syncScan(Scan scan) async {
    if (scans.any((s) => s.interioreScan.id == scan.interioreScan.id)) {
      scans.removeWhere((s) => s.interioreScan.id == scan.interioreScan.id);
    }
    scans.add(scan);
    for (String socket in sockets) {
      Socket soschock = await Socket.connect(
          socket.split(':')[0], int.parse(socket.split(':')[1]));
      soschock.write(json.encode(ScanP2PMessage(scan, 'scan', sockets)));
    }
  }

  void removePropters(List<String> ids) async {
    propters.removeWhere((p) => ids.any((i) => i == p.interioreRationem.id));
    for (String socket in sockets) {
      Socket soschock = await Socket.connect(
          socket.split(':')[0], int.parse(socket.split(':')[1]));
      soschock.write(json.encode(
          RemoveProptersP2PMessage(ids, 'remove-propters', sockets).toJson()));
    }
  }

  void removeHumanify(String id) async {
    humanifies.removeWhere((h) => h.interiore.id == id);
    for (String socket in sockets) {
      Socket soschock = await Socket.connect(
          socket.split(':')[0], int.parse(socket.split(':')[1]));
      soschock.write(json
          .encode(RemoveHumanifyP2PMessage(id, 'remove-humanify', sockets)));
    }
  }

  void removeScans(List<String> ids) async {
    scans.removeWhere((l) => ids.any((i) => i == l.interioreScan.id));
    for (String socket in sockets) {
      Socket soschock = await Socket.connect(
          socket.split(':')[0], int.parse(socket.split(':')[1]));
      soschock.write(json.encode(
          RemoveScansP2PMessage(ids, 'remove-scans', sockets).toJson()));
    }
  }

  void removeCashExs(List<String> ids) async {
    cashExs.removeWhere(
        (l) => ids.any((i) => i == l.interioreCashEx.signumCashEx.id));
    for (String socket in sockets) {
      Socket soschock = await Socket.connect(
          socket.split(':')[0], int.parse(socket.split(':')[1]));
      soschock.write(json
          .encode(RemoveCashExP2PMessage(ids, 'cash-exs', sockets).toJson()));
    }
  }

  void removeLiberTxs(List<String> ids) async {
    liberTxs.removeWhere((l) => ids.any((i) => i == l.interioreTransaction.id));
    for (String socket in sockets) {
      Socket soschock = await Socket.connect(
          socket.split(':')[0], int.parse(socket.split(':')[1]));
      soschock.write(json.encode(
          RemoveTransactionsP2PMessage(ids, 'remove-liber-txs', sockets)
              .toJson()));
    }
  }

  void removeFixumTxs(List<String> ids) async {
    fixumTxs.removeWhere((f) => ids.contains(f.interioreTransaction.id));
    for (String socket in sockets) {
      Socket soschock = await Socket.connect(
          socket.split(':')[0], int.parse(socket.split(':')[1]));
      soschock.write(json.encode(
          RemoveTransactionsP2PMessage(ids, 'remove-fixum-txs', sockets)
              .toJson()));
    }
  }

  // listenAfterSend(data) async {
  //   P2PMessage p2pm = P2PMessage.fromJson(
  //       json.decode(String.fromCharCodes(data).trim()) as Map<String, dynamic>);
  //   if (p2pm.type == 'request-obstructionum') {
  //     RequestObstructionumP2PMessage rop2pm =
  //         RequestObstructionumP2PMessage.fromJson(
  //             json.decode(String.fromCharCodes(data).trim())
  //                 as Map<String, dynamic>);
  //     print('recieved request obstructionum ${rop2pm.numerus}');
  //     print(rop2pm.numerus.length);
  //     File caudices = File(
  //         '${dir.path}/${Constantes.fileNomen}${rop2pm.numerus.length - 1}.txt');

  //     // if (await Utils.fileAmnis(caudices).length > rop2pm.numerus.last) {
  //     if (rop2pm.numerus.last <= Constantes.maximeCaudicesFile) {
  //       String obs =
  //           await Utils.fileAmnis(caudices).elementAt(rop2pm.numerus.last);
  //       Obstructionum obsObs =
  //           Obstructionum.fromJson(json.decode(obs) as Map<String, dynamic>);
  //       soschock.write(json.encode(
  //           ObstructionumP2PMessage('', obsObs, 'obstructionum', sockets)
  //               .toJson()));
  //       print('sended block ${rop2pm.numerus}');
  //     } else {
  //       rop2pm.numerus.add(0);
  //       String obs =
  //           await Utils.fileAmnis(caudices).elementAt(rop2pm.numerus.last);
  //       Obstructionum obsObs =
  //           Obstructionum.fromJson(json.decode(obs) as Map<String, dynamic>);
  //       soschock.write(json.encode(
  //           ObstructionumP2PMessage('', obsObs, 'obstructionum', sockets)
  //               .toJson()));
  //       print('sended block ${rop2pm.numerus}');
  //     }
  //   } else if (p2pm.type == 'probationem') {
  //     ProbationemP2PMessage ropp2pm = ProbationemP2PMessage.fromJson(json
  //         .decode(String.fromCharCodes(data).trim()) as Map<String, dynamic>);
  //     print('recieved probationem ${ropp2pm.probationem}');
  //     //all you have todo is find out the difference in numbers of that array we speak of
  //     //
  //     // Obstructionum? obst = await Utils.accipereObstructionumPriorProbationem(ropp2pm.probationem, dir);
  //     // the prior obstructionum is our highest block and we wanna have the prior obstructionum of the nodes highest block
  //     // we have to compare arrays of blocknumbers and find out the difference
  //     // so we have this index and if it is thhis index we would like to increment the index
  //     // is it time for the difference
  //     // as soon as the difficulty is greater than one it still fails
  //     // we just grab a prior probationem untill we found it and then we should send it
  //     // we have more right so we will find the s
  //     Obstructionum priorObstructionumProbationem =
  //         await Utils.priorObstructionumProbationem(0, dir);
  //     // if the probationem euals the priorProbationem of the block we have to send
  //     //
  //     int index = 0;
  //     bool found = true;
  //     //when it doesnt find a match here it sends the incipio block of which the total difficulty isnt greater than-
  //     while (ropp2pm.probationem !=
  //         priorObstructionumProbationem
  //             .interioreObstructionum.priorProbationem) {
  //       // its kind a double
  //       // this is mroe ore like a obstructionum
  //       //maby this is enough
  //       // if it found the incipio we go one block back
  //       // it does remove for each block we press sync but this should be a loop to sync
  //       // so actually it should find the first efectus instead of the incipio and quit there
  //       if (priorObstructionumProbationem.interioreObstructionum.generare ==
  //           Generare.INCIPIO) {
  //         index--;
  //         priorObstructionumProbationem =
  //             await Utils.priorObstructionumProbationem(index, dir);
  //         break;
  //       }
  //       priorObstructionumProbationem =
  //           await Utils.priorObstructionumProbationem(index, dir);
  //       print(priorObstructionumProbationem.toJson());
  //       index++;
  //     }
  //     // so that remove probationem was handy because we cant remove if the difficulty isnt greater than
  //     //so wif we send the incipio block the difficulty isnt greater so it does nothing
  //     // one of the solutions would be a different obstructionum listener to accept blocks with a lower difficulty
  //     // but the problem that occurs is that everyone can hit this endpoint and replace the chain
  //     // so you would need a certain proof too proof your total chain has a greater difficulty
  //     // so we need to invent a proof
  //     // how do we proof we have a greater difficulty without a greater difficulty
  //     // maby we dont need a proof like that because when it syncs it keeps on checking for a greater difficulty
  //     // once we sync the greater difficulty we can create a secret and resude that secret when we send a block with a lower difficulty
  //     // a different approach would be to delete so that total difficulty decreases too too messy
  //     soschock.write(json.encode(ObstructionumP2PMessage(ropp2pm.secret,
  //             priorObstructionumProbationem, 'obstructionum', sockets)
  //         .toJson()));
  //     print(
  //         'sended ${priorObstructionumProbationem.interioreObstructionum.obstructionumNumerus}');
  //     // if (ropp2pm.probationem != priorObstructionum.interioreObstructionum.probationem) {
  //     //   soschock.write(json.encode(RequestProbationemP2PMessage(ropp2pm.index, 'request-probationem').toJson()));
  //     //   print('couldnt find block with probationem request previous probationem');
  //     // } else {
  //     //   soschock.write(json.encode(ObstructionumP2PMessage(priorObstructionum, hashes, 'obstructionum').toJson()));
  //     //   print('sended block ${obst.interioreObstructionum.obstructionumNumerus}');
  //     // }
  //   }
  // }
  static void syncBlock(List<dynamic> args) async {
    Obstructionum obs = args[0] as Obstructionum;
    List<String> sockets = args[1] as List<String>;
    Directory dir = args[2] as Directory;
    String from = args[3] as String;
    // if(obs.interioreObstructionum.generare == Generare.EFECTUS || obs.interioreObstructionum.generare == Generare.EXPRESSI) {
    //   expressieTxs = [];
    // }
    for (String socket in sockets) {
      Socket soschock = await Socket.connect(
          socket.split(':')[0], int.parse(socket.split(':')[1]));
      List<List<String>> hashes = [];
      // sockets.remove(socket)
      // for (int i = 0; i < dir.listSync().length; i++) {
      //   hashes.add([]);
      //   List<String> lines = await Utils.fileAmnis(File('${dir.path}/${Constantes.fileNomen}$i.txt')).toList();
      //   for (String line in lines) {
      //     if (total < 100) {
      //       hashes[idx].add(Obstructionum.fromJson(json.decode(line)).probationem);
      //       total++;
      //     }
      //   }
      //   idx++;
      // }
      soschock.write(json.encode(
          ObstructionumP2PMessage('', obs, 'obstructionum', sockets).toJson()));
      print('sended ${obs.interioreObstructionum.obstructionumNumerus}');
      soschock.listen((data) async {
        // List<List<String>> lines = [];
        // for (int i = dir.listSync().length-1; i > -1 ; i--) {
        //   List<String> lines = await Utils.fileAmnis(File('${dir.path}/${Constantes.fileNomen}$i.txt')).toList();
        //   lines.addAll(lines);
        // }
        P2PMessage p2pm = P2PMessage.fromJson(json
            .decode(String.fromCharCodes(data).trim()) as Map<String, dynamic>);
        if (p2pm.type == 'request-obstructionum') {
          RequestObstructionumP2PMessage rop2pm =
              RequestObstructionumP2PMessage.fromJson(
                  json.decode(String.fromCharCodes(data).trim())
                      as Map<String, dynamic>);
          print('recieved request obstructionum ${rop2pm.numerus}');
          print(rop2pm.numerus.length);
          File caudices = File(
              '${dir.path}/${Constantes.fileNomen}${rop2pm.numerus.length - 1}.txt');

          // if (await Utils.fileAmnis(caudices).length > rop2pm.numerus.last) {
          if (rop2pm.numerus.last <= Constantes.maximeCaudicesFile) {
            String obs =
                await Utils.fileAmnis(caudices).elementAt(rop2pm.numerus.last);
            Obstructionum obsObs = Obstructionum.fromJson(
                json.decode(obs) as Map<String, dynamic>);
            soschock.write(json.encode(
                ObstructionumP2PMessage('', obsObs, 'obstructionum', sockets)
                    .toJson()));
            print('sended block ${rop2pm.numerus}');
          } else {
            rop2pm.numerus.add(0);
            String obs =
                await Utils.fileAmnis(caudices).elementAt(rop2pm.numerus.last);
            Obstructionum obsObs = Obstructionum.fromJson(
                json.decode(obs) as Map<String, dynamic>);
            soschock.write(json.encode(
                ObstructionumP2PMessage('', obsObs, 'obstructionum', sockets)
                    .toJson()));
            print('sended block ${rop2pm.numerus}');
          }
        } else if (p2pm.type == 'probationem') {
          ProbationemP2PMessage ropp2pm = ProbationemP2PMessage.fromJson(
              json.decode(String.fromCharCodes(data).trim())
                  as Map<String, dynamic>);
          print('recieved probationem ${ropp2pm.probationem}');
          //all you have todo is find out the difference in numbers of that array we speak of
          //
          // Obstructionum? obst = await Utils.accipereObstructionumPriorProbationem(ropp2pm.probationem, dir);
          // the prior obstructionum is our highest block and we wanna have the prior obstructionum of the nodes highest block
          // we have to compare arrays of blocknumbers and find out the difference
          // so we have this index and if it is thhis index we would like to increment the index
          // is it time for the difference
          // as soon as the difficulty is greater than one it still fails
          // we just grab a prior probationem untill we found it and then we should send it
          // we have more right so we will find the s
          Obstructionum priorObstructionumProbationem =
              await Utils.priorObstructionumProbationem(0, dir);
          // if the probationem euals the priorProbationem of the block we have to send
          //
          int index = 0;
          bool found = true;
          //when it doesnt find a match here it sends the incipio block of which the total difficulty isnt greater than-
          while (ropp2pm.probationem !=
              priorObstructionumProbationem
                  .interioreObstructionum.priorProbationem) {
            // its kind a double
            // this is mroe ore like a obstructionum
            //maby this is enough
            // if it found the incipio we go one block back
            // it does remove for each block we press sync but this should be a loop to sync
            // so actually it should find the first efectus instead of the incipio and quit there
            if (priorObstructionumProbationem.interioreObstructionum.generare ==
                Generare.INCIPIO) {
              index--;
              priorObstructionumProbationem =
                  await Utils.priorObstructionumProbationem(index, dir);
              break;
            }
            priorObstructionumProbationem =
                await Utils.priorObstructionumProbationem(index, dir);
            print(priorObstructionumProbationem.toJson());
            index++;
          }
          // so that remove probationem was handy because we cant remove if the difficulty isnt greater than
          //so wif we send the incipio block the difficulty isnt greater so it does nothing
          // one of the solutions would be a different obstructionum listener to accept blocks with a lower difficulty
          // but the problem that occurs is that everyone can hit this endpoint and replace the chain
          // so you would need a certain proof too proof your total chain has a greater difficulty
          // so we need to invent a proof
          // how do we proof we have a greater difficulty without a greater difficulty
          // maby we dont need a proof like that because when it syncs it keeps on checking for a greater difficulty
          // once we sync the greater difficulty we can create a secret and resude that secret when we send a block with a lower difficulty
          // a different approach would be to delete so that total difficulty decreases too too messy
          soschock.write(json.encode(ObstructionumP2PMessage(ropp2pm.secret,
                  priorObstructionumProbationem, 'obstructionum', sockets)
              .toJson()));
          print(
              'sended ${priorObstructionumProbationem.interioreObstructionum.obstructionumNumerus}');
          // if (ropp2pm.probationem != priorObstructionum.interioreObstructionum.probationem) {
          //   soschock.write(json.encode(RequestProbationemP2PMessage(ropp2pm.index, 'request-probationem').toJson()));
          //   print('couldnt find block with probationem request previous probationem');
          // } else {
          //   soschock.write(json.encode(ObstructionumP2PMessage(priorObstructionum, hashes, 'obstructionum').toJson()));
          //   print('sended block ${obst.interioreObstructionum.obstructionumNumerus}');
          // }
        }
      });
    }
  }
}
