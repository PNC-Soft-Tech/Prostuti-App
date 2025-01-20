class RankingInfo {
  final int participants;
  final int contestMark;
  final int contestTime;
  final DateTime contestDate;
  final String contestTitle;
  final List<ContestResult> firstThreeResults;

  RankingInfo({
    required this.participants,
    required this.contestMark,
    required this.contestTime,
    required this.contestDate,
    required this.contestTitle,
    required this.firstThreeResults,
  });

  factory RankingInfo.fromJson(Map<String, dynamic> json) {
    return RankingInfo(
      participants: json['info']['Participants'] ?? 0,
      contestMark: json['info']['contestMark'] ?? 0,
      contestTime: json['info']['contestTime'] ?? 0,
      contestDate: DateTime.parse(json['info']['contestDate']),
      contestTitle: json['info']['ContestTitle'] ?? '',
      firstThreeResults: (json['info']['firstThreeResults'] as List)
          .map((result) => ContestResult.fromJson(result))
          .toList(),
    );
  }
}

class ContestResult {
  final String id;
  final String user;
  final int points;
  final int rightAnswers;
  final int wrongAnswers;
  final String contestName;
  final DateTime startContest;
  final String userFullName;
  final String userEmail;
  final int contestMark;
  final String contestTitle;
  final int contestTime;
  final DateTime contestDate;

  ContestResult({
    required this.id,
    required this.user,
    required this.points,
    required this.rightAnswers,
    required this.wrongAnswers,
    required this.contestName,
    required this.startContest,
    required this.userFullName,
    required this.userEmail,
    required this.contestMark,
    required this.contestTitle,
    required this.contestTime,
    required this.contestDate,
  });

  factory ContestResult.fromJson(Map<String, dynamic> json) {
    return ContestResult(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      points: json['points'] ?? 0,
      rightAnswers: json['rightAnswers'] ?? 0,
      wrongAnswers: json['wrongAnswers'] ?? 0,
      contestName: json['contestName'] ?? '',
      startContest: DateTime.parse(json['startContest']),
      userFullName: json['userFullName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      contestMark: json['contestMark'] ?? 0,
      contestTitle: json['contestTitle'] ?? '',
      contestTime: json['contestTime'] ?? 0,
      contestDate: DateTime.parse(json['contestDate']),
    );
  }
}

class ContestData {
  final RankingInfo info;
  final List<ContestResult> results;

  ContestData({
    required this.info,
    required this.results,
  });

  factory ContestData.fromJson(Map<String, dynamic> json) {
    return ContestData(
      info: RankingInfo.fromJson(json['info']),
      results: (json['result'] as List)
          .map((result) => ContestResult.fromJson(result))
          .toList(),
    );
  }
}
