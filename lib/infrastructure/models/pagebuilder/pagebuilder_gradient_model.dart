// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/helpers/color_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_gradient.dart';
import 'package:flutter/material.dart';

class PagebuilderGradientStopModel extends Equatable {
  final String color;
  final double position;

  const PagebuilderGradientStopModel({
    required this.color,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return {
      "color": color,
      "position": position,
    };
  }

  factory PagebuilderGradientStopModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderGradientStopModel(
      color: map["color"] as String,
      position: (map["position"] as num).toDouble(),
    );
  }

  PagebuilderGradientStopModel copyWith({
    String? color,
    double? position,
  }) {
    return PagebuilderGradientStopModel(
      color: color ?? this.color,
      position: position ?? this.position,
    );
  }

  PagebuilderGradientStop toDomain(PageBuilderGlobalStyles? globalStyles) {
    Color resolvedColor;
    String? token;

    // Check if color is a token (starts with @)
    if (color.startsWith('@')) {
      // Store the token AND resolve it
      token = color;
      final tokenColor = globalStyles?.resolveColorReference(color);
      resolvedColor = tokenColor ?? Colors.transparent;
    } else {
      // Direct hex color - no token
      resolvedColor = Color(ColorUtility.getHexIntFromString(color));
      token = null;
    }

    return PagebuilderGradientStop(
      color: resolvedColor,
      position: position,
      globalColorToken: token,
    );
  }

  factory PagebuilderGradientStopModel.fromDomain(PagebuilderGradientStop stop) {
    // If there's a token, use it; otherwise convert color to hex
    final colorValue = stop.globalColorToken ?? ColorUtility.colorToHex(stop.color);
    return PagebuilderGradientStopModel(
      color: colorValue,
      position: stop.position,
    );
  }

  @override
  List<Object?> get props => [color, position];
}

class PagebuilderGradientModel extends Equatable {
  final String type;
  final List<Map<String, dynamic>> stops;
  final Map<String, dynamic> begin;
  final Map<String, dynamic> end;
  final Map<String, dynamic> center;
  final double radius;
  final double startAngle;
  final double endAngle;

  const PagebuilderGradientModel({
    required this.type,
    required this.stops,
    required this.begin,
    required this.end,
    required this.center,
    required this.radius,
    required this.startAngle,
    required this.endAngle,
  });

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "stops": stops,
      "begin": begin,
      "end": end,
      "center": center,
      "radius": radius,
      "startAngle": startAngle,
      "endAngle": endAngle,
    };
  }

  factory PagebuilderGradientModel.fromMap(Map<String, dynamic> map) {
    return PagebuilderGradientModel(
      type: map["type"] as String,
      stops: List<Map<String, dynamic>>.from(map["stops"]),
      begin: Map<String, dynamic>.from(map["begin"]),
      end: Map<String, dynamic>.from(map["end"]),
      center: Map<String, dynamic>.from(map["center"]),
      radius: (map["radius"] as num).toDouble(),
      startAngle: (map["startAngle"] as num).toDouble(),
      endAngle: (map["endAngle"] as num).toDouble(),
    );
  }

  PagebuilderGradientModel copyWith({
    String? type,
    List<Map<String, dynamic>>? stops,
    Map<String, dynamic>? begin,
    Map<String, dynamic>? end,
    Map<String, dynamic>? center,
    double? radius,
    double? startAngle,
    double? endAngle,
  }) {
    return PagebuilderGradientModel(
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

  PagebuilderGradient toDomain(PageBuilderGlobalStyles? globalStyles) {
    PagebuilderGradientType gradientType;
    switch (type) {
      case "linear":
        gradientType = PagebuilderGradientType.linear;
        break;
      case "radial":
        gradientType = PagebuilderGradientType.radial;
        break;
      case "sweep":
        gradientType = PagebuilderGradientType.sweep;
        break;
      default:
        gradientType = PagebuilderGradientType.linear;
    }

    final domainStops = stops
        .map((stop) => PagebuilderGradientStopModel.fromMap(stop).toDomain(globalStyles))
        .toList();

    return PagebuilderGradient(
      type: gradientType,
      stops: domainStops,
      begin: _alignmentFromMap(begin),
      end: _alignmentFromMap(end),
      center: _alignmentFromMap(center),
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
    );
  }

  factory PagebuilderGradientModel.fromDomain(PagebuilderGradient gradient) {
    String typeString;
    switch (gradient.type) {
      case PagebuilderGradientType.linear:
        typeString = "linear";
        break;
      case PagebuilderGradientType.radial:
        typeString = "radial";
        break;
      case PagebuilderGradientType.sweep:
        typeString = "sweep";
        break;
    }

    final modelStops = gradient.stops
        .map((stop) => PagebuilderGradientStopModel.fromDomain(stop).toMap())
        .toList();

    return PagebuilderGradientModel(
      type: typeString,
      stops: modelStops,
      begin: _alignmentToMap(gradient.begin),
      end: _alignmentToMap(gradient.end),
      center: _alignmentToMap(gradient.center),
      radius: gradient.radius,
      startAngle: gradient.startAngle,
      endAngle: gradient.endAngle,
    );
  }

  static AlignmentGeometry _alignmentFromMap(Map<String, dynamic> map) {
    final x = (map["x"] as num).toDouble();
    final y = (map["y"] as num).toDouble();
    return Alignment(x, y);
  }

  static Map<String, dynamic> _alignmentToMap(AlignmentGeometry alignment) {
    if (alignment is Alignment) {
      return {"x": alignment.x, "y": alignment.y};
    }
    return {"x": 0.0, "y": 0.0};
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