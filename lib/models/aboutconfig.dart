import 'package:appologi_es/appologi_es.dart';

class Aboutconfig extends Configuration {
  Aboutconfig(String fileNomen) : super.fromFile(File(fileNomen));
  String? p2pPortus;
  String? publicaClavis;
  String? internumIp;
  String? externalIp;
  bool? novus;
  String? directory;
  int? maxPares;
  String? bootnode;
  List<String>? cors;
}
