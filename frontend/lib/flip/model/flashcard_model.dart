class Flashcard {
  final String question;
  final String answer;

  Flashcard({required this.question, required this.answer});

  // Convert from Map
  factory Flashcard.fromMap(Map<String, String> map) {
    return Flashcard(question: map['q'] ?? '', answer: map['a'] ?? '');
  }

  // Convert to Map
  Map<String, String> toMap() {
    return {'q': question, 'a': answer};
  }
}
