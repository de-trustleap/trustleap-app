import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_shadow.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/models/pagebuilder_shadow_model.dart';

class ShadowMapper {
  static Map<String, dynamic>? getMapFromShadow(PageBuilderShadow? shadow) {
    if (shadow == null) {
      return null;
    }
    final shadowModel = PageBuilderShadowModel.fromDomain(shadow);
    Map<String, dynamic> map = {};
    if (shadowModel.color != null) map['color'] = shadowModel.color;
    if (shadowModel.spreadRadius != null && shadowModel.spreadRadius != 0) {
      map['spreadRadius'] = shadowModel.spreadRadius;
    }
    if (shadowModel.blurRadius != null && shadowModel.blurRadius != 0) {
      map['blurRadius'] = shadowModel.blurRadius;
    }
    if (shadowModel.offset != null) map['offset'] = shadowModel.offset;
    if (map.isEmpty) {
      return null;
    } else {
      return map;
    }
  }
}