import 'dart:io';
import 'package:conduit_open_api/v3.dart';
import 'package:conduit_common/conduit_common.dart';
import 'package:conduit/conduit.dart';
import 'package:appologi_es/models/pera.dart';
import 'package:appologi_es/models/errors.dart';

class DefensioBidController extends ResourceController {
  Directory directory;
  DefensioBidController(this.directory);
  @Operation.get('liber', 'index', 'probationem', 'gladiatorId')
  Future<Response> yourBidDefensio() async {
    final lischib = request!.path.variables['liber'] == 'true';
    final int index = int.parse(request!.path.variables['index']!);
    String probationem = "";
    final yourBid = await Pera.yourBid(
        lischib,
        int.parse(request!.path.variables['index']!),
        request!.path.variables['probationem']!,
        request!.path.variables['gladiatorId']!,
        directory);
    return Response.ok({
      "defensio": await Pera.basisDefensione(
          request!.path.variables['probationem']!, directory),
      "yourBid": yourBid.toString(),
      "probationem": request!.path.variables['probationem'],
      "index": int.parse(request!.path.variables['index']!)
    });
  }

  @Operation.get('liber', 'index', 'probationem')
  Future<Response> summaBidDefensio() async {
    final lischib = request!.path.variables['liber'] == 'true';
    final int index = int.parse(request!.path.variables['index']!);
    final String probationem = request!.path.variables['probationem']!;
    try {
      BigInt summaBid =
          await Pera.summaBid(lischib, index, probationem, directory);
      return Response.ok({
        "defensio": await Pera.basisDefensione(probationem, directory),
        "summaBid": summaBid.toString(),
        "probationem": probationem,
        "index": index
      });
    } on Error catch (err) {
      return Response.badRequest(body: err.toJson());
    }
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    if (operation.pathVariables.contains("gladiatorId")) {
      return {
        "200": APIResponse.schema(
            "Fetch your bid upon a defensio of a block",
            APISchemaObject.object({
              "defensio": APISchemaObject.string(),
              "yourBid": APISchemaObject.integer(),
              "probationem": APISchemaObject.string(),
              "index": APISchemaObject.integer()
            }))
      };
    } else {
      return {
        "200": APIResponse.schema(
            "Fetch highest bid upon a defensio of a block",
            APISchemaObject.object({
              "defensio": APISchemaObject.string(),
              "summaBid": APISchemaObject.integer(),
              "probationem": APISchemaObject.string(),
              "index": APISchemaObject.integer()
            }))
      };
    }
  }
}
