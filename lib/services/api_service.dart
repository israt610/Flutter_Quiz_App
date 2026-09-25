import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/question_model.dart';

class ApiService {
  static const String _baseUrl = 'opentdb.com';
  static const Duration _timeoutDuration = Duration(seconds: 15);

  /// Fetch trivia categories from OpenTDB
  static Future<List<CategoryModel>> fetchCategories() async {
    final Uri uri = Uri.https(_baseUrl, '/api_category.php');

    try {
      final response = await http.get(uri).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> categoriesJson = data['trivia_categories'] ?? [];
        return categoriesJson
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load categories. Status code: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timed out while fetching categories. Please check your internet connection.');
    } catch (e) {
      throw Exception('Unable to load categories: $e');
    }
  }

  /// Fetch questions from OpenTDB with dynamic query parameters
  static Future<List<QuestionModel>> fetchQuestions({
    required int amount,
    required int categoryId,
    String? difficulty,
    required String type,
  }) async {
    final Map<String, String> queryParams = {
      'amount': amount.toString(),
      'category': categoryId.toString(),
      'type': type,
    };

    // If difficulty is specified and not 'any', append to query params
    if (difficulty != null && difficulty.isNotEmpty && difficulty.toLowerCase() != 'any') {
      queryParams['difficulty'] = difficulty.toLowerCase();
    }

    final Uri uri = Uri.https(_baseUrl, '/api.php', queryParams);

    try {
      final response = await http.get(uri).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final int responseCode = data['response_code'] ?? -1;

        if (responseCode == 0) {
          final List<dynamic> results = data['results'] ?? [];
          if (results.isEmpty) {
            throw Exception('No questions found for the selected configuration.');
          }
          return results.map((json) => QuestionModel.fromJson(json)).toList();
        } else if (responseCode == 1) {
          throw Exception('Not enough questions available for this configuration. Please try a lower question count or different difficulty.');
        } else if (responseCode == 2) {
          throw Exception('Invalid parameters supplied to question API.');
        } else {
          throw Exception('OpenTDB API error code: $responseCode');
        }
      } else {
        throw Exception('Server error with status code: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timed out while fetching questions. Please try again.');
    } catch (e) {
      throw Exception('Unable to load questions: $e');
    }
  }
}
