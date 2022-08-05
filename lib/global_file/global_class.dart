// PACKAGE
import 'global_enumerator.dart';



// GLOBAL CLASS
class GEventClass {

  // CONSTRUCTOR
  GEventClass ();

  // INSTANCE
  GEventClass.fromMap (int length, Map <String, dynamic> map) {
    date = DateTime.fromMillisecondsSinceEpoch (map ['date'] as int);
    id = map ['id'] as String;
    index = length;
    type = _setType (map ['type'] as String);
  }

  GEventClass.local (DateTime dateTime, GEventEnumerator gEventEnumerator) {
    date = dateTime;
    type = gEventEnumerator;
  }

  // METHOD
  GEventEnumerator _setType (String type) {
    switch (type) {
      case 'sleeping':
        return GEventEnumerator.sleeping;

      case 'waking':
        return GEventEnumerator.waking;

      default:
        return GEventEnumerator.other;
    }
  }

  // PROPERTY
  DateTime date = DateTime.now ();
  GEventEnumerator type = GEventEnumerator.other;
  int index = -1;
  String id = '';
}
