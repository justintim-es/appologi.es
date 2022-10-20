import 'package:conduit/conduit.dart';
import 'package:appologi_es/p2p.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:conduit_common/conduit_common.dart';

class TransactionExpressiController extends ResourceController {
  P2P p2p;
  TransactionExpressiController(this.p2p);

  @Operation.get('expressi-stagnum')
  Future<Response> expressiStagnum() async {
    return Response.ok(p2p.expressieTxs.map((e) => e.toJson()).toList());
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    return {
      "200": APIResponse.schema(
          "Fetched reproduce transaction pool",
          APISchemaObject.array(
              ofSchema: APISchemaObject.array(
                  ofSchema: APISchemaObject.object({
            "probationem": APISchemaObject.string(),
            "interioreTransaction": APISchemaObject.object({
              'liber': APISchemaObject.boolean(),
              'inputs': APISchemaObject.array(
                  ofSchema: APISchemaObject.object({
                'index': APISchemaObject.integer(),
                'signature': APISchemaObject.string(),
                'transactionId': APISchemaObject.string()
              })),
              'outputs': APISchemaObject.object({
                'publicKey': APISchemaObject.string(),
                'gla': APISchemaObject.string()
              }),
              'random': APISchemaObject.string(),
              'id': APISchemaObject.integer(),
              'nonce': APISchemaObject.string(),
              'expressi': APISchemaObject.string()
            })
          }))))
    };
  }
}
