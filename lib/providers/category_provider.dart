import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasCategories => _categories.isNotEmpty;

  /// Fetch categories with in-memory session caching
  Future<void> fetchCategories({bool forceRefresh = false}) async {
    // Session Caching: If categories are already loaded, skip API call
    if (_categories.isNotEmpty && !forceRefresh) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await ApiService.fetchCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Retry fetching categories if previous attempt failed
  Future<void> retryFetch() async {
    await fetchCategories(forceRefresh: true);
  }
}
