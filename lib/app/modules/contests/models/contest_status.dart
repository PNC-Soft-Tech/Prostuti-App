class ContestStatus {
  final bool isRunning;
  final bool isDone;
  final bool isScheduled;

  ContestStatus({
    required this.isRunning,
    required this.isDone,
    required this.isScheduled,
  });

  // Factory method to determine the contest status
  factory ContestStatus.fromDates(DateTime start, DateTime end) {
    DateTime now = DateTime.now();
    if (start.isAfter(now)) {
      return ContestStatus(isScheduled: true, isRunning: false, isDone: false);
    } else if (end.isBefore(now) && start.isBefore(now)) {
      return ContestStatus(isScheduled: false, isRunning: false, isDone: true);
    } else {
      return ContestStatus(isScheduled: false, isRunning: true, isDone: false);
    }
  }
}
