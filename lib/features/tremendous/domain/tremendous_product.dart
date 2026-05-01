import 'package:equatable/equatable.dart';

class TremendousProduct extends Equatable {
  final String id;
  final String name;
  final String category;
  final double? min;
  final double? max;
  final String? imageUrl;

  const TremendousProduct({
    required this.id,
    required this.name,
    required this.category,
    this.min,
    this.max,
    this.imageUrl,
  });

  factory TremendousProduct.fromMap(Map<String, dynamic> map) {
    final images = map['images'] as List<dynamic>?;
    return TremendousProduct(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String? ?? '',
      min: (map['min'] as num?)?.toDouble(),
      max: (map['max'] as num?)?.toDouble(),
      imageUrl: images != null && images.isNotEmpty
          ? (images.first as Map<String, dynamic>)['src'] as String?
          : null,
    );
  }

  @override
  List<Object?> get props => [id, name, category, min, max, imageUrl];
}
