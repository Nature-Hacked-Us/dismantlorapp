class StringHelper {
  static bool isBlank(String str) {
    return str == null || str.trim().isEmpty;
  }

  static bool isNotBlank(String str) {
    return str != null && str.trim().isNotEmpty;
  }
}