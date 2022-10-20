import 'package:conduit/conduit.dart';
import 'package:appologi_es/p2p.dart';
import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_open_api/v3.dart';

import 'package:conduit/conduit.dart';

class NetworkController extends ResourceController {
  P2P p2p;
  NetworkController(this.p2p);
  @Operation.get()
  Future<Response> peers() async {
    return Response.ok(p2p.sockets);
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    return {
      "200": APIResponse.schema("Fetched connected peers",
          APISchemaObject.array(ofSchema: APISchemaObject.string()))
    };
  }
}
