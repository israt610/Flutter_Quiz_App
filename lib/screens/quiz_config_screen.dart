import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../providers/quiz_provider.dart';
import '../utils/html_utils.dart';

class QuizConfigScreen extends StatefulWidget {
  const QuizConfigScreen({super.key});

  @override
  State<QuizConfigScreen> createState() => _QuizConfigScreenState();
}

class _QuizConfigScreenState extends State<QuizConfigScreen> {
  final List<String> _difficultyOptions = ['any', 'easy', 'medium', 'hard'];
  final Map<String, String> _typeOptions = {
    'multiple': 'Multiple Choice',
    'boolean': 'True / False',
  };

  Future<void> _startQuiz() async {
    final quizProvider = context.read<QuizProvider>();
    final success = await quizProvider.loadQuestions();

    if (!mounted) return;

    if (success) {
      Navigator.pushNamed(context, AppRoutes.quiz);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: AppTheme.error),
              SizedBox(width: 10),
              Text('Configuration Error'),
            ],
          ),
          content: Text(
            quizProvider.error ?? 'Unable to fetch questions. Please try again.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                _startQuiz();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Consumer<QuizProvider>(
          builder: (context, quizProvider, child) {
            final config = quizProvider.config;
            final decodedCategory = HtmlUtils.decode(config.categoryName);

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // Back Button Header
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textDark, size: 22),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),

                        // Top Illustration Graphic (Hand interacting with toggle switches & gear)
                        SizedBox(
                          width: 170,
                          height: 140,
                          child: Image.asset(
                            'assets/images/config_illustration.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return CustomPaint(painter: _ConfigIllustrationPainter());
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Title: Quizzical
                        const Text(
                          "Quizzical",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textDark,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Subtitle: Configuration
                        const Text(
                          "Configuration",
                          style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 2),

                        // Selected Category Name
                        Text(
                          decodedCategory,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Section 1: Number of Questions (Slider)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Number of Questions",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Select 1–50",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textLight,
                                  ),
                                ),
                                Text(
                                  "${config.amount}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.sliderBlue,
                                  ),
                                ),
                              ],
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: AppTheme.sliderBlue,
                                inactiveTrackColor: const Color(0xFFE2E8F0),
                                thumbColor: AppTheme.sliderBlue,
                                overlayColor: AppTheme.sliderBlue.withAlpha(40),
                                trackHeight: 5,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
                              ),
                              child: Slider(
                                value: config.amount.toDouble(),
                                min: 1,
                                max: 50,
                                onChanged: quizProvider.isLoading
                                    ? null
                                    : (val) {
                                        quizProvider.updateConfig(amount: val.round());
                                      },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Section 2: Difficulty Level Dropdown
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Difficulty Level",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: config.difficulty.toLowerCase(),
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textSecondary),
                                  items: _difficultyOptions.map((diff) {
                                    final label = diff[0].toUpperCase() + diff.substring(1);
                                    return DropdownMenuItem(
                                      value: diff,
                                      child: Text(
                                        label == 'Any' ? 'Any Difficulty' : label,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.textDark,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: quizProvider.isLoading
                                      ? null
                                      : (val) {
                                          if (val != null) {
                                            quizProvider.updateConfig(difficulty: val);
                                          }
                                        },
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Section 3: Question Type Dropdown
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Question Type",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textDark,
                                  ),
                                ),
                                Text(
                                  "•••",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8C52FF),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: config.type,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textSecondary),
                                  items: _typeOptions.entries.map((entry) {
                                    return DropdownMenuItem(
                                      value: entry.key,
                                      child: Text(
                                        entry.value,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.textDark,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: quizProvider.isLoading
                                      ? null
                                      : (val) {
                                          if (val != null) {
                                            quizProvider.updateConfig(type: val);
                                          }
                                        },
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Outlined START Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTheme.primaryTeal,
                              side: const BorderSide(color: AppTheme.primaryTeal, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            onPressed: quizProvider.isLoading ? null : _startQuiz,
                            child: quizProvider.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: AppTheme.primaryTeal,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    "START",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
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
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Fallback CustomPainter for Configuration Screen
class _ConfigIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(15, 10, size.width - 30, size.height - 20),
      const Radius.circular(20),
    );
    canvas.drawRRect(bgRect, Paint()..color = const Color(0xFFD4E9FF));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
