// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';

class PagebuilderResponsiveOrConstantModel<T> extends Equatable {
  final T? constantValue;
  final Map<String, T>? responsiveValue;

  const PagebuilderResponsiveOrConstantModel.constant(this.constantValue)
      : responsiveValue = null;

  const PagebuilderResponsiveOrConstantModel.responsive(this.responsiveValue)
      : constantValue = null;

  Object? toMapValue() {
    if (constantValue != null) return constantValue;
    return responsiveValue;
  }

  static PagebuilderResponsiveOrConstantModel<T>? fromMapValue<T>(
    Object? value,
    T Function(dynamic) converter,
  ) {
    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      return PagebuilderResponsiveOrConstantModel.responsive({
        if (value["mobile"] != null) "mobile": converter(value["mobile"]),
        if (value["tablet"] != null) "tablet": converter(value["tablet"]),
        if (value["desktop"] != null) "desktop": converter(value["desktop"]),
      });
    } else {
      return PagebuilderResponsiveOrConstantModel.constant(converter(value));
    }
  }

  PagebuilderResponsiveOrConstant<T> toDomain() {
    if (constantValue != null) {
      return PagebuilderResponsiveOrConstant.constant(constantValue);
    }
    return PagebuilderResponsiveOrConstant.responsive(responsiveValue);
  }

  static PagebuilderResponsiveOrConstantModel<T>? fromDomain<T>(
    PagebuilderResponsiveOrConstant<T>? value,
  ) {
    if (value == null) return null;
    if (value.constantValue != null) {
      return PagebuilderResponsiveOrConstantModel.constant(value.constantValue);
    }
    return PagebuilderResponsiveOrConstantModel.responsive(
        value.responsiveValue);
  }

  @override
  List<Object?> get props => [constantValue, responsiveValue];
}
