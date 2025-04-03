import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/avv.dart';

class AVVModel extends Equatable {
  final DateTime? approvedAt;
  final String? downloadURL;
  final String? path;

  const AVVModel({
    required this.approvedAt,
    required this.downloadURL,
    required this.path,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'approvedAt': approvedAt,
      'downloadURL': downloadURL,
      'pdfPath': path,
    };
  }

  factory AVVModel.fromMap(Map<String, dynamic> map) {
    return AVVModel(
      approvedAt: map['approvedAt'] != null
          ? (map['approvedAt'] as Timestamp).toDate()
          : null,
      downloadURL:
          map['downloadURL'] != null ? map['downloadURL'] as String : null,
      path: map['pdfPath'] != null ? map['pdfPath'] as String : null,
    );
  }

  AVVModel copyWith({
    DateTime? approvedAt,
    String? downloadURL,
    String? path,
  }) {
    return AVVModel(
      approvedAt: approvedAt ?? this.approvedAt,
      downloadURL: downloadURL ?? this.downloadURL,
      path: path ?? this.path,
    );
  }

  AVV toDomain() {
    return AVV(approvedAt: approvedAt, downloadURL: downloadURL, path: path);
  }

  factory AVVModel.fromDomain(AVV avv) {
    return AVVModel(
        approvedAt: avv.approvedAt,
        downloadURL: avv.downloadURL,
        path: avv.path);
  }

  @override
  List<Object?> get props => [approvedAt, downloadURL, path];
}
