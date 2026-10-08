import '../common/app_constants.dart';

class CurrencyAmount {
  const CurrencyAmount({
    required this.minorUnits,
    required this.currencyCode,
  });

  final int minorUnits;
  final String currencyCode;

  double get majorUnits => minorUnits / AppConstants.minorUnitsPerMajorUnit;

  CurrencyAmount operator +(CurrencyAmount other) {
    _assertSameCurrency(other);
    return CurrencyAmount(
      minorUnits: minorUnits + other.minorUnits,
      currencyCode: currencyCode,
    );
  }

  CurrencyAmount operator -(CurrencyAmount other) {
    _assertSameCurrency(other);
    return CurrencyAmount(
      minorUnits: minorUnits - other.minorUnits,
      currencyCode: currencyCode,
    );
  }

  void _assertSameCurrency(CurrencyAmount other) {
    if (currencyCode != other.currencyCode) {
      throw ArgumentError(
        'Currency mismatch: $currencyCode != ${other.currencyCode}',
      );
    }
  }
}
