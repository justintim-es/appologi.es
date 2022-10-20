import 'package:conduit/conduit.dart';
import 'package:appologi_es/p2p.dart';
import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_open_api/v3.dart';

class RationemStagnumController extends ResourceController {
  P2P p2p;
  RationemStagnumController(this.p2p);
  @Operation.get('rationem-stagnum')
  Future<Response> rationemStagnum() async {
    return Response.ok(p2p.propters);
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    return {
      "200": APIResponse.schema(
          "Fetched account pool",
          APISchemaObject.array(
              ofSchema: APISchemaObject.object({
            "probationem": APISchemaObject.string(),
            "interioreRationem": APISchemaObject.object({
              "publicaClavis": APISchemaObject.string(),
              "nonce": APISchemaObject.integer(),
              "id": APISchemaObject.string()
            })
          })))
    };
  }
}
