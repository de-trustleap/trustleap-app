import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/consent_preference.dart';

class ConsentPreferenceModel extends Equatable {
  final List<String> categories;
  final String method;
  final String policyVersion;
  final dynamic timestamp;

  const ConsentPreferenceModel({
    required this.categories,
    required this.method,
    required this.policyVersion,
    required this.timestamp,
  });

  ConsentPreferenceModel copyWith({
    List<String>? categories,
    String? method,
    String? policyVersion,
    dynamic timestamp,
  }) {
    return ConsentPreferenceModel(
      categories: categories ?? this.categories,
      method: method ?? this.method,
      policyVersion: policyVersion ?? this.policyVersion,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Map for localStorage (JSON-serializable)
  Map<String, dynamic> toStorageMap() {
    return {
      'categories': categories,
      'method': method,
      'policyVersion': policyVersion,
      'timestamp': timestamp,
    };
  }

  /// Map for Firestore (with FieldValue.serverTimestamp)
  Map<String, dynamic> toFirestoreMap() {
    return {
      'categories': categories,
      'method': method,
      'policyVersion': policyVersion,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  factory ConsentPreferenceModel.fromMap(Map<String, dynamic> map) {
    return ConsentPreferenceModel(
      categories:
          (map['categories'] as List<dynamic>).whereType<String>().toList(),
      method: map['method'] as String,
      policyVersion: map['policyVersion'] as String,
      timestamp: map['timestamp'] as dynamic,
    );
  }

  factory ConsentPreferenceModel.fromFirestore(Map<String, dynamic> doc) {
    return ConsentPreferenceModel.fromMap(doc);
  }

  ConsentPreference toDomain() {
    DateTime parsedTimestamp;
    if (timestamp is Timestamp) {
      parsedTimestamp = (timestamp as Timestamp).toDate();
    } else if (timestamp is String) {
      try {
        parsedTimestamp = DateTime.parse(timestamp);
      } catch (e) {
        parsedTimestamp = DateTime.now();
      }
    } else if (timestamp is int) {
      parsedTimestamp = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      parsedTimestamp = DateTime.now();
    }

    return ConsentPreference(
      categories: categories
          .map((name) => ConsentCategory.values.firstWhere(
              (c) => c.name == name,
              orElse: () => ConsentCategory.necessary))
          .toSet(),
      method: ConsentMethod.values.firstWhere(
        (m) => m.name == method,
        orElse: () => ConsentMethod.custom,
      ),
      policyVersion: policyVersion,
      timestamp: parsedTimestamp,
    );
  }

  factory ConsentPreferenceModel.fromDomain(ConsentPreference consent) {
    return ConsentPreferenceModel(
      categories: consent.categories.map((c) => c.name).toList(),
      method: consent.method.name,
      policyVersion: consent.policyVersion,
      timestamp: consent.timestamp.toIso8601String(),
    );
  }

  @override
  List<Object?> get props => [categories, method, policyVersion, timestamp];
}
