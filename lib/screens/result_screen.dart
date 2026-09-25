import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../providers/quiz_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) {
        final accuracy = quizProvider.accuracy;
        final roundedPercentage = accuracy.round();
        final isSuccess = roundedPercentage >= 50;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _playAgain(context);
          },
          child: Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
                child: Column(
                  children: [
                    const Spacer(),

                    // Top Graphic Illustration Area matching Figma Image 2 100% EXACT
                    SizedBox(
                      width: 240,
                      height: 200,
                      child: isSuccess
                          ? Image.asset(
                              'assets/images/confetti_popper.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return CustomPaint(painter: _ConfettiPopperPainter());
                              },
                            )
                          : Image.asset(
                              'assets/images/config_illustration.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return CustomPaint(painter: _FailIllustrationPainter());
                              },
                            ),
                    ),

                    const SizedBox(height: 24),

                    // Title Text: Congratulation OR Keep Trying!
                    Text(
                      isSuccess ? "Congratulation" : "Keep Trying!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textDark,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Percentage Badge Display matching Image 2 (Light green pill container)
                    Container(
                      width: 220,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSuccess
                            ? AppTheme.successBadgeGreen
                            : AppTheme.failBadgeRed,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: (isSuccess
                                    ? AppTheme.successBadgeGreen
                                    : AppTheme.failBadgeRed)
                                .withAlpha(120),
                            blurRadius: 16,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "$roundedPercentage%",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: isSuccess ? AppTheme.textDark : Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Subtitle / Feedback Statement Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        isSuccess
                            ? "You've got a great Foundation. Ready to try a different category?"
                            : "Dont give up!Practice  makes perfect. Try again to  improveyour score",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Bottom Primary Action Button: PLAY AGAIN
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryTeal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => _playAgain(context),
                        child: const Text(
                          "PLAY AGAIN",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _playAgain(BuildContext context) {
    final quizProvider = context.read<QuizProvider>();
    quizProvider.resetQuiz();

    // Preserve configuration and navigate back to Quiz Config Screen
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.quizConfig,
      (route) => route.isFirst,
    );
  }
}

/// Fallback CustomPainter for Success State
class _ConfettiPopperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bluePath = Path()
      ..moveTo(size.width * 0.32, size.height * 0.1)
      ..cubicTo(size.width * 0.38, size.height * 0.04, size.width * 0.42, size.height * 0.16, size.width * 0.36, size.height * 0.22);
    canvas.drawPath(bluePath, Paint()..color = const Color(0xFF64B5F6));

    final hornPath = Path()
      ..moveTo(size.width * 0.35, size.height * 0.72)
      ..lineTo(size.width * 0.74, size.height * 0.46)
      ..lineTo(size.width * 0.54, size.height * 0.88)
      ..close();

    canvas.drawPath(hornPath, Paint()..color = const Color(0xFFEC407A));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Fallback CustomPainter for Fail State
class _FailIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(20, 15, size.width - 40, size.height - 30),
      const Radius.circular(20),
    );
    canvas.drawRRect(bgRect, Paint()..color = const Color(0xFFD4E9FF));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
