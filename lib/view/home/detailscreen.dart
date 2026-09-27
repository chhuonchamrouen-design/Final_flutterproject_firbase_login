import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/Model/productmodel.dart';
import 'package:shop/bloc/shop_bloc.dart'; // adjust path if needed
import 'package:shop/view/cart/cartscreen.dart'; // adjust to your CartScreen file path
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}
class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  int selectedIndex = 0;
  static const Color greyBackground = Color(0xFFFFFFFF);
  static const Color greyPill = Color(0xFFEDEDED);
  static const Color greenButton = Color(0xFF3ECD5E);
  static const Color greenAccent = Color(0xFF3ECD5E);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      buildWhen: (previous, current) => current.selectedProduct != null,
      builder: (context, state) {
        final ProductModel? product = state.selectedProduct;
        if (product == null) {
          return const Scaffold(
            body: Center(child: Text('No product selected')),
          );
        }
        final bool isFavorite = state.favorites.any(
          (p) => p.code == product.code,
        );
        final List<String> allImages = [product.image, ...product.detail_item];
        final int currentIndex = selectedIndex < allImages.length
            ? selectedIndex
            : 0;
        final String mainImage = allImages[currentIndex];
        final double discountAmount = product.oldprice * product.discount / 100;
        final double newPrice = product.oldprice - discountAmount;

        void goToImage(int index) {
          setState(() => selectedIndex = index);
        }
        return Scaffold(
          backgroundColor: greyBackground,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _circleIconButton(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              () => context.read<ShopBloc>().add(
                                ToggleFavorite(product),
                              ),
                              color: isFavorite ? Colors.red : Colors.black87,
                            ),
                            const SizedBox(width: 4),
                            _cartButton(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // ---------- Main image with arrows (radius 20) ----------
                  SizedBox(
                    height: 280,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Hero(
                                tag: 'phone_${product.code}',
                                child: Image.asset(
                                  mainImage,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 60,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (currentIndex > 0)
                            Positioned(
                              left: 8,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: _arrowButton(
                                  Icons.arrow_back_ios_new,
                                  () => goToImage(currentIndex - 1),
                                ),
                              ),
                            ),
                          if (currentIndex < allImages.length - 1)
                            Positioned(
                              right: 8,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: _arrowButton(
                                  Icons.arrow_forward_ios,
                                  () => goToImage(currentIndex + 1),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ---------- Thumbnails ----------
                  if (allImages.length > 1)
                    SizedBox(
                      height: 64,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 2,
                        ),
                        itemCount: allImages.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final bool isSelected = currentIndex == index;
                          return GestureDetector(
                            onTap: () => goToImage(index),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? greenAccent
                                      : const Color(0xFFE3E3E3),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.asset(
                                  allImages[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 20),

                  // ---------- Bottom card ----------
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: greyPill,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + Quantity
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 13,
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.apple,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _qtyButton(Icons.remove, () {
                                    if (quantity > 1) {
                                      setState(() => quantity--);
                                    }
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
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
                          ],
                        ),
                        const SizedBox(height: 12),

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
                              Icons.star_border,
                              size: 20,
                              color: Colors.black87,
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

                        // ---------- Storage + Color ----------
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
                            _valueChip(product.storage),
                            const SizedBox(width: 16),
                            Text(
                              'colors: ${product.color}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
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

                        // ---------- Description (expandable) ----------
                        _ExpandableDescription(
                          description: product.description,
                        ),

                        const SizedBox(height: 22),
                        // ---------- Category you may like ----------
                        _YouMayLikeSection(currentProduct: product),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ---------- Bottom Buttons ----------
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              color: greyPill,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _addToCart(context, product);
                        _showSnack(context, 'Added to cart');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenButton,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'add to cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _addToCart(context, product);
                        _buyNow(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenButton,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Buy now',
                        style: TextStyle(
                          color: Colors.white,
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

  // ---------- Bloc actions ----------
  void _addToCart(BuildContext context, ProductModel product) {
    context.read<ShopBloc>().add(
      AddToCart(product.copyWith(quantity: quantity)),
    );
    setState(() => quantity = 1);
  }

  Widget _cartButton(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      buildWhen: (previous, current) => previous.cart != current.cart,
      builder: (context, state) {
        final int count = state.cart.map((p) => p.name).toSet().length;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _circleIconButton(
              Icons.shopping_cart_outlined,
              () => _openCart(context),
            ),
            if (count > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: greenAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _openCart(BuildContext context) {
    final bloc = context.read<ShopBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BlocProvider.value(value: bloc, child: const CartScreen()),
      ),
    );
  }

  void _buyNow(BuildContext context) {
    final bloc = context.read<ShopBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BlocProvider.value(value: bloc, child: const CartScreen()),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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

  Widget _valueChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
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
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: Color(0xCCFFFFFF),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
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

// ---------- Expandable Description Widget ----------
class _ExpandableDescription extends StatefulWidget {
  final String description;
  const _ExpandableDescription({required this.description});

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),

        // Body + Read more toggle
        LayoutBuilder(
          builder: (context, constraints) {
            final textSpan = TextSpan(
              text: widget.description,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.45,
              ),
            );

            final textPainter = TextPainter(
              text: textSpan,
              maxLines: 3,
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: constraints.maxWidth);
            final isOverflowing = textPainter.didExceedMaxLines;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.description,
                  maxLines: _isExpanded ? null : 3,
                  overflow: _isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.45,
                  ),
                ),

                // 👇 Read more / Read less aligned to the RIGHT
                if (isOverflowing)
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _isExpanded ? 'Read less' : 'Read more',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              _isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ---------- Product "You May Like" Section ----------
class _YouMayLikeSection extends StatelessWidget {
  final ProductModel currentProduct;
  const _YouMayLikeSection({required this.currentProduct});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      buildWhen: (previous, current) =>
          previous.allproduct != current.allproduct,
      builder: (context, state) {
        final related = state.allproduct
            .where(
              (p) =>
                  p.category == currentProduct.category &&
                  p.code != currentProduct.code,
            )
            .toList();
        if (related.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category you may like',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 82,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: related.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = related[index];
                  final double newPrice =
                      item.oldprice - (item.oldprice * item.discount / 100);
                  return GestureDetector(
                    onTap: () {
                      context.read<ShopBloc>().add(SelectProduct(item));
                    },
                    child: Container(
                      width: 240,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              item.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${newPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.read<ShopBloc>().add(
                                AddToCart(item.copyWith(quantity: 1)),
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text('Added to cart'),
                                  ),
                                );
                            },
                            child: IconButton(
                              onPressed: () {
                                context.read<ShopBloc>().add(
                                  SelectProduct(item),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<ShopBloc>(),
                                      child: const ProductDetailScreen(),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.shopping_cart,
                                size: 20,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
