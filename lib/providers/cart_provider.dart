import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<Product, int> _cartItems = {};

  Map<Product, int> get cartItems => _cartItems;

  void addToCart(Product product) {
    if (_cartItems.containsKey(product)) {
      _cartItems[product] = _cartItems[product]! + 1;
    } else {
      _cartItems[product] = 1;
    }
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    if (_cartItems.containsKey(product)) {
      _cartItems[product] = _cartItems[product]! + 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(Product product) {
    if (_cartItems.containsKey(product)) {
      if (_cartItems[product]! > 1) {
        _cartItems[product] = _cartItems[product]! - 1;
      } else {
        _cartItems.remove(product);
      }
      notifyListeners();
    }
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get subtotal {
    return _cartItems.entries.fold(0.0, (total, entry) => total + (entry.key.price * entry.value));
  }

  double get tax => subtotal * 0.10; // Example 10% tax
  double get shippingCost => subtotal > 0 ? 5.00 : 0.00; // Example fixed shipping cost if there are items

  double get totalPrice {
    return subtotal + tax + shippingCost;
  }
}