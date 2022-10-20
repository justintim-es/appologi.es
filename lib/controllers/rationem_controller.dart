import 'dart:convert';
import 'dart:isolate';

import 'package:conduit/conduit.dart';
import 'package:appologi_es/models/constantes.dart';
import 'package:appologi_es/models/exampla.dart';
import 'package:appologi_es/models/gladiator.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:appologi_es/models/pera.dart';
import 'package:appologi_es/models/utils.dart';
import 'dart:io';
import 'package:appologi_es/p2p.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:conduit_common/conduit_common.dart';

class RationemController extends ResourceController {
  Directory directory;
  P2P p2p;
  Map<String, Isolate> propterIsolates;
  RationemController(this.directory, this.p2p, this.propterIsolates);
  @Operation.post()
  Future<Response> submittere(
      @Bind.body() SubmittereRationem submittereRationem) async {
    if (await Pera.isPublicaClavisDefended(
        submittereRationem.publicaClavis!, directory)) {
      return Response.badRequest(body: {
        "message": "Publica clavis iam defendi",
        "english": "Public key  already defended"
      });
    }
    for (Propter prop in p2p.propters) {
      if (prop.interioreRationem.publicaClavis ==
          submittereRationem.publicaClavis) {
        return Response.forbidden(body: {
          "message": "publica clavem iam in piscinam",
          "english": "Public key is already in pool"
        });
      }
    }
    ReceivePort acciperePortus = ReceivePort();
    InterioreRationem interioreRationem =
        InterioreRationem(submittereRationem.publicaClavis!, BigInt.zero);
    propterIsolates[interioreRationem.id] = await Isolate.spawn(
        Propter.quaestum,
        List<dynamic>.from([interioreRationem, acciperePortus.sendPort]));
    acciperePortus.listen((propter) {
      print('listentriggeredrationem');
      p2p.syncPropter(propter as Propter);
    });
    return Response.ok({"propterIdentitatis": interioreRationem.id});
  }

  @Operation.get('identitatis')
  Future<Response> rationem(
      @Bind.path('identitatis') String identitatis) async {
    List<Obstructionum> obs = [];
    for (int i = 0; i < directory.listSync().length; i++) {
      await for (String obstructionum in Utils.fileAmnis(
          File('${directory.path}${Constantes.fileNomen}$i.txt'))) {
        obs.add(Obstructionum.fromJson(
            json.decode(obstructionum) as Map<String, dynamic>));
      }
    }
    for (InterioreObstructionum interiore
        in obs.map((o) => o.interioreObstructionum)) {
      List<GladiatorOutput> outputs = [];
      for (int i = 0; i < interiore.gladiator.outputs.length; i++) {
        for (Propter propter in interiore.gladiator.outputs[i].rationem) {
          if (propter.interioreRationem.id == identitatis) {
            PropterInfo propterInfo = PropterInfo(
                true,
                i,
                interiore.indicatione,
                interiore.obstructionumNumerus,
                interiore.gladiator.outputs[i].defensio);
            return Response.ok({
              "data": propterInfo.toJson(),
              "scriptum": interiore.gladiator.toJson(),
              "gladiatorId": interiore.gladiator.id
            });
          }
        }
      }
    }
    for (Propter propter in p2p.propters) {
      if (propter.interioreRationem.id == identitatis) {
        PropterInfo propterInfo = PropterInfo(false, 0, null, null, null);
        return Response.ok({
          "data": propterInfo.toJson(),
          "scriptum": propter.toJson(),
          "gladiatorId": null
        });
      }
    }
    return Response.badRequest(
        body: {"code": 0, "message": "Propter not found"});
  }

  @Operation.get()
  Future<Response> novusPropter() async {
    KeyPair kp = KeyPair();
    return Response.ok(
        {"publicaClavis": kp.public, "privatusClavis": kp.private});
  }

  @override
  void documentComponents(APIDocumentContext context) {
    super.documentComponents(context);

    final submittereRationemSchema =
        SubmittereRationem().documentSchema(context);
    context.schema.register("SubmittereRationem", submittereRationemSchema,
        representation: SubmittereRationem);
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    if (operation.method == "POST") {
      return {
        "200": APIResponse.schema(
            "Fetched a public key to be defended",
            APISchemaObject.object(
                {"propterIdentitatis": APISchemaObject.string()}))
      };
    } else if (operation.pathVariables.contains("identitatis")) {
      return {
        "200": APIResponse.schema(
            "Fetched account info",
            APISchemaObject.object({
              "data": APISchemaObject.object({
                'includi': APISchemaObject.boolean(),
                'index': APISchemaObject.integer(),
                'indicatione': APISchemaObject.integer(),
                'obstructionumNumerus':
                    APISchemaObject.array(ofSchema: APISchemaObject.integer()),
                'defensio': APISchemaObject.string(),
              }),
              "scriptum": APISchemaObject.object({
                "id": APISchemaObject.string(),
                "random": APISchemaObject.string(),
                "input": APISchemaObject.object({
                  "gladiatorId": APISchemaObject.string(),
                  "signature": APISchemaObject.string(),
                  "index": APISchemaObject.integer()
                }),
                "outputs": APISchemaObject.array(
                    ofSchema: APISchemaObject.object({
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
                }))
              }),
              "gladiatorId": APISchemaObject.string(),
            })),
        "400": APIResponse.schema(
            "Account not found",
            APISchemaObject.object({
              "code": APISchemaObject.integer(),
              "message": APISchemaObject.string()
            }))
      };
    } else {
      return {
        "200": APIResponse.schema("Fetch all defences of a gladiator",
            APISchemaObject.array(ofSchema: APISchemaObject.string()))
      };
    }
  }
}
