class TransactionValidator {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Transaction name required";
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty || (num.tryParse(value) == null)) {
      return "Transaction price required";
    }
    return null;
  }
}
