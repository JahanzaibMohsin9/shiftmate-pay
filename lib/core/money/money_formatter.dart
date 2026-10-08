import 'package:intl/intl.dart';

import '../common/app_constants.dart';
import 'currency_amount.dart';

final class MoneyFormatter {
  const MoneyFormatter._();

  static String formatMinorUnits(
    int minorUnits, {
    String currencyCode = AppConstants.defaultCurrencyCode,
    String locale = AppConstants.defaultLocale,
  }) {
    final amount = minorUnits / AppConstants.minorUnitsPerMajorUnit;
    return NumberFormat.currency(
      locale: locale,
      name: currencyCode,
      customPattern: '¤ #,##0.00',
    ).format(amount);
  }

  static String formatAmount(
    CurrencyAmount amount, {
    String locale = AppConstants.defaultLocale,
  }) => formatMinorUnits(
        amount.minorUnits,
        currencyCode: amount.currencyCode,
        locale: locale,
      );
}
