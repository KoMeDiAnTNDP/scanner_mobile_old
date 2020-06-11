import 'package:scanner_mobile/src/shared/models/Errors.dart';

class ValidationService {
  static bool isValueEmpty(String value) {
    return value.isEmpty;
  }

  static String validateField(String value) {
    return isValueEmpty(value) ? Errors.ERROR_EMPTY_FIELD : null;
  }

  static String validateEmail(String value) {
    if (isValueEmpty(value)) {
      return Errors.ERROR_EMPTY_FIELD;
    }

    RegExp regExp = RegExp(r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if (!regExp.hasMatch(value)) {
      return Errors.ERROR_USER_EMAIL;
    }

    return null;
  }

  static String validatePassword(String value) {
    if (isValueEmpty(value)) {
      return Errors.ERROR_EMPTY_FIELD;
    }

    if (value.length < 6) {
      return Errors.ERROR_USER_PASSWORD;
    }

    return null;
  }

  static String validateUsername(String value) {
    if (isValueEmpty(value)) {
      return Errors.ERROR_EMPTY_FIELD;
    }

    RegExp regExp = RegExp(r'^[a-zA-Z]+$');

    if (!regExp.hasMatch(value)) {
      return Errors.ERROR_USER_USERNAME;
    }

    return null;
  }
}