import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime startContest;
  final DateTime endContest;

  const CountdownTimer({
    Key? key,
    required this.startContest,
    required this.endContest,
  }) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late DateTime now;
  String countdownText = "";

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        now = DateTime.now();
        countdownText = _calculateCountdown();
      });
    });
  }

  String _calculateCountdown() {
    DateTime start = widget.startContest;
    DateTime end = widget.endContest;

    if (now.isBefore(start)) {
      // Contest hasn't started yet
      Duration timeLeft = start.difference(now);
      return _formatDuration(timeLeft);
    } else if (now.isAfter(start) && now.isBefore(end)) {
      // Contest is running
      Duration timeLeft = end.difference(now);
      return "Time Left: ${_formatDuration(timeLeft)}";
    } else {
      // Contest has ended
      _timer.cancel();
      return "Contest Ended";
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      countdownText,
      style: GoogleFonts.inter(
        textStyle: TextStyle(
          fontSize: 18,
          color: Colors.blue, // Change to AppColors.primary
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
