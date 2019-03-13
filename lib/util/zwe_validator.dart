class ZweValidator {
  static final _zweRegex = RegExp(r'\D');
  final int lowerBound;
  final int upperBound;
  ZweValidator({
    this.lowerBound = 0,
    this.upperBound = 240,
  });
  bool validate(String input) =>
      input.length > 0 &&
      !_zweRegex.hasMatch(input) &&
      (lowerBound != null && int.parse(input) >= lowerBound) &&
      (upperBound != null && int.parse(input) <= upperBound);
}
