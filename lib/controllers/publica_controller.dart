import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:nofiftyone/p2p.dart';

class PublicaController extends ResourceController {
  Directory directory;
  P2P p2p;
  PublicaController(this.directory, this.p2p);
  @Operation.post('privatus')
  Future<Response> submittere(@Bind.path('privatus') String privatus) async {
    return Response.ok("");
  }
}
