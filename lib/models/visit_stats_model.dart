class VisitStatsModel {
  final int dailyStreak;
  final int monthlyStreak;
  final int totalVisits;
  final int currentMonthVisits;

  const VisitStatsModel({
    required this.dailyStreak,
    required this.monthlyStreak,
    required this.totalVisits,
    required this.currentMonthVisits,
  });

  factory VisitStatsModel.fromJson(Map<String, dynamic> json) {
    return VisitStatsModel(
      dailyStreak: json['dailyStreak'] as int? ?? 0,
      monthlyStreak: json['monthlyStreak'] as int? ?? 0,
      totalVisits: json['totalVisits'] as int? ?? 0,
      currentMonthVisits: json['currentMonthVisits'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'dailyStreak': dailyStreak,
    'monthlyStreak': monthlyStreak,
    'totalVisits': totalVisits,
    'currentMonthVisits': currentMonthVisits,
  };

  VisitStatsModel copyWith({
    int? dailyStreak,
    int? monthlyStreak,
    int? totalVisits,
    int? currentMonthVisits,
  }) {
    return VisitStatsModel(
      dailyStreak: dailyStreak ?? this.dailyStreak,
      monthlyStreak: monthlyStreak ?? this.monthlyStreak,
      totalVisits: totalVisits ?? this.totalVisits,
      currentMonthVisits: currentMonthVisits ?? this.currentMonthVisits,
    );
  }
}