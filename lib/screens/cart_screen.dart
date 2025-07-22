import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart'; // Import Product model

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: cart.cartItems.isEmpty
          ? _buildEmptyCartState(context)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.cartItems.length,
                    itemBuilder: (ctx, index) {
                      final product = cart.cartItems.keys.elementAt(index);
                      final quantity = cart.cartItems.values.elementAt(index);
                      return CartItemCard(
                        product: product,
                      );
                    },
                  ),
                ),
                _buildOrderSummary(context, cart),
                _buildCheckoutOptions(context, cart),
              ],
            ),
    );
  }

  Widget _buildEmptyCartState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          const Text(
            'Your cart is empty!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Looks like you haven\'t added anything to your cart yet.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop(); // Go back to previous screen (e.g., home)
            },
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Continue Shopping'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartProvider cart) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildSummaryRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
            _buildSummaryRow('Taxes (10%)', '\$${cart.tax.toStringAsFixed(2)}'),
            _buildSummaryRow('Shipping', cart.shippingCost > 0 ? '\$${cart.shippingCost.toStringAsFixed(2)}' : 'Calculated at checkout'),
            const Divider(),
            _buildSummaryRow('Total', '\$${cart.totalPrice.toStringAsFixed(2)}', isTotal: true),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.lock, size: 16, color: Colors.green[700]),
                const SizedBox(width: 5),
                Text(
                  'Secure Checkout',
                  style: TextStyle(color: Colors.green[700], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutOptions(BuildContext context, CartProvider cart) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: cart.cartItems.isEmpty ? null : () {
                // Implement checkout logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Proceeding to Checkout!'))
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Optional: Add other payment options like PayPal, Apple Pay, Google Pay
          // Example:
          // OutlinedButton(
          //   onPressed: () {},
          //   child: Text('Checkout with PayPal'),
          // ),
        ],
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final Product product;

  const CartItemCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final quantity = cart.cartItems[product] ?? 0;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced margin
          child: Padding(
            padding: const EdgeInsets.all(4), // Reduced padding
            child: Row(
              children: [
                // Product Image
                SizedBox(
                  width: 100, // Increased width
                  height: 100, // Increased height
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Reduced spacing
                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4), // Reduced spacing
                      Text(
                        'Price: ৳${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                  Text(
                    'Total: ৳${(product.price * quantity).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 4), // Reduced spacing
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              cart.decreaseQuantity(product);
                            },
                          ),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              cart.increaseQuantity(product);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Remove Button
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    cart.removeFromCart(product);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}