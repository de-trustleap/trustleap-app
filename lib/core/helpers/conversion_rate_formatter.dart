class ConversionRateFormatter {
  static String format({required int total, required int successful}) {
    if (total > 0) {
      final percentage = successful / total * 100;
      if (percentage == percentage.roundToDouble()) {
        return '${percentage.toStringAsFixed(0)}%';
      }
      return '${percentage.toStringAsFixed(1)}%';
    }
    return '0%';
  }
}
