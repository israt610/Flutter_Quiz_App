import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../providers/quiz_provider.dart';
import '../widgets/answer_button.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Future<bool> _onWillPop() async {
    final quizProvider = context.read<QuizProvider>();
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Exit Quiz?'),
        content: const Text('Are you sure you want to leave? Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              quizProvider.stopTimer();
              Navigator.of(context).pop(true);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        final currentQuestion = quizProvider.currentQuestion;
        final currentIndex = quizProvider.currentQuestionIndex;
        final totalQuestions = quizProvider.totalQuestions;

        if (currentQuestion == null || totalQuestions == 0) {
          return Scaffold(
            appBar: AppBar(title: const Text("Quiz")),
            body: const Center(
              child: Text("No questions available."),
            ),
          );
        }

        final progress = (currentIndex + 1) / totalQuestions;
        final isLastQuestion = currentIndex == totalQuestions - 1;
        final allAnswers = currentQuestion.allAnswers;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _onWillPop().then((shouldPop) {
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            });
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFF4F6F8), // Matching off-white background
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Top Header Row matching Figma: 7/10 Centered & EXIT ➔ Top Right
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Centered 7/10
                        Text(
                          "${currentIndex + 1}/$totalQuestions",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textDark,
                          ),
                        ),

                        // Top Right EXIT Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              _onWillPop().then((shouldPop) {
                                if (shouldPop && context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "EXIT",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.textDark,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.logout_rounded,
                                    size: 18,
                                    color: AppTheme.textDark,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Blue Progress Bar right under Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        backgroundColor: const Color(0xFFE2E8F0),
                        color: const Color(0xFF3B82F6), // Bright blue active bar
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Question Box Card & Options
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Question Box Card matching Figma (Pure white, rounded 24)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(10),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              currentQuestion.question,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                                height: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Answer Options List
                          ...List.generate(allAnswers.length, (index) {
                            final optionText = allAnswers[index];

                            AnswerButtonStyle style = AnswerButtonStyle.normal;

                            if (quizProvider.isAnswered) {
                              if (optionText == currentQuestion.correctAnswer) {
                                style = AnswerButtonStyle.correct;
                              } else if (optionText == quizProvider.selectedAnswer) {
                                style = AnswerButtonStyle.wrong;
                              }
                            } else if (optionText == quizProvider.selectedAnswer) {
                              style = AnswerButtonStyle.selected;
                            }

                            return AnswerButton(
                              text: optionText,
                              style: style,
                              isDisabled: quizProvider.isAnswered,
                              onTap: () {
                                quizProvider.selectAnswer(optionText);
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Pill Action Button: "Next"
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryTeal,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppTheme.primaryTeal.withAlpha(128),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                          elevation: 0,
                        ),
                        onPressed: quizProvider.isAnswered
                            ? () {
                                if (isLastQuestion) {
                                  quizProvider.finishQuiz();
                                  Navigator.pushReplacementNamed(
                                      context, AppRoutes.results);
                                } else {
                                  quizProvider.nextQuestion();
                                }
                              }
                            : null,
                        child: Text(
                          isLastQuestion ? "Finish" : "Next",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
