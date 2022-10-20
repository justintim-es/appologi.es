import 'package:conduit/conduit.dart';

class Answer extends Serializable {
  String? prior;
  String? novus;
  String? hash;
  String? probationem;
  int? index;
  Answer();

  @override
  Map<String, dynamic> asMap() => {
        'prior': prior,
        'novus': novus,
        'hash': hash,
        'probationem': probationem,
        'index': index
      };

  @override
  void readFromMap(Map<String, dynamic> object) {
    prior = object['prior'].toString();
    novus = object['novus'].toString();
    hash = object['hash'].toString();
    probationem = object['probationem'].toString();
    index = int.parse(object['index'].toString());
  }
}
