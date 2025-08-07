import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class DotInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newText = newValue.text;

    // Allow only 1 dot
    if ('.'.allMatches(newText).length > 1) {
      return oldValue;
    }

    // Allow only digits and dot
    if (!RegExp(r'^[0-9.]*$').hasMatch(newText)) {
      return oldValue;
    }

    // Enforce max length of 8
    if (newText.length > 8) {
      return oldValue;
    }

    return newValue;
  }
}
