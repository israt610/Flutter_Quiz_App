import 'package:flutter_test/flutter_test.dart';
import 'package:quizzical/models/category_model.dart';
import 'package:quizzical/models/question_model.dart';
import 'package:quizzical/models/quiz_config_model.dart';
import 'package:quizzical/providers/quiz_provider.dart';
import 'package:quizzical/utils/html_utils.dart';

void main() {
  group('CategoryModel Tests', () {
    test('CategoryModel.fromJson parses JSON accurately', () {
      final json = {'id': 9, 'name': 'General Knowledge'};
      final category = CategoryModel.fromJson(json);

      expect(category.id, 9);
      expect(category.name, 'General Knowledge');
    });

    test('CategoryModel.toJson serializes correctly', () {
      final category = CategoryModel(id: 10, name: 'Entertainment: Books');
      final json = category.toJson();

      expect(json['id'], 10);
      expect(json['name'], 'Entertainment: Books');
    });
  });

  group('QuestionModel & Shuffling Tests', () {
    test('QuestionModel.fromJson decodes HTML entities and parses fields', () {
      final json = {
        'category': 'Entertainment: &quot;Film&quot;',
        'type': 'multiple',
        'difficulty': 'easy',
        'question': 'Which actor played Neo in &#039;The Matrix&#039;?',
        'correct_answer': 'Keanu Reeves',
        'incorrect_answers': ['Tom Cruise', 'Brad Pitt', 'Will Smith'],
      };

      final question = QuestionModel.fromJson(json);

      expect(question.category, 'Entertainment: "Film"');
      expect(question.question, "Which actor played Neo in 'The Matrix'?");
      expect(question.correctAnswer, 'Keanu Reeves');
      expect(question.incorrectAnswers.length, 3);
      expect(question.incorrectAnswers.contains('Tom Cruise'), isTrue);
    });

    test('allAnswers contains exactly 4 choices including correct answer for multiple type', () {
      final json = {
        'category': 'General Knowledge',
        'type': 'multiple',
        'difficulty': 'easy',
        'question': 'What is 2 + 2?',
        'correct_answer': '4',
        'incorrect_answers': ['3', '5', '2'],
      };

      final question = QuestionModel.fromJson(json);

      expect(question.allAnswers.length, 4);
      expect(question.allAnswers.contains('4'), isTrue);
      expect(question.allAnswers.contains('3'), isTrue);
      expect(question.allAnswers.contains('5'), isTrue);
      expect(question.allAnswers.contains('2'), isTrue);
    });
  });

  group('QuizConfigModel Tests', () {
    test('QuizConfigModel has expected default values and copyWith updates', () {
      final config = QuizConfigModel();

      expect(config.amount, 10);
      expect(config.difficulty, 'any');
      expect(config.type, 'multiple');
      expect(config.categoryId, 9);

      final updated = config.copyWith(amount: 15, difficulty: 'hard');
      expect(updated.amount, 15);
      expect(updated.difficulty, 'hard');
      expect(updated.type, 'multiple'); // Preserved
    });
  });

  group('QuizProvider State & Accuracy Tests', () {
    test('Score and Accuracy calculations are accurate', () {
      final quizProvider = QuizProvider();

      expect(quizProvider.score, 0);
      expect(quizProvider.accuracy, 0.0);
    });

    test('Resetting quiz resets index, score, and finished flag', () {
      final quizProvider = QuizProvider();
      quizProvider.resetQuiz();

      expect(quizProvider.currentQuestionIndex, 0);
      expect(quizProvider.score, 0);
      expect(quizProvider.totalTime, 0);
      expect(quizProvider.quizFinished, false);
      expect(quizProvider.selectedAnswer, isNull);
      expect(quizProvider.isAnswered, false);
    });
  });

  group('HtmlUtils Unit Tests', () {
    test('Decodes standard HTML entities properly', () {
      expect(HtmlUtils.decode('&quot;Quizzical&quot;'), '"Quizzical"');
      expect(HtmlUtils.decode('Don&#039;t stop'), "Don't stop");
      expect(HtmlUtils.decode('Rock &amp; Roll'), 'Rock & Roll');
      expect(HtmlUtils.decode('&lt;div&gt;'), '<div>');
    });
  });
}
