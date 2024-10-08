import 'dart:async';
import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

class RemainingTimeWidget extends StatefulWidget {
  final int timestamp;

  const RemainingTimeWidget({super.key, required this.timestamp});

  @override
  _RemainingTimeWidgetState createState() => _RemainingTimeWidgetState();
}

class _RemainingTimeWidgetState extends State<RemainingTimeWidget> {
  Timer? timer;

  int remainingDay = 0;
  int remainingHour = 0;
  int remainingMinute = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {}); // Trigger a rebuild every second
    });
  }

  Duration getRemainingTime() {
    DateTime now = DateTime.now();
    DateTime eventTime = DateTime.fromMillisecondsSinceEpoch(widget.timestamp * 1000);
    return eventTime.isBefore(now) ? Duration.zero : eventTime.difference(now);
  }

  String formatRemainingTime(Duration duration) {
    if (duration == Duration.zero) {
      return "Finished";
    } else {
      int days = duration.inDays;
      int hours = duration.inHours.remainder(24);
      int minutes = duration.inMinutes.remainder(60);

      remainingDay = days;
      remainingHour = hours;
      remainingMinute = minutes;

      return "${days}d ${hours}h ${minutes}m";
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isBefore = formatRemainingTime(getRemainingTime()) == "Finished";
    // return Text(formatRemainingTime(getRemainingTime()));
    return isBefore ? Text("Finished", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),) : Row(
      children: [
        Text("$remainingDay", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),),
        Text("d", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: primaryColor),),
        Text(" $remainingHour", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),),
        Text("h", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: primaryColor),),
        Text(" $remainingMinute", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),),
        Text("m", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: primaryColor),),
      ],
    );
  }
}
