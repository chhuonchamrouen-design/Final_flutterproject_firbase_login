import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/mod/appcolor.dart';
import 'package:shop/bloc/shop_bloc.dart';
import 'package:shop/view/home/detailscreen.dart';

class Favaritescreen extends StatelessWidget {
  const Favaritescreen({super.key, this.onBack});

  /// Called when the back arrow is tapped (switches Mainhomepage to Home tab)
  final VoidCallback? onBack;

  static const Color badgeGreen = Color(0xFF3ECD5E);
  static const Color priceRed = Color(0xFFFF3B6B);
  static const Color starYellow = Color(0xFFFFC107);

  void _goHome(BuildContext context) {
    if (onBack != null) {
      onBack!(); // switch Mainhomepage to Home tab
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        final favorites = state.favorites;

        final Color pageBg = context.appPageBg;
        final Color textDark = context.appText;
        final Color muted = context.appMuted;

        return Scaffold(
          backgroundColor: pageBg,
          appBar: AppBar(
            backgroundColor: pageBg,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () => _goHome(context),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(Icons.arrow_back, color: textDark, size: 24),
              ),
            ),
            title: Text(
              'Save item(${favorites.length})',
              style: TextStyle(
                color: textDark,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
          body: favorites.isEmpty
              ? Center(
                  child: Text(
                    'No saved items yet',
                    style: TextStyle(color: muted, fontSize: 16),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
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
                            color: context.appSurface,
                            border:
                                Border.all(color: context.appStrongBorder),
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
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 1.2,
                                        color: textDark,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.star,
                                      color: starYellow, size: 16),
                                  const SizedBox(width: 2),
                                  Text(
                                    product.rate.toString(),
                                    style: TextStyle(
                                        fontSize: 14, color: textDark),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
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
                                    style: TextStyle(
                                      color: muted,
                                      fontSize: 12,
                                      decoration:
                                          TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
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
                                      size: 14),
                                  label: const Text(
                                    'Add to cart',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.appSurface,
                                    foregroundColor: textDark,
                                    elevation: 0,
                                    minimumSize: const Size(0, 34),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    side:
                                        BorderSide(color: context.appBorder),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: const StadiumBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
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
                        Positioned(
                          top: 2,
                          right: 2,
                          child: IconButton(
                            onPressed: () {
                              context
                                  .read<ShopBloc>()
                                  .add(ToggleFavorite(product));
                            },
                            icon: Icon(Icons.favorite_border,
                                color: muted, size: 24),
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