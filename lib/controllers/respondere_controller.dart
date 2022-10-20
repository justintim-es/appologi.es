import 'package:conduit/conduit.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class RespondereController extends ResourceController {
  @Operation.get('answer')
  Future<Response> encrypt(@Bind.path('answer') String answer) async {
    return Response.ok("");
  }
}
