import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  List<String> _categories = [];
  String? _selectedCategory;
  String? _sortBy;

  List<Product> get products => _products;
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  String? get sortBy => _sortBy;

  Future<void> fetchProducts({String? category, String? sortBy}) async {
    try {
      _products = await _apiService.getProducts(category: category, sortBy: sortBy);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchCategories() async {
    try {
      _categories = await _apiService.getCategories();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    fetchProducts(category: _selectedCategory, sortBy: _sortBy);
  }

  void setSortBy(String? sortBy) {
    _sortBy = sortBy;
    fetchProducts(category: _selectedCategory, sortBy: _sortBy);
  }
}
