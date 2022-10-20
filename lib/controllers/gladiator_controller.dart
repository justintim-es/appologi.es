import 'package:conduit/conduit.dart';
import 'package:appologi_es/models/exampla.dart';
import 'package:appologi_es/models/gladiator.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:appologi_es/models/pera.dart';
import 'package:tuple/tuple.dart';
import 'dart:io';
import 'package:conduit_open_api/v3.dart';
import 'package:conduit_common/conduit_common.dart';

class GladiatorsController extends ResourceController {
  Directory directory;
  GladiatorsController(this.directory);
  @Operation.get()
  Future<Response> gladiator() async {
    List<Tuple3<String, GladiatorOutput, int>> gladiatores =
        await Obstructionum.invictosGladiatores(directory);
    final List<InvictosGladiator> invictos = [];
    for (Tuple3<String, GladiatorOutput, int> gladiator in gladiatores) {
      invictos.add(
          InvictosGladiator(gladiator.item1, gladiator.item2, gladiator.item3));
    }
    return Response.ok(invictos.map((e) => e.toJson()).toList());
  }

  @Operation.get('publica')
  Future<Response> defenditur(@Bind.path('publica') String publica) async {
    if (!await Pera.isPublicaClavisDefended(publica, directory)) {
      return Response.ok(
          {"defenditur": true, "message": "publica clavis defenditur"});
    } else {
      return Response.ok(
          {"defenditur": false, "message": "publica clavis non defenditur"});
    }
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    if (!operation.pathVariables.contains("publica")) {
      return {
        "200": APIResponse.schema(
            "Fetched undefeaten gladiators",
            APISchemaObject.array(
                ofSchema: APISchemaObject.object({
              "id": APISchemaObject.string(),
              "output": APISchemaObject.object({
                "defensio": APISchemaObject.string(),
                "rationem": APISchemaObject.array(
                    ofSchema: APISchemaObject.object({
                  "probationem": APISchemaObject.string(),
                  "interioreRationem": APISchemaObject.object({
                    "publicaClavis": APISchemaObject.string(),
                    "nonce": APISchemaObject.integer(),
                    "id": APISchemaObject.string()
                  })
                }))
              })
            })))
      };
    } else {
      return {
        "200": APIResponse.schema(
            "Fetch gladiator's status",
            APISchemaObject.object({
              "defenditur": APISchemaObject.boolean(),
              "message": APISchemaObject.string()
            }))
      };
    }
  }
}
