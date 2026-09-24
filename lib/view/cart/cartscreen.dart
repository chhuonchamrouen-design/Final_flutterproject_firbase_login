import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/Model/productmodel.dart';
import 'package:shop/bloc/shop_bloc.dart'; // adjust path if needed
import 'package:shop/view/home/checkoutscreen.dart'; // adjust to your CheckoutScreen file path

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  // ---------- White/green theme palette (matches the rest of the app) ----------
  static const Color pageBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFECECEC);
  static const Color summaryBackground = Color(0xFFFFFFFF);
  static const Color checkoutButton = Color(0xFF3ECD5E);
  static const Color discountRed = Color(0xFFFF3B6B);

  // ---------- Go back to the home screen ----------
  // Pops every screen until the first route (your home screen).
  // If home is NOT the first route in your app, replace this with:
  // Navigator.pushAndRemoveUntil(
  //   context,
  //   MaterialPageRoute(builder: (_) => const HomeScreen()),
  //   (route) => false,
  // );
  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  // ---------- "Are you sure?" bottom sheet ----------
  void _confirmDelete(BuildContext context, ProductModel item) {
    final bloc = context.read<ShopBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Icon(Icons.delete_outline, size: 40, color: discountRed),
                const SizedBox(height: 12),
                const Text(
                  'Are you sure you want to delete this item?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.black26),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Delete
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          bloc.add(RemoveFromCart(item));
                          Navigator.pop(sheetContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: discountRed,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
          backgroundColor: pageBackground,
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
                        onTap: () => _goHome(context),
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
                      const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.black,
                        size: 28,
                      ),
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
                              cardColor: Colors.white,
                              // X icon -> ask first, then delete
                              onRemove: () => _confirmDelete(context, item),
                              onIncrement: () {
                                context.read<ShopBloc>().add(
                                  UpdateCartQuantity(item, item.quantity + 1),
                                );
                              },
                              onDecrement: () {
                                if (item.quantity > 1) {
                                  context.read<ShopBloc>().add(
                                    UpdateCartQuantity(item, item.quantity - 1),
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
                    color: summaryBackground,
                    border: Border(
                      top: BorderSide(color: cardBorder, width: 1),
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
                      const Divider(color: Colors.black12, height: 1),
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
                          onPressed: cartItems.isEmpty
                              ? null
                              : () {
                                  final bloc = context.read<ShopBloc>();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: bloc,
                                        child: const CheckoutScreen(),
                                      ),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: checkoutButton,
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
                              color: Colors.white,
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
        border: Border.all(color: CartScreen.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 82,
              height: 82,
              child: Image.asset(
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name row (with X), color, qty, and price/stepper row
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // full color name (was product.color[0] = first letter only)
                Text(
                  'Colors : ${product.color.isNotEmpty ? product.color : '-'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.oldprice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black26),
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
        alignment: Alignment.center,
        child: Icon(icon, size: 14, color: Colors.black87),
      ),
    );
  }
}
