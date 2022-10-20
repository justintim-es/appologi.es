import 'package:conduit/conduit.dart';
import 'dart:io';
import 'dart:isolate';
import 'package:conduit/conduit.dart';
import 'package:elliptic/elliptic.dart';
import 'package:appologi_es/models/exampla.dart';
import 'package:appologi_es/models/pera.dart';
import 'package:appologi_es/models/transaction.dart';
import 'package:appologi_es/p2p.dart';
import 'package:appologi_es/models/errors.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:conduit_common/conduit_common.dart';

class TransactionLiberController extends ResourceController {
  Directory directory;
  P2P p2p;
  Map<String, Isolate> liberTxIsolates;
  TransactionLiberController(this.directory, this.p2p, this.liberTxIsolates);

  @Operation.post()
  Future<Response> submittereLiberTransaction(
      @Bind.body() SubmittereTransaction unCalcTx) async {
    try {
      if (unCalcTx.nof == BigInt.zero) {
        return Response.badRequest(body: {
          "code": 0,
          "message": "non potest mittere 0",
          "english": "can not send 0"
        });
      }
      PrivateKey pk = PrivateKey.fromHex(Pera.curve(), unCalcTx.from!);
      if (pk.publicKey.toHex() == unCalcTx.to) {
        return Response.badRequest(
            body: Error(
                    code: 2,
                    message: "potest mittere pecuniam publicam clavem",
                    english: "can not send money to the same public key")
                .toJson());
      }
      if (!await Pera.isPublicaClavisDefended(unCalcTx.to!, directory) &&
          !await Pera.isProbationum(unCalcTx.to!, directory)) {
        return Response.badRequest(
            body: Error(
                    code: 0,
                    message: "accipientis non defenditur",
                    english: "public key is not defended")
                .toJson());
      }
      final InterioreTransaction tx = await Pera.novamRem(
          true,
          true,
          unCalcTx.from!,
          unCalcTx.nof!,
          unCalcTx.to!,
          p2p.liberTxs,
          directory,
          null);
      p2p.liberTxs.add(Transaction.expressi(tx));
      p2p.expressieTxs.add(Transaction.expressi(await Pera.novamRem(
          true,
          false,
          unCalcTx.from!,
          unCalcTx.nof!,
          unCalcTx.to!,
          p2p.liberTxs,
          directory,
          tx.id)));
      ReceivePort acciperePortus = ReceivePort();
      liberTxIsolates[tx.id] = await Isolate.spawn(Transaction.quaestum,
          List<dynamic>.from([tx, acciperePortus.sendPort]));
      acciperePortus.listen((transaction) {
        p2p.syncLiberTx(transaction as Transaction);
      });
      return Response.ok({"transactionIdentitatis": tx.id});
    } on Error catch (err) {
      return Response.badRequest(body: err.toJson());
    }
  }

  @Operation.get()
  Future<Response> liberTransactionStagnum() async {
    return Response.ok(p2p.liberTxs.map((e) => e.toJson()).toList());
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    if (operation.method == "POST") {
      return {
        "200": APIResponse.schema(
            "Fetched transaction to free transaction pool",
            APISchemaObject.object({
              "transactionIdentitatis": APISchemaObject.string(),
            })),
        "400": APIResponse.schema(
            "Failed to fetch fixum transaction",
            APISchemaObject.object({
              "code": APISchemaObject.integer(),
              "message": APISchemaObject.string(),
              "english": APISchemaObject.string()
            }))
      };
    } else {
      return {
        "200": APIResponse.schema(
            "Fetched free transaction pool",
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

  @override
  void documentComponents(APIDocumentContext context) {
    super.documentComponents(context);

    final submittereTransactionSchema =
        SubmittereTransaction().documentSchema(context);
    context.schema.register(
        "SubmittereTransaction", submittereTransactionSchema,
        representation: SubmittereTransaction);
  }
}
