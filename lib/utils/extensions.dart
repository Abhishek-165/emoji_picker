extension StringExtensions on String {
  String refactorWithCapitalization() {
    return replaceAll('-', ' ') // Replace "-" with space
        .split(' ') // Split the string by spaces
        .map((word) =>
            word[0].toUpperCase() +
            word.substring(
                1)) // Capitalize first letter and join remaining characters
        .join(' ');
  }
}
