import 'package:conduit/conduit.dart';
import 'package:appologi_es/p2p.dart';

class ScansController extends ResourceController {
  P2P p2p;
  ScansController(this.p2p);
  @Operation.get()
  Future<Response> pool() async {
    return Response.ok(p2p.scans);
  }
}
