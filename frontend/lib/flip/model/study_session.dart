class StudySession {
  final int id;
  final int setId;
  final int totalCards;
  final int correctCount;
  final int wrongCount;
  final DateTime createdAt;

  StudySession({
    required this.id,
    required this.setId,
    required this.totalCards,
    required this.correctCount,
    required this.wrongCount,
    required this.createdAt,
  });

  factory StudySession.fromJson(Map<String, dynamic> json) {
    return StudySession(
      id: json['id'],
      setId: json['set_id'],
      totalCards: json['total_cards'],
      correctCount: json['correct_count'],
      wrongCount: json['wrong_count'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'set_id': setId,
    'total_cards': totalCards,
    'correct_count': correctCount,
    'wrong_count': wrongCount,
    'created_at': createdAt.toIso8601String(),
  };

  double get accuracy {
    if (totalCards == 0) return 0;
    return (correctCount / totalCards) * 100;
  }

  StudySession copyWith({
    int? id,
    int? setId,
    int? totalCards,
    int? correctCount,
    int? wrongCount,
    DateTime? createdAt,
  }) {
    return StudySession(
      id: id ?? this.id,
      setId: setId ?? this.setId,
      totalCards: totalCards ?? this.totalCards,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
