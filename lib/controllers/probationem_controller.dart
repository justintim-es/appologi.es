import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:appologi_es/models/exampla.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:appologi_es/models/utils.dart';
import 'package:collection/collection.dart';

class ProbationemController extends ResourceController {
  Directory directory;
  ProbationemController(this.directory);
  @Operation.post()
  Future<Response> probationem(@Bind.body() Probationems prop) async {
    List<Obstructionum> obs = await Utils.getObstructionums(directory);
    if (obs.length == 1) return Response.ok([obs.first.probationem]);
    int start = 0;
    int end = 0;
    for (int i = 0; i < obs.length; i++) {
      if (ListEquality().equals(
          obs[i].interioreObstructionum.obstructionumNumerus,
          prop.firstIndex)) {
        start = i;
      }
      if (ListEquality().equals(
          obs[i].interioreObstructionum.obstructionumNumerus, prop.lastIndex)) {
        end = i;
      }
    }
    return Response.ok(
        obs.map((o) => o.probationem).toList().getRange(start, end).toList());
  }
}
