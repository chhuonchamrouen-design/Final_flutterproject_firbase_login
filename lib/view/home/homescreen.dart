import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:shop/Model/productmodel.dart';
import 'package:shop/bloc/shop_bloc.dart';
import 'package:shop/view/home/detailscreen.dart';

const Color _pageBg = Color(0xFFFFFFFF); // page background (white)
const Color _cardBg = Color(0xFFEDEDED); // product card (light grey)
const Color _badgeBg = Color(0xFF3ECD5E); // discount badge (green)
const Color _priceColor = Color(0xFFFF3B6B); // sale price
const Color _seeAllBg = Color(0xFF3ECD5E); // "See all" pill (green)
const Color _chipSelectedBorder = Color(0xFF000000);
const Color _searchBorder = Color(0xFFE3E3E3);

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int selectedCategoryIndex = 0;
  static const List<String> _categoryImages = [
    '', // "All"
    'assets/image/apple.jpg',
    'assets/image/samsung.jpg',
    'assets/image/vivo.jpg',
    'assets/image/oppo.jpg',
    'assets/image/mi.jpg',
  ];
  static const List<String> _categoryLabels = [
    'All',
    'Iphone',
    'Samsung',
    'Vivo',
    'Oppo',
    'Mi',
  ];
  static const List<String> _bannerImages = [
    'assets/image/banneroppo.jpg',
    'assets/image/nn.png',
    'assets/image/xx.png',
  ];
  @override
  void initState() {
    super.initState();
    context.read<ShopBloc>().add(LoadProduct());
  }

  void _selectCategory(int index, String catImage) {
    setState(() => selectedCategoryIndex = index);
    context.read<ShopBloc>().add(
      FilterCategory(catImage.isEmpty ? 'All' : catImage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: _buildAppBar(),
      body: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          final products = state.filltercategory;

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildSearchBar(),
                _buildSlideshow(),
                _buildCategoryHeader(),
                _buildCategoryChips(),
                const SizedBox(height: 16),
                _buildProductGrid(products, state.favorites),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- App bar ----------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Phone shop',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      backgroundColor: _pageBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.black,
            size: 28,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ---------------- Search bar + avatar ----------------
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(color: _searchBorder),
              ),
              child: const TextField(
                style: TextStyle(fontSize: 17),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black54,
                    size: 26,
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Placeholder avatar – swap the child for Image.asset(...) if you have one.
          const CircleAvatar(
            radius: 23,
            backgroundColor: Color(0xFFF5D6C6),
            child: Icon(Icons.person, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ---------------- Slideshow ----------------
  Widget _buildSlideshow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ImageSlideshow(
            width: double.infinity,
            height: 180,
            initialPage: 0,
            indicatorColor: Colors.black,
            indicatorBackgroundColor: Colors.white,
            autoPlayInterval: 3000,
            isLoop: true,
            children: _bannerImages
                .map(
                  (path) => Image.asset(
                    path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  // ---------------- Category header + "See all" ----------------
  Widget _buildCategoryHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Category',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          GestureDetector(
            onTap: () => _selectCategory(0, ''),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _seeAllBg,
              ),
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ---------------- Category chips ----------------
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categoryImages.length,
        itemBuilder: (context, index) {
          final catImage = _categoryImages[index];
          final label = _categoryLabels[index];
          final bool isSelected = selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () => _selectCategory(index, catImage),
              child: isSelected
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                        color: Colors.white,
                        border: Border.all(
                          color: _chipSelectedBorder,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  // ---------------- Product grid ----------------
  Widget _buildProductGrid(
    List<ProductModel> products,
    List<ProductModel> favorites,
  ) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Text('No products found'),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.74,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _ProductCard(
            product: product,
            // compare by code, not object identity
            isFavorite: favorites.any((p) => p.code == product.code),
            onToggleFavorite: () =>
                context.read<ShopBloc>().add(ToggleFavorite(product)),
          );
        },
      ),
    );
  }
}
// ---------------- Product card ----------------
class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const _ProductCard({
    required this.product,
    required this.isFavorite,
    required this.onToggleFavorite,
  });
  void _openDetail(BuildContext context) {
    context.read<ShopBloc>().add(SelectProduct(product));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductDetailScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double oldPrice = product.oldprice.toDouble();
    final double discountPct = double.tryParse('${product.discount}') ?? 0;
    final double salePrice = oldPrice * (1 - discountPct / 100);
    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Hero(
                        tag: 'phone_${product.code}',
                        child: Image.asset(product.image, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _badgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '-${product.discount}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: GestureDetector(
                      onTap: onToggleFavorite,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 24,
                          color: isFavorite ? Colors.red : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Name + rating
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 2),
                Text(
                  product.rate,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Prices
            Row(
              children: [
                Text(
                  '\$${salePrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: _priceColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${oldPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Add to cart
            SizedBox(
              width: double.infinity,
              height: 34,
              child: ElevatedButton(
                onPressed: () => _openDetail(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  side: const BorderSide(color: Color(0xFFDADADA)),
                  shape: const StadiumBorder(),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 15),
                    SizedBox(width: 4),
                    Text(
                      'Add to cart',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
