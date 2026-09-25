import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question_model.dart';
import '../models/quiz_config_model.dart';
import '../services/api_service.dart';

class QuizProvider extends ChangeNotifier {
  static const int questionDuration = 20; // 20 seconds per question

  QuizConfigModel _config = QuizConfigModel();
  List<QuestionModel> _questions = [];
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  int _score = 0;
  bool _isAnswered = false;
  bool _isLoading = false;
  String? _error;

  Timer? _timer;
  int _remainingSeconds = questionDuration;
  int _totalTime = 0;
  bool _quizFinished = false;

  // Getters
  QuizConfigModel get config => _config;
  List<QuestionModel> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  String? get selectedAnswer => _selectedAnswer;
  int get score => _score;
  bool get isAnswered => _isAnswered;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get remainingSeconds => _remainingSeconds;
  int get totalTime => _totalTime;
  bool get quizFinished => _quizFinished;
  int get totalQuestions => _questions.length;

  QuestionModel? get currentQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex < _questions.length
          ? _questions[_currentQuestionIndex]
          : null;

  double get accuracy =>
      totalQuestions > 0 ? (_score / totalQuestions) * 100 : 0.0;

  QuizProvider() {
    loadSavedConfig();
  }

  // SharedPreferences Keys
  static const String _keyAmount = 'quiz_config_amount';
  static const String _keyDifficulty = 'quiz_config_difficulty';
  static const String _keyType = 'quiz_config_type';
  static const String _keyCategoryId = 'quiz_config_category_id';
  static const String _keyCategoryName = 'quiz_config_category_name';

  /// Load last saved configuration from SharedPreferences
  Future<void> loadSavedConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final amount = prefs.getInt(_keyAmount) ?? 10;
      final difficulty = prefs.getString(_keyDifficulty) ?? 'any';
      final type = prefs.getString(_keyType) ?? 'multiple';
      final categoryId = prefs.getInt(_keyCategoryId) ?? 9;
      final categoryName = prefs.getString(_keyCategoryName) ?? 'General Knowledge';

      _config = QuizConfigModel(
        amount: amount,
        difficulty: difficulty,
        type: type,
        categoryId: categoryId,
        categoryName: categoryName,
      );
      notifyListeners();
    } catch (_) {
      // Use defaults if SharedPreferences is unavailable
    }
  }

  /// Update and persist quiz configuration
  Future<void> updateConfig({
    int? amount,
    String? difficulty,
    String? type,
    int? categoryId,
    String? categoryName,
  }) async {
    _config = _config.copyWith(
      amount: amount,
      difficulty: difficulty,
      type: type,
      categoryId: categoryId,
      categoryName: categoryName,
    );
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyAmount, _config.amount);
      await prefs.setString(_keyDifficulty, _config.difficulty);
      await prefs.setString(_keyType, _config.type);
      await prefs.setInt(_keyCategoryId, _config.categoryId);
      await prefs.setString(_keyCategoryName, _config.categoryName);
    } catch (_) {}
  }

  /// Fetch questions based on current configuration
  Future<bool> loadQuestions() async {
    _isLoading = true;
    _error = null;
    _questions = [];
    _currentQuestionIndex = 0;
    _score = 0;
    _totalTime = 0;
    _selectedAnswer = null;
    _isAnswered = false;
    _quizFinished = false;
    stopTimer();
    notifyListeners();

    try {
      _questions = await ApiService.fetchQuestions(
        amount: _config.amount,
        categoryId: _config.categoryId,
        difficulty: _config.difficulty,
        type: _config.type,
      );

      _isLoading = false;
      notifyListeners();
      startTimer();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Start question countdown timer
  void startTimer() {
    stopTimer();
    _remainingSeconds = questionDuration;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _totalTime++;
        notifyListeners();
      } else {
        // Timeout reached -> auto mark incorrect / unanswered
        stopTimer();
        _isAnswered = true;
        notifyListeners();
      }
    });
  }

  /// Stop active timer
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// User selects an answer
  void selectAnswer(String answer) {
    if (_isAnswered) return;

    stopTimer();
    _selectedAnswer = answer;
    _isAnswered = true;

    if (currentQuestion != null && answer == currentQuestion!.correctAnswer) {
      _score++;
    }

    notifyListeners();
  }

  /// Advance to next question or finish quiz
  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswer = null;
      _isAnswered = false;
      startTimer();
    } else {
      finishQuiz();
    }
    notifyListeners();
  }

  /// Complete quiz session
  void finishQuiz() {
    stopTimer();
    _quizFinished = true;
    notifyListeners();
  }

  /// Reset quiz state while preserving current configuration
  void resetQuiz() {
    stopTimer();
    _currentQuestionIndex = 0;
    _score = 0;
    _totalTime = 0;
    _selectedAnswer = null;
    _isAnswered = false;
    _quizFinished = false;
    notifyListeners();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}
