class Question {
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  
  // Cache shuffled answers to preserve option positions during UI rebuilds
  List<String>? _cachedAnswers;

  Question({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      category: json['category'],
      type: json['type'],
      difficulty: json['difficulty'],
      question: json['question'],
      correctAnswer: json['correct_answer'],
      incorrectAnswers:
          List<String>.from(json['incorrect_answers']),
    );
  }

  List<String> get allAnswers {
    if (_cachedAnswers == null) {
      final answers = [...incorrectAnswers, correctAnswer];
      answers.shuffle();
      _cachedAnswers = answers;
    }
    return _cachedAnswers!;
  }
}
