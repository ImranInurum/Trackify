import 'package:flutter/material.dart';

class Validators {
  /// Validates that the input is not empty.
  static String? validateRequired(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  /// Validates that the input is a valid email format.
  static String? validateEmail(String? value, String emptyMessage, String invalidMessage) {
    if (value == null || value.trim().isEmpty) {
      return emptyMessage;
    }
    
    // Regular expression for email validation
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    
    if (!emailRegex.hasMatch(value)) {
      return invalidMessage;
    }
    return null;
  }

  /// Validates that the password meets minimum length requirements.
  static String? validatePassword(String? value, String emptyMessage, String minLengthMessage, {int minLength = 6}) {
    if (value == null || value.trim().isEmpty) {
      return emptyMessage;
    }
    if (value.length < minLength) {
      return minLengthMessage;
    }
    return null;
  }

  /// Validates that two passwords match.
  static String? validateConfirmPassword(String? value, String password, String message) {
    if (value != password) {
      return message;
    }
    return null;
  }
}
