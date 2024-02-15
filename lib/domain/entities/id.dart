import 'package:uuid/uuid.dart';

class UniqueID {
  final String value;

  const UniqueID._(this.value);

  factory UniqueID() {
    return UniqueID._(const Uuid().v1());
  }

  factory UniqueID.fromUniqueString(String uniqueID) {
    return UniqueID._(uniqueID);
  }
}
