import 'package:otlob/core/constants/app_strings.dart';

class Validator {
  static String? validateEmail(String email) {
    if (email.trim().isEmpty) {
      return AppStrings.emailRequired;
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim())) {
      return AppStrings.emailInvalidFormat;
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (password.length < 6 || password.length > 10) {
      return AppStrings.passwordLengthRange;
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return AppStrings.passwordAtLeast1Uppercase;
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return AppStrings.passwordAtLeast1Lowercase;
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return AppStrings.passwordAtLeast1Number;
    }
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(password)) {
      return AppStrings.passwordAtLeast1SpecialChar;
    }
    // if (passwordController.text != confirmPassController.text) {
    //   return AppStrings.passwordNotTheSame;
    // }
    return null;
  }

  static String? validateID(String id) {
    final regex = RegExp(r'^\d{14}$');

    if (id.isEmpty) {
      return AppStrings.idRequired;
    } else if (!regex.hasMatch(id)) {
      return AppStrings.idInvalid;
    }
    return null;
  }

  static String? validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.trim().isEmpty) {
      return AppStrings.phoneRequired;
    }
    return null;
  }

  static String? validateUserName(String userName) {
    if (userName.trim().isEmpty) {
      return AppStrings.usernameRequired;
    }
    return null;
  }
}
