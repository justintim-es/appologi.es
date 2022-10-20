import 'dart:io';
import 'dart:isolate';

import 'package:conduit/conduit.dart';
import 'package:hex/hex.dart';
import 'package:appologi_es/models/exampla.dart';
import 'package:appologi_es/models/humanify.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:appologi_es/models/utils.dart';
import 'package:appologi_es/p2p.dart';
import 'package:mime/mime.dart';
import 'package:lzma/lzma.dart';
import 'package:image/image.dart';

class HumanifyController extends ResourceController {
  Directory directory;
  P2P p2p;
  Map<String, Isolate> humanifyIsolates;
  HumanifyController(this.directory, this.p2p, this.humanifyIsolates) {
    acceptedContentTypes = [ContentType("multipart", "form-data")];
  }

  @Operation.post('dominus', 'quaestio', 'respondere')
  Future<Response> upload(
      @Bind.path('dominus') String dominus,
      @Bind.path('quaestio') String quaestio,
      @Bind.path('respondere') String respondere) async {
    final boundary = request!.raw.headers.contentType!.parameters["boundary"]!;
    final transformer = MimeMultipartTransformer(boundary);
    final bodyBytes = await request!.body.decode<List<int>>();
    final bodyStream = Stream.fromIterable([bodyBytes]);
    final parts = await transformer.bind(bodyStream).toList();
    for (var part in parts) {
      final headers = part.headers;
      final body = await part.toList();
      final ischim = decodeImage(body[0]);
      // final resized = copyResizeCropSquare(ischim!, 10);
      // print(HEX.encode(encodePng(shrinked)));
      final InterioreHumanify humanify = InterioreHumanify(dominus, respondere,
          quaestio, HEX.encode(lzma.encode(encodeJpg(ischim!, quality: 1))));
      final ReceivePort acciperePortus = ReceivePort();
      humanifyIsolates[humanify.id] = await Isolate.spawn(Humanify.quaestum,
          List<dynamic>.from([humanify, acciperePortus.sendPort]));
      acciperePortus.listen((huschum) {
        print('synchumanify');
        p2p.syncHumanify(huschum as Humanify);
      });
    }
    return Response.ok("");
  }

  @Operation.get()
  Future<Response> pool() async {
    return Response.ok(p2p.humanifies);
  }
}
