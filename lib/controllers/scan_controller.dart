import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:elliptic/elliptic.dart';
import 'package:hex/hex.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:appologi_es/models/humanify.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:appologi_es/models/pera.dart';
import 'package:appologi_es/models/scan.dart';
import 'package:appologi_es/models/utils.dart';
import 'package:appologi_es/p2p.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:lzma/lzma.dart';

class ScanController extends ResourceController {
  Directory directory;
  P2P p2p;
  ScanController(this.directory, this.p2p) {
    acceptedContentTypes = [ContentType("multipart", "form-data")];
  }

  @Operation.get()
  Future<Response> hash() async {
    List<List<Scan>> scans = [];
    List<Obstructionum> obss = await Utils.getObstructionums(directory);
    List<Humanify?> humanifies = [];
    for (Obstructionum obs in obss) {
      scans.add(obs.interioreObstructionum.scans);
      humanifies.add(obs.interioreObstructionum.humanify);
    }
    List<HumanifyAnswer?> inputs = [];
    inputs.addAll(p2p.scans.map((e) => e.interioreScan.humanifyAnswer));

    final filtered = humanifies.where((element) =>
        !inputs.any((i) => i?.probationem == element?.probationem) &&
        element != null);
    if (filtered.isEmpty) {
      return Response.badRequest(body: "No humanify available, refresh");
    }
    return Response.ok({
      "probationem": filtered.last!.probationem,
      "index": filtered.length,
      "quaestio": filtered.last!.interiore.quaestio
    });
  }

  @Operation.get('probationem')
  Future<Response> image(@Bind.path('probationem') String probationem) async {
    List<Obstructionum> obss = await Utils.getObstructionums(directory);
    for (Obstructionum obs in obss) {
      if (obs.interioreObstructionum.humanify?.probationem == probationem) {
        return Response.ok(lzma.decode(
            HEX.decode(obs.interioreObstructionum.humanify!.interiore.img!)))
          ..contentType = ContentType("image", "jpeg");
      }
    }
    return Response.badRequest(body: "no image found for probationem");
  }
}
