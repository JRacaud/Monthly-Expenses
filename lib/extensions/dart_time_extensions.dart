extension DateTimeExtensions on DateTime {
  bool isSameYearMonth(DateTime date) {
    return ((this.year == date.year) && (this.month == date.month));
  }
}
