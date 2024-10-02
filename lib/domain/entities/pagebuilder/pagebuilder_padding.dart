class PageBuilderPadding {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  PageBuilderPadding({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  factory PageBuilderPadding.fromMap(Map<String, dynamic>? map) {
    final paddingTop = map?['top'] != null ? map!['top'] as double : 0.0;
    final paddingBottom =
        map?['bottom'] != null ? map!['bottom'] as double : 0.0;
    final paddingLeft = map?['left'] != null ? map!['left'] as double : 0.0;
    final paddingRight = map?['right'] != null ? map!['right'] as double : 0.0;

    return PageBuilderPadding(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight);
  }
}
