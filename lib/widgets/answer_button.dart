import 'package:flutter/material.dart';
import '../app/theme.dart';

enum AnswerButtonStyle { normal, selected, correct, wrong }

class AnswerButton extends StatelessWidget {
  final String text;
  final AnswerButtonStyle style;
  final bool isDisabled;
  final VoidCallback onTap;

  const AnswerButton({
    super.key,
    required this.text,
    required this.style,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Widget iconWidget;

    switch (style) {
      case AnswerButtonStyle.correct:
        backgroundColor = const Color(0xFFA7D7C5); // Exact soft muted green fill from Figma
        textColor = const Color(0xFF004D40);       // Dark teal text
        iconWidget = Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Color(0xFF004D40),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 15, color: Colors.white),
        );
        break;

      case AnswerButtonStyle.wrong:
        backgroundColor = const Color(0xFFFFA3A3); // Exact soft pink/red fill from Figma
        textColor = const Color(0xFF004D40);       // Dark text
        iconWidget = Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Color(0xFFFF3B30),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, size: 15, color: Colors.white),
        );
        break;

      case AnswerButtonStyle.selected:
        backgroundColor = AppTheme.primaryTeal.withAlpha(20);
        textColor = AppTheme.primaryTeal;
        iconWidget = const Icon(
          Icons.radio_button_checked,
          size: 22,
          color: AppTheme.primaryTeal,
        );
        break;

      case AnswerButtonStyle.normal:
        backgroundColor = Colors.white;
        textColor = AppTheme.textDark;
        iconWidget = Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF718096), width: 1.5),
          ),
        );
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                iconWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
