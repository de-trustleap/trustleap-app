import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';

class ConsentPreference extends Equatable {
  final Set<ConsentCategory> categories;
  final ConsentMethod method;
  final String policyVersion;
  final DateTime timestamp;

  const ConsentPreference({
    required this.categories,
    required this.method,
    required this.policyVersion,
    required this.timestamp,
  });

  factory ConsentPreference.initial() {
    return ConsentPreference(
      categories: {ConsentCategory.necessary},
      method: ConsentMethod.rejectAll,
      policyVersion: '1.0',
      timestamp: DateTime.now(),
    );
  }

  factory ConsentPreference.acceptAll(String policyVersion) {
    return ConsentPreference(
      categories: ConsentCategory.values.toSet(),
      method: ConsentMethod.acceptAll,
      policyVersion: policyVersion,
      timestamp: DateTime.now(),
    );
  }

  factory ConsentPreference.rejectAll(String policyVersion) {
    return ConsentPreference(
      categories: {ConsentCategory.necessary},
      method: ConsentMethod.rejectAll,
      policyVersion: policyVersion,
      timestamp: DateTime.now(),
    );
  }

  bool hasConsent(ConsentCategory category) {
    if (category == ConsentCategory.necessary) {
      return true;
    }
    return categories.contains(category);
  }

  ConsentPreference copyWith({
    Set<ConsentCategory>? categories,
    ConsentMethod? method,
    String? policyVersion,
    DateTime? timestamp,
  }) {
    return ConsentPreference(
      categories: categories ?? this.categories,
      method: method ?? this.method,
      policyVersion: policyVersion ?? this.policyVersion,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [categories, method, policyVersion, timestamp];
}
