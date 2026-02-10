import 'package:equatable/equatable.dart';

class LegalVersion extends Equatable {
  final String content;
  final DateTime archivedAt;
  final int version;

  const LegalVersion({
    required this.content,
    required this.archivedAt,
    required this.version,
  });

  @override
  List<Object?> get props => [content, archivedAt, version];
}
