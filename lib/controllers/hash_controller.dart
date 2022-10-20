import 'package:conduit/conduit.dart';
import 'package:crypto/crypto.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:hex/hex.dart';
import 'package:appologi_es/models/humanify.dart';
import 'dart:io';
import 'dart:convert';

class HashController extends ResourceController {
  @Operation.get('index', 'answer')
  Future<Response> answer(
      @Bind.path('index') int index, @Bind.path('answer') String answer) async {
    Password password = Password(index, answer);
    final crypted = HEX.encode(
        sha512.convert(utf8.encode(json.encode(password.toJson()))).bytes);
    return Response.ok(crypted);
  }
}
