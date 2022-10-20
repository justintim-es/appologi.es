import 'package:conduit/conduit.dart';
import 'package:appologi_es/appologi_es.dart';
import 'package:appologi_es/models/obstructionum.dart';
import 'package:appologi_es/models/utils.dart';
import 'package:collection/collection.dart';
import 'package:appologi_es/p2p.dart';
import '../models/exampla.dart';
import 'dart:convert';

class ObstructionumController extends ResourceController {
  Directory directory;
  P2P p2p;
  ObstructionumController(this.directory, this.p2p);

  @Operation.post()
  Future<Response> obstructionum(
      @Bind.body() ObstructionumNumerus obstructionumNumerus) async {
    try {
      File file = File(directory.path +
          '/caudices_' +
          (obstructionumNumerus.numerus!.length - 1).toString() +
          '.txt');
      return Response.ok(json.decode(await Utils.fileAmnis(file).elementAt(
          obstructionumNumerus
              .numerus![obstructionumNumerus.numerus!.length - 1])));
    } catch (err) {
      return Response.notFound(body: {
        "code": 0,
        "message": "angustos non inveni",
        "english": "block not found"
      });
    }
  }

  @Operation.get()
  Future<Response> prior() async {
    Obstructionum obs = await Utils.priorObstructionum(directory);
    return Response.ok(obs.toJson());
  }

  @Operation.get('probationem')
  Future<Response> probationemGenerare(
      @Bind.path('probationem') String probationem) async {
    Obstructionum obs =
        await Utils.accipereObstructionumProbationem(probationem, directory);
    return Response.ok(
        {"generare": obs.interioreObstructionum.generare.name.toString()});
  }

