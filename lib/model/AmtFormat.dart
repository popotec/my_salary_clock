import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AmtFormat extends TextInputFormatter {
  static String defaultFormat(String text) {
    // Do whatever you want
    return text;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = '';
    if (newValue.text != '') {
      newText = newValue.text.replaceAll(",", "");

      newText = new NumberFormat('###,###,###,###,###,###,###')
          .format(int.parse(newText))
          .replaceAll(' ', '');
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
