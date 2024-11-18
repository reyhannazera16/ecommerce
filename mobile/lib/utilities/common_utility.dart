import 'package:intl/intl.dart';

class CommonUtility {
  static NumberFormat get _rupiahFormatter {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  }

  static String formatRupiah({required int value}) {
    return _rupiahFormatter.format(value);
  }

  static String? formValidator(String? value) {
    return value == null || value.isEmpty ? 'Data tidak boleh kosong' : null;
  }

  static String firstName({required String value}) {
    final int index = value.indexOf(' ');
    if (index == -1) return value;

    return value.replaceRange(index, null, '');
  }
}
