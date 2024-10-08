import 'package:intl/intl.dart';

class TimeConvert{
  String getDayOfWeek(int dayNumber) {
    List<String> daysOfWeek = ["", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    return daysOfWeek[dayNumber];
  }

  String getMonth(int monthNumber) {
    List<String> months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    return months[monthNumber];
  }

  String formatTimestampToDateTime(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String formattedDate =
        "${getMonth(dateTime.month)} ${dateTime.day}, ${formatTime(dateTime.hour, dateTime.minute)}";
    return formattedDate;
  }

  String formatTime(int hour, int minute) {
    String period = 'AM';
    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) {
        hour -= 12;
      }
    }
    if (hour == 0) {
      hour = 12;
    }

    String hourStr = hour.toString().padLeft(2, '0');
    String minuteStr = minute.toString().padLeft(2, '0');

    return "$hourStr:$minuteStr $period";
  }

  String formatDateTime(DateTime dateTime) {
    // Define the desired output format
    DateFormat outputFormat = DateFormat('MMM d hh:mm a');

    // Convert and format the date
    String formattedDate = outputFormat.format(dateTime);

    return formattedDate;
  }

  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}