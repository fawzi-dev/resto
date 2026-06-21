import 'package:intl/intl.dart';

import '../localization/app_strings.dart';

abstract final class CurrencyFormatter {
  // Western digits + comma grouping to match the design, e.g. "8,000 دینار".
  static final NumberFormat _decimal = NumberFormat.decimalPattern('en_US');

  static String format(num amount) =>
      '${_decimal.format(amount)} ${AppStrings.currency}';
}
