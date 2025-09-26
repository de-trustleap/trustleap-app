// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum PagebuilderGradientType {
  linear,
  radial,
  sweep,
}

class PagebuilderGradientStop extends Equatable {
  final Color color;
  final double position;

  const PagebuilderGradientStop({
    required this.color,
    required this.position,
  });

  PagebuilderGradientStop copyWith({
    Color? color,
    double? position,
  }) {
    return PagebuilderGradientStop(
      color: color ?? this.color,
      position: position ?? this.position,
    );
  }

  PagebuilderGradientStop deepCopy() {
    return PagebuilderGradientStop(
      color: Color(color.toARGB32()),
      position: position,
    );
  }

  @override
  List<Object?> get props => [color, position];
}

class PagebuilderGradient extends Equatable {
  final PagebuilderGradientType type;
  final List<PagebuilderGradientStop> stops;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final AlignmentGeometry center;
  final double radius;
  final double startAngle;
  final double endAngle;

  const PagebuilderGradient({
    required this.type,
    required this.stops,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    this.center = Alignment.center,
    this.radius = 0.5,
    this.startAngle = 0.0,
    this.endAngle = 6.283185307179586, // 2 * pi
  });

  factory PagebuilderGradient.defaultLinear() {
    return const PagebuilderGradient(
      type: PagebuilderGradientType.linear,
      stops: [
        PagebuilderGradientStop(color: Colors.blue, position: 0.0),
        PagebuilderGradientStop(color: Colors.red, position: 1.0),
      ],
    );
  }

  factory PagebuilderGradient.defaultRadial() {
    return const PagebuilderGradient(
      type: PagebuilderGradientType.radial,
      stops: [
        PagebuilderGradientStop(color: Colors.blue, position: 0.0),
        PagebuilderGradientStop(color: Colors.red, position: 1.0),
      ],
    );
  }

  factory PagebuilderGradient.defaultSweep() {
    return const PagebuilderGradient(
      type: PagebuilderGradientType.sweep,
      stops: [
        PagebuilderGradientStop(color: Colors.blue, position: 0.0),
        PagebuilderGradientStop(color: Colors.red, position: 1.0),
      ],
    );
  }

  Gradient toFlutterGradient() {
    final colors = stops.map((stop) => stop.color).toList();
    final positions = stops.map((stop) => stop.position).toList();

    switch (type) {
      case PagebuilderGradientType.linear:
        return LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
          stops: positions,
        );
      case PagebuilderGradientType.radial:
        return RadialGradient(
          center: center,
          radius: radius,
          colors: colors,
          stops: positions,
        );
      case PagebuilderGradientType.sweep:
        return SweepGradient(
          center: center,
          startAngle: startAngle,
          endAngle: endAngle,
          colors: colors,
          stops: positions,
        );
    }
  }

  PagebuilderGradient copyWith({
    PagebuilderGradientType? type,
    List<PagebuilderGradientStop>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    AlignmentGeometry? center,
    double? radius,
    double? startAngle,
    double? endAngle,
  }) {
    return PagebuilderGradient(
      type: type ?? this.type,
      stops: stops ?? this.stops,
      begin: begin ?? this.begin,
      end: end ?? this.end,
      center: center ?? this.center,
      radius: radius ?? this.radius,
      startAngle: startAngle ?? this.startAngle,
      endAngle: endAngle ?? this.endAngle,
    );
  }

  PagebuilderGradient deepCopy() {
    return PagebuilderGradient(
      type: type,
      stops: stops.map((stop) => stop.deepCopy()).toList(),
      begin: begin,
      end: end,
      center: center,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
    );
  }

  @override
  List<Object?> get props => [
        type,
        stops,
        begin,
        end,
        center,
        radius,
        startAngle,
        endAngle,
      ];
}