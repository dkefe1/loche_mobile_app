class RoundNumber{
  String round(num number){
    if (number % 1 == 0) {
      // Check if the number has no decimal part
      return number.toInt().toString(); // Display the integer
    } else {
      return number.toStringAsFixed(1); // Display rounded to 1 decimal point
    }
  }
}