import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/Model/productmodel.dart';
import 'package:shop/bloc/shop_bloc.dart'; // adjust path if needed
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}
class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  int selectedThumbnail = 0;
  int selectedColor = 0;
  String? selectedStorage;
  // ---------- Pink theme palette (visual only, matches the design) ----------
  static const Color pinkBackground = Color(0xFFF6C6D5);
  static const Color pinkPill = Color(0xFFFBE0E8);
  static const Color pinkButton = Color(0xFFFBC7D9);
  static const Color pinkAccent = Color(0xFFEE5A8A);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        final ProductModel? product = state.selectedProduct;

        if (product == null) {
          return const Scaffold(
            body: Center(child: Text('No product selected')),
          );
        }
        // set default storage the first time
        selectedStorage ??= product.storage.isNotEmpty
            ? product.storage[0]
            : null;
        // calculate price
        final double discountAmount = product.oldprice * product.discount / 100;
        final double newPrice = product.oldprice - discountAmount;
        return Scaffold(
          backgroundColor: pinkBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ---------- Top bar ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _circleIconButton(
                          Icons.arrow_back,
                          () => Navigator.pop(context),
                        ),
                        // Favorite logic kept exactly as-is; icon/style
                        // updated only to match the pink design (cart look).
                        _circleIconButton(
                          state.favorites.any((p) => p.code == product.code)
                              ? Icons.favorite
                              : Icons.shopping_cart_outlined,
                          () {
                            context.read<ShopBloc>().add(
                              ToggleFavorite(product),
                            );
                          },
                          color:
                              state.favorites.any((p) => p.code == product.code)
                              ? Colors.red
                              : Colors.black87,
                        ),
                      ],
                    ),
                  ),

                  // ---------- Main Image ----------
                  SizedBox(
                    height: 300,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      width: double.infinity,
                      child: Image.asset(
                        product.detail_item.isNotEmpty &&
                                selectedThumbnail < product.detail_item.length
                            ? product.detail_item[selectedThumbnail]
                            : product.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ---------- Thumbnails (detail_item) ----------
                  if (product.detail_item.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(product.detail_item.length, (
                          index,
                        ) {
                          final bool isSelected = selectedThumbnail == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedThumbnail = index);
                            },
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  product.detail_item[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // ---------- Name + Quantity pill ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.phone_iphone,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _qtyButton(Icons.remove, () {
                            if (quantity > 1) setState(() => quantity--);
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Text(
                              '$quantity',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _qtyButton(Icons.add, () {
                            setState(() => quantity++);
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ---------- Details (sit directly on the pink background) ----------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating + Views
                        Row(
                          children: [
                            Text(
                              product.rate,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.star,
                              size: 20,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${product.view})',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Price
                        Row(
                          children: [
                            Text(
                              '\$${product.oldprice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.black54,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '\$${newPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-${product.discount}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Storage + Colors
                        Row(
                          children: [
                            const Text(
                              'Storage',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedStorage,
                                  isDense: true,
                                  items: product.storage
                                      .map(
                                        (s) => DropdownMenuItem(
                                          value: s,
                                          child: Text(
                                            s,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => selectedStorage = value);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Colors',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 10),
                            ...List.generate(product.color.length, (index) {
                              final bool isSelected = selectedColor == index;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => selectedColor = index),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        Colors.primaries[index %
                                            Colors.primaries.length],
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.white,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // Specifications (from detail_sp)
                        const Text(
                          'Specifications',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            product.detail_sp.length > 4
                                ? 4
                                : product.detail_sp.length,
                            (index) {
                              return Expanded(
                                child: _SpecItem(
                                  icon: _getSpecIcon(index),
                                  title: product.detail_sp[index],
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------- Bottom Buttons ----------
          bottomNavigationBar: SafeArea(
            child: Container(
              color: pinkBackground,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // add to cart with current quantity
                        final productWithQty = ProductModel(
                          code: product.code,
                          name: product.name,
                          category: product.category,
                          oldprice: product.oldprice,
                          discount: product.discount,
                          image: product.image,
                          quantity: quantity,
                          rate: product.rate,
                          view: product.view,
                          description: product.description,
                          storage: product.storage,
                          color: product.color,
                          detail_item: product.detail_item,
                          detail_sp: product.detail_sp,
                        );
                        context.read<ShopBloc>().add(AddToCart(productWithQty));

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: pinkPill,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'add to cart',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Buy now logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Buy now clicked')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pinkButton,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Buy now',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  // ---------- Helpers ----------
  IconData _getSpecIcon(int index) {
    const icons = [
      Icons.memory,
      Icons.camera_alt_outlined,
      Icons.battery_charging_full,
      Icons.smartphone,
    ];
    return icons[index % icons.length];
  }

  Widget _circleIconButton(
    IconData icon,
    VoidCallback onTap, {
    Color color = Colors.black87,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26),
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }
}
// ---------- Spec Item Widget ----------
class _SpecItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SpecItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 22, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}