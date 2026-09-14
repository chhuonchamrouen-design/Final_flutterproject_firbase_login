import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/Model/productmodel.dart';
import 'package:shop/bloc/shop_bloc.dart'; // adjust path if needed
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  // ---------- Pink theme palette (matches the rest of the app) ----------
  static const Color pinkBackground = Color(0xFFF6C6D5);
  static const Color pinkCard = Color(0xFFF9D2DE);
  static const Color pinkSummary = Color(0xFFFBC7D9);
  static const Color pinkButton = Color(0xFFF0AFC7);
  static const Color discountRed = Color(0xFFEE5A8A);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        final List<ProductModel> cartItems = state.cart;
        final double total = cartItems.fold(
          0,
          (sum, item) => sum + (item.oldprice * item.quantity),
        );
        // NOTE: delivery/discount are placeholders — wire these to your
        // real bloc/state values if you track them separately.
        const double delivery = 1.99;
        const double discount = 2.99;
        final double subtotal = total + delivery - discount;
        return Scaffold(
          backgroundColor: pinkBackground,
          body: SafeArea(
            child: Column(
              children: [
                // ---------- Top bar ----------
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'My Cart',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24), // balances the back icon
                    ],
                  ),
                ),

                // ---------- Cart items list ----------
                Expanded(
                  child: cartItems.isEmpty
                      ? const Center(
                          child: Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return _CartItemCard(
                              product: item,
                              cardColor: pinkCard,
                              onRemove: () {
                                context
                                    .read<ShopBloc>()
                                    .add(RemoveFromCart(item));
                              },
                              onIncrement: () {
                                context.read<ShopBloc>().add(
                                      UpdateCartQuantity(
                                        item,
                                        item.quantity + 1,
                                      ),
                                    );
                              },
                              onDecrement: () {
                                if (item.quantity > 1) {
                                  context.read<ShopBloc>().add(
                                        UpdateCartQuantity(
                                          item,
                                          item.quantity - 1,
                                        ),
                                      );
                                }
                              },
                            );
                          },
                        ),
                ),

                // ---------- Summary + Checkout ----------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  decoration: const BoxDecoration(
                    color: pinkSummary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _summaryRow('Total', '\$${total.toStringAsFixed(2)}'),
                      const SizedBox(height: 10),
                      _summaryRow(
                        'Delevary',
                        '\$${delivery.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 10),
                      _summaryRow(
                        'Discount',
                        '\$${discount.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: Colors.black26, height: 1),
                      const SizedBox(height: 14),
                      _summaryRow(
                        'Subtotal',
                        '\$${subtotal.toStringAsFixed(2)}',
                        valueColor: discountRed,
                        bold: true,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to checkout flow
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pinkButton,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: const Text(
                            'Go to Checkout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    Color valueColor = Colors.black,
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// ---------- Cart item card ----------
class _CartItemCard extends StatelessWidget {
  final ProductModel product;
  final Color cardColor;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItemCard({
    required this.product,
    required this.cardColor,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 72,
              height: 72,
              color: Colors.white,
              child: Image.asset(
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name / color / qty / price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Colors : ${product.color.isNotEmpty ? product.color[0] : '-'}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty ${product.quantity}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.oldprice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Remove (X) + stepper
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Icons.close, size: 18, color: Colors.black87),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _stepButton(Icons.remove, onDecrement),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${product.quantity}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _stepButton(Icons.add, onIncrement),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26),
        ),
        child: Icon(icon, size: 12, color: Colors.black87),
      ),
    );
  }
}