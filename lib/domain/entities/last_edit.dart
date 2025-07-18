import 'package:equatable/equatable.dart';

class LastEdit extends Equatable {
  final String fieldName;
  final String editedBy;
  final DateTime editedAt;
  
  const LastEdit({
    required this.fieldName,
    required this.editedBy,
    required this.editedAt,
  });
  
  LastEdit copyWith({
    String? fieldName,
    String? editedBy,
    DateTime? editedAt,
  }) {
    return LastEdit(
      fieldName: fieldName ?? this.fieldName,
      editedBy: editedBy ?? this.editedBy,
      editedAt: editedAt ?? this.editedAt,
    );
  }
  
  @override
  List<Object?> get props => [fieldName, editedBy, editedAt];
}