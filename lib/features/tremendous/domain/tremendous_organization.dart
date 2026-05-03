import 'package:equatable/equatable.dart';

class TremendousOrganization extends Equatable {
  final String id;
  final String name;

  const TremendousOrganization({required this.id, required this.name});

  factory TremendousOrganization.fromMap(Map<String, dynamic> map) =>
      TremendousOrganization(
        id: map['id'] as String,
        name: map['name'] as String,
      );

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}