  @Operation.delete()
  Future<Response> furcaUnumRetro() async {
    Obstructionum obs = await Utils.priorObstructionum(directory);
    await Utils.removeObstructionumsUntilProbationem(directory);
    p2p.liberTxs = [];
    p2p.fixumTxs = [];
    return Response.ok({"message": "removed", "obstructionum": obs.toJson()});
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    if (operation.method == "POST" &&
        !operation.pathVariables.contains("probationem")) {
      return {
        "200": APIResponse.schema(
            "Fetched block by number",
            APISchemaObject.object({
              "probationem": APISchemaObject.string(),
              "interioreObstructionum": APISchemaObject.object({
                'generare': APISchemaObject.string(),
                'obstructionumDifficultas': APISchemaObject.integer(),
                'divisa': APISchemaObject.number(),
                'propterDifficultas': APISchemaObject.integer(),
                'liberDifficultas': APISchemaObject.integer(),
                'fixumDifficultas': APISchemaObject.integer(),
                'indicatione': APISchemaObject.number(),
                'nonce': APISchemaObject.integer(),
                'summaObstructionumDifficultas': APISchemaObject.integer(),
                'forumCap': APISchemaObject.integer(),
                'liberForumCap': APISchemaObject.integer(),
                'fixumForumCap': APISchemaObject.integer(),
                'obstructionumNumerus':
                    APISchemaObject.array(ofSchema: APISchemaObject.integer()),
                'defensio': APISchemaObject.string(),
                'producentis': APISchemaObject.string(),
                'priorProbationem': APISchemaObject.string(),
                'gladiator': APISchemaObject.object({
                  'input': APISchemaObject.object({
                    'index': APISchemaObject.integer(),
                    'signature': APISchemaObject.string(),
                    'gladiatorId': APISchemaObject.string()
                  }),
                  'outputs': APISchemaObject.object({
                    'index': APISchemaObject.integer(),
                    'signature': APISchemaObject.string(),
                    'gladiatorId': APISchemaObject.string(),
                  }),
                  'random': APISchemaObject.string(),
                  'id': APISchemaObject.string()
                }),
                'liberTransactions': APISchemaObject.array(
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
                })),
                'fixumTransactions': APISchemaObject.array(
                    ofSchema: APISchemaObject.object({
                  "probationem": APISchemaObject.string(),
                  "interioreTransaction": APISchemaObject.object({
                    'liber': APISchemaObject.boolean(),
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
                    })
                  })
                })),
                'expressiTransactions': APISchemaObject.array(
                    ofSchema: APISchemaObject.object({
                  "probationem": APISchemaObject.string(),
                  "interioreTransaction": APISchemaObject.object({
                    'liber': APISchemaObject.boolean(),
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
                    })
                  }),
                }))
              })
            }))
      };
    } else if (operation.method == "POST" &&
        operation.pathVariables.contains("probationem")) {
      return {
        "200": APIResponse.schema("Fetched block hashes",
            APISchemaObject.array(ofSchema: APISchemaObject.string()))
      };
    } else if (operation.method == "GET" &&
        !operation.pathVariables.contains("probationem")) {
      return {
        "200": APIResponse.schema(
            "Fetched block by number",
            APISchemaObject.object({
              "probationem": APISchemaObject.string(),
              "interioreObstructionum": APISchemaObject.object({
                'generare': APISchemaObject.string(),
                'obstructionumDifficultas': APISchemaObject.integer(),
                'divisa': APISchemaObject.number(),
                'propterDifficultas': APISchemaObject.integer(),
                'liberDifficultas': APISchemaObject.integer(),
                'fixumDifficultas': APISchemaObject.integer(),
                'indicatione': APISchemaObject.number(),
                'nonce': APISchemaObject.integer(),
                'summaObstructionumDifficultas': APISchemaObject.integer(),
                'forumCap': APISchemaObject.integer(),
                'liberForumCap': APISchemaObject.integer(),
                'fixumForumCap': APISchemaObject.integer(),
                'obstructionumNumerus':
                    APISchemaObject.array(ofSchema: APISchemaObject.integer()),
                'defensio': APISchemaObject.string(),
                'producentis': APISchemaObject.string(),
                'priorProbationem': APISchemaObject.string(),
                'gladiator': APISchemaObject.object({
                  'input': APISchemaObject.object({
                    'index': APISchemaObject.integer(),
                    'signature': APISchemaObject.string(),
                    'gladiatorId': APISchemaObject.string()
                  }),
                  'outputs': APISchemaObject.object({
                    'index': APISchemaObject.integer(),
                    'signature': APISchemaObject.string(),
                    'gladiatorId': APISchemaObject.string(),
                  }),
                  'random': APISchemaObject.string(),
                  'id': APISchemaObject.string()
                }),
                'liberTransactions': APISchemaObject.array(
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
                })),
                'fixumTransactions': APISchemaObject.array(
                    ofSchema: APISchemaObject.object({
                  "probationem": APISchemaObject.string(),
                  "interioreTransaction": APISchemaObject.object({
                    'liber': APISchemaObject.boolean(),
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
                    })
                  })
                })),
                'expressiTransactions': APISchemaObject.array(
                    ofSchema: APISchemaObject.object({
                  "probationem": APISchemaObject.string(),
                  "interioreTransaction": APISchemaObject.object({
                    'liber': APISchemaObject.boolean(),
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
                    })
                  }),
                }))
              })
            }))
      };
    } else if (operation.method == "GET" &&
        operation.method.contains("probationem")) {
      return {
        "200": APIResponse.schema("Fetched the type of block",
            APISchemaObject.object({"generare": APISchemaObject.string()}))
      };
    } else {
      return {
        "200": APIResponse.schema(
            "Forked the chain with 1 block/Removed one block",
            APISchemaObject.object({
              "message": APISchemaObject.string(),
              "obstructionum": APISchemaObject.object({
                "probationem": APISchemaObject.string(),
                "interioreObstructionum": APISchemaObject.object({
                  'generare': APISchemaObject.string(),
                  'obstructionumDifficultas': APISchemaObject.integer(),
                  'divisa': APISchemaObject.number(),
                  'propterDifficultas': APISchemaObject.integer(),
                  'liberDifficultas': APISchemaObject.integer(),
                  'fixumDifficultas': APISchemaObject.integer(),
                  'indicatione': APISchemaObject.number(),
                  'nonce': APISchemaObject.integer(),
                  'summaObstructionumDifficultas': APISchemaObject.integer(),
                  'forumCap': APISchemaObject.integer(),
                  'liberForumCap': APISchemaObject.integer(),
                  'fixumForumCap': APISchemaObject.integer(),
                  'obstructionumNumerus': APISchemaObject.array(
                      ofSchema: APISchemaObject.integer()),
                  'defensio': APISchemaObject.string(),
                  'producentis': APISchemaObject.string(),
                  'priorProbationem': APISchemaObject.string(),
                  'gladiator': APISchemaObject.object({
                    'input': APISchemaObject.object({
                      'index': APISchemaObject.integer(),
                      'signature': APISchemaObject.string(),
                      'gladiatorId': APISchemaObject.string()
                    }),
                    'outputs': APISchemaObject.object({
                      'index': APISchemaObject.integer(),
                      'signature': APISchemaObject.string(),
                      'gladiatorId': APISchemaObject.string(),
                    }),
                    'random': APISchemaObject.string(),
                    'id': APISchemaObject.string()
                  }),
                  'liberTransactions': APISchemaObject.array(
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
                  })),
                  'fixumTransactions': APISchemaObject.array(
                      ofSchema: APISchemaObject.object({
                    "probationem": APISchemaObject.string(),
                    "interioreTransaction": APISchemaObject.object({
                      'liber': APISchemaObject.boolean(),
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
                      })
                    })
                  })),
                  'expressiTransactions': APISchemaObject.array(
                      ofSchema: APISchemaObject.object({
                    "probationem": APISchemaObject.string(),
                    "interioreTransaction": APISchemaObject.object({
                      'liber': APISchemaObject.boolean(),
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
                      })
                    }),
                  }))
                })
              }),
            }))
      };
    }
  }

  @override
  void documentComponents(APIDocumentContext context) {
    super.documentComponents(context);

    final personSchema = ObstructionumNumerus().documentSchema(context);
    context.schema.register("ObstructionumNumerus", personSchema,
        representation: ObstructionumNumerus);
  }
}
