import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/utils.dart';
import 'package:shop/Mainhomepage.dart';
import 'package:shop/bloc/shop_bloc.dart';
import 'package:shop/view/home/detailscreen.dart';
import 'package:shop/view/home/homescreen.dart';

class Favaritescreen extends StatelessWidget {
  const Favaritescreen({super.key});
  static const Color pageBackground = Color(0xFFFFFFFF);
  static const Color cardGrey = Color(0xFFEDEDED);
  static const Color badgeGreen = Color(0xFF3ECD5E);
  static const Color priceRed = Color(0xFFFF3B6B);
  static const Color oldPriceGrey = Color(0xFF6B6B6B);
  static const Color starYellow = Color(0xFFFFC107);
  static const Color textDark = Color(0xFF1C1C1C);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        final favorites = state.favorites;
        return Scaffold(
          backgroundColor: pageBackground,
          appBar: AppBar(
            backgroundColor: pageBackground,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: IconButton(
              //onPressed: () => Navigator.pop(context),
              onPressed: () => Get.offAll(() => const Mainhomepage()),
              icon: const Icon(Icons.arrow_back, color: textDark, size: 28),
            ),
            title: Text(
              'Save item(${favorites.length})',
              style: const TextStyle(
                color: textDark,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none,
                  color: textDark,
                  size: 28,
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: favorites.isEmpty
              ? const Center(
                  child: Text(
                    'No saved items yet',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 250,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final product = favorites[index];
                    final num discount =
                        num.tryParse(product.discount.toString()) ?? 0;
                    final num originalPrice = product.oldprice;
                    final num currentPrice =
                        originalPrice * (100 - discount) / 100;
                    return Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                            color: cardGrey,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Image.asset(
                                    product.image,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.2,
                                        color: textDark,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.star,
                                    color: starYellow,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    product.rate.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: textDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // Prices
                              Row(
                                children: [
                                  Text(
                                    '\$${currentPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: priceRed,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '\$${originalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: oldPriceGrey,
                                      fontSize: 12,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Add to cart
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ProductDetailScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 14,
                                  ),
                                  label: const Text(
                                    'Add to cart',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: textDark,
                                    elevation: 0,
                                    minimumSize: const Size(0, 34),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xFFDADADA),
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: const StadiumBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Discount badge
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: badgeGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '-${product.discount}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),

                        // Heart (tap to remove from saved items)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: IconButton(
                            onPressed: () {
                              context.read<ShopBloc>().add(
                                ToggleFavorite(product),
                              );
                            },
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.black54,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        );
      },
    );
  }
}