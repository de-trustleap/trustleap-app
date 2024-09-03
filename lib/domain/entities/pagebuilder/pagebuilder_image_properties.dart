// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PageBuilderImageProperties extends Equatable implements PageBuilderProperties {
  final String? url;
  final double? borderRadius;

  const PageBuilderImageProperties({
    required this.url,
    required this.borderRadius,
  });

  PageBuilderImageProperties copyWith({
    String? url,
    double? borderRadius,
  }) {
    return PageBuilderImageProperties(
      url: url ?? this.url,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
  
  @override
  List<Object?> get props => [url, borderRadius];
}
