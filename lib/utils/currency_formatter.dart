class CurrencyFormatter {
  static String formatIQD(int amount) {
    // Convert the number to string
    String priceString = amount.toString();

    // Add commas for every 3 digits from right
    String result = '';
    for (int i = priceString.length - 1, count = 0; i >= 0; i--, count++) {
      if (count > 0 && count % 3 == 0) {
        result = ',' + result;
      }
      result = priceString[i] + result;
    }

    return '$result IQD';
  }
}
