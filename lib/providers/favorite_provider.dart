import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class FavoriteProvider with ChangeNotifier {
  static const String _favoriteKey = 'favorite_products';
  List<Product> _favoriteProducts = [];

  List<Product> get favoriteProducts => _favoriteProducts;

  FavoriteProvider() {
    _loadFavorites();
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_favoriteKey) ?? [];
    // In a real app, you would fetch the product details from the API based on the IDs
    // For this example, we'll just store the full product data in another provider
    notifyListeners();
  }

  void toggleFavorite(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_favoriteKey) ?? [];

    if (favoriteIds.contains(product.id.toString())) {
      favoriteIds.remove(product.id.toString());
      _favoriteProducts.removeWhere((p) => p.id == product.id);
    } else {
      favoriteIds.add(product.id.toString());
      _favoriteProducts.add(product);
    }

    await prefs.setStringList(_favoriteKey, favoriteIds);
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favoriteProducts.any((p) => p.id == product.id);
  }
}
