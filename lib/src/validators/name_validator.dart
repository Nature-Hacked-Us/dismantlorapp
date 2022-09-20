class NameValidator {
  static bool isValidNameOrEmpty(String name) {
    return name != null
        && !name.startsWith(" ")
        && !name.endsWith(" ");
  }

  static bool isValidName(String name) {
    return NameValidator.isValidNameOrEmpty(name) && name.trim().isNotEmpty;
  }

}