// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class AVV extends Equatable {
  final DateTime? approvedAt;
  final String? downloadURL;
  final String? path;

  const AVV({
    required this.approvedAt,
    required this.downloadURL,
    required this.path,
  });

  AVV copyWith({
    DateTime? approvedAt,
    String? downloadURL,
    String? path,
  }) {
    return AVV(
      approvedAt: approvedAt ?? this.approvedAt,
      downloadURL: downloadURL ?? this.downloadURL,
      path: path ?? this.path,
    );
  }

  @override
  List<Object?> get props => [approvedAt, downloadURL, path];
}
