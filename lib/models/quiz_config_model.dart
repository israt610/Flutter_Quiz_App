class QuizConfigModel {
  final int amount;
  final String difficulty; // "any", "easy", "medium", "hard"
  final String type; // "multiple", "boolean"
  final int categoryId;
  final String categoryName;

  QuizConfigModel({
    this.amount = 10,
    this.difficulty = 'any',
    this.type = 'multiple',
    this.categoryId = 9,
    this.categoryName = 'General Knowledge',
  });

  QuizConfigModel copyWith({
    int? amount,
    String? difficulty,
    String? type,
    int? categoryId,
    String? categoryName,
  }) {
    return QuizConfigModel(
      amount: amount ?? this.amount,
      difficulty: difficulty ?? this.difficulty,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
