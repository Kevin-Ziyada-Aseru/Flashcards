class Flashcard {
  final int id;
  final String question;
  final String answer;
  final int setId;
  final DateTime? createdAt;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.setId,
    this.createdAt,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      setId: json['set_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'answer': answer,
    'set_id': setId,
    if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
  };

  Flashcard copyWith({
    int? id,
    String? question,
    String? answer,
    int? setId,
    DateTime? createdAt,
  }) {
    return Flashcard(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      setId: setId ?? this.setId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
