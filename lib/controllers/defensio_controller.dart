import 'dart:io';
import 'package:conduit/conduit.dart';
import 'package:appologi_es/models/errors.dart';
import 'package:appologi_es/models/pera.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:conduit_common/conduit_common.dart';

class DefensioController extends ResourceController {
  Directory directory;
  DefensioController(this.directory);
  @Operation.get('index', 'gladiatorId')
  Future<Response> basisDefensiones() async {
    final int index = int.parse(request!.path.variables['index']!);
    final String gladiatorId = request!.path.variables['gladiatorId']!;
    final defensio =
        await Pera.turpiaGladiatoriaDefensione(index, gladiatorId, directory);
    return Response.ok(defensio.toJson());
  }

  @Operation.get('index', 'gladiatorId', 'liber')
  Future<Response> defensiones() async {
    final lischib = request!.path.variables['liber'] == 'true';
    List<Defensio> def = await Pera.maximeDefensiones(
        lischib,
        int.parse(request!.path.variables['index']!),
        request!.path.variables['gladiatorId']!,
        directory);
    return Response.ok(def.map((x) => x.toJson()).toList());
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    if (!operation.pathVariables.contains("liber")) {
      return {
        "200": APIResponse.schema(
            "Fetch the gladiator's basis defence", APISchemaObject.string())
      };
    } else {
      return {
        "200": APIResponse.schema("Fetch all defences of a gladiator",
            APISchemaObject.array(ofSchema: APISchemaObject.string()))
      };
    }
  }
}
