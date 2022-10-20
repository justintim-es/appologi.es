import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:appologi_es/models/utils.dart';
import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_open_api/v3.dart';

class NumerusController extends ResourceController {
  Directory directory;
  NumerusController(this.directory);

  @Operation.get()
  Future<Response> numerus() async {
    Obstructionum obs = await Utils.priorObstructionum(directory);
    return Response.ok(
        {"numerus": obs.interioreObstructionum.obstructionumNumerus});
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    return {
      "200": APIResponse.schema("Fetched block number",
          APISchemaObject.array(ofSchema: APISchemaObject.integer()))
    };
  }
}
