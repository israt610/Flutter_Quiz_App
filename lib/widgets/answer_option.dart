import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/html_decoder.dart';

enum AnswerState { defaultState, selected, correct, incorrect }

class AnswerOption extends StatelessWidget {
  final String optionLabel; // e.g. "A", "B", "C", "D"
  final String optionText;
  final AnswerState state;
  final VoidCallback? onTap;

  const AnswerOption({
    super.key,
    required this.optionLabel,
    required this.optionText,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    Color labelBgColor;
    Color labelTextColor;
    IconData? trailingIcon;

    switch (state) {
      case AnswerState.correct:
        backgroundColor = AppColors.successBg;
        borderColor = AppColors.success;
        textColor = AppColors.success;
        labelBgColor = AppColors.success;
        labelTextColor = Colors.white;
        trailingIcon = Icons.check_circle;
        break;
      case AnswerState.incorrect:
        backgroundColor = AppColors.errorBg;
        borderColor = AppColors.error;
        textColor = AppColors.error;
        labelBgColor = AppColors.error;
        labelTextColor = Colors.white;
        trailingIcon = Icons.cancel;
        break;
      case AnswerState.selected:
        backgroundColor = AppColors.optionSelectedBg;
        borderColor = AppColors.optionSelectedBorder;
        textColor = AppColors.primary;
        labelBgColor = AppColors.primary;
        labelTextColor = Colors.white;
        trailingIcon = Icons.radio_button_checked;
        break;
      case AnswerState.defaultState:
        backgroundColor = AppColors.cardSurface;
        borderColor = AppColors.border;
        textColor = AppColors.textPrimary;
        labelBgColor = AppColors.background;
        labelTextColor = AppColors.textSecondary;
        trailingIcon = Icons.radio_button_unchecked;
        break;
    }

    final decodedText = HtmlDecoder.decode(optionText);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: state == AnswerState.defaultState ? 1.2 : 2.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(6),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: labelBgColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    optionLabel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: labelTextColor,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    decodedText,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: state == AnswerState.defaultState ? FontWeight.w500 : FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  trailingIcon,
                  color: borderColor,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
