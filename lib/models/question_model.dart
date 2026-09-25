import '../utils/html_utils.dart';

class QuestionModel {
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<String> allAnswers;

  QuestionModel({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.allAnswers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final String decodedQuestion = HtmlUtils.decode(json['question'] ?? '');
    final String decodedCorrect = HtmlUtils.decode(json['correct_answer'] ?? '');
    final List<String> decodedIncorrect = (json['incorrect_answers'] as List<dynamic>?)
            ?.map((e) => HtmlUtils.decode(e.toString()))
            .toList() ??
        [];

    final List<String> answers = [...decodedIncorrect, decodedCorrect];
    answers.shuffle();

    return QuestionModel(
      category: HtmlUtils.decode(json['category'] ?? ''),
      type: json['type'] ?? 'multiple',
      difficulty: json['difficulty'] ?? 'easy',
      question: decodedQuestion,
      correctAnswer: decodedCorrect,
      incorrectAnswers: decodedIncorrect,
      allAnswers: answers,
    );
  }
}
