import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class UniqueID extends Equatable {
  final String value;

  const UniqueID._(this.value);

  factory UniqueID() {
    return UniqueID._(const Uuid().v1());
  }

  factory UniqueID.fromUniqueString(String uniqueID) {
    return UniqueID._(uniqueID);
  }
  
  @override
  List<Object?> get props => [value];
}
