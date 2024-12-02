class Utils {
  static String getLinkFromText(String? text) {
    if (text == null || text.isEmpty) return '';

    final urlRegex = RegExp(r'(https?:\/\/[^\s]+)');

    return text.replaceAllMapped(urlRegex, (match) {
      return match.group(0) ?? '';
    });
  }

  /// parse check String value is empty or not
  static String? getNotEmptyString(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }

  /// parse check String value is empty or not
  static bool isEmptyString(String? value) {
    if (value == null || value.isEmpty) {
      return true;
    }

    return false;
  }

  /// Hide phone number
  static String hidePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }

    return value.replaceRange(0, 6, '*******');
  }
}
