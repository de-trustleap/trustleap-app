import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/last_edit.dart';

class LastEditModel extends Equatable {
  final String fieldName;
  final String editedBy;
  final DateTime editedAt;

  const LastEditModel({
    required this.fieldName,
    required this.editedBy,
    required this.editedAt,
  });

  LastEditModel copyWith({
    String? fieldName,
    String? editedBy,
    DateTime? editedAt,
  }) {
    return LastEditModel(
      fieldName: fieldName ?? this.fieldName,
      editedBy: editedBy ?? this.editedBy,
      editedAt: editedAt ?? this.editedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "fieldName": fieldName,
      "editedBy": editedBy,
      "editedAt": editedAt.toIso8601String(),
    };
  }

  factory LastEditModel.fromMap(Map<String, dynamic> map) {
    return LastEditModel(
      fieldName: map['fieldName'] as String,
      editedBy: map['editedBy'] as String,
      editedAt: DateTime.parse(map['editedAt'] as String),
    );
  }

  LastEdit toDomain() {
    return LastEdit(
      fieldName: fieldName,
      editedBy: editedBy,
      editedAt: editedAt,
    );
  }

  factory LastEditModel.fromDomain(LastEdit lastEdit) {
    return LastEditModel(
      fieldName: lastEdit.fieldName,
      editedBy: lastEdit.editedBy,
      editedAt: lastEdit.editedAt,
    );
  }

  @override
  List<Object?> get props => [fieldName, editedBy, editedAt];
}
