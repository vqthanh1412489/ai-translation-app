class AppValidators {
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL không được để trống';
    }
    final urlPattern = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    if (!urlPattern.hasMatch(value)) {
      return 'URL không hợp lệ';
    }
    return null;
  }

  static String? validateApiKey(String? value) {
    if (value == null || value.isEmpty) {
      return 'API Key không được để trống';
    }
    if (value.length < 10) {
      return 'API Key quá ngắn';
    }
    return null;
  }

  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName không được để trống';
    }
    return null;
  }
}
