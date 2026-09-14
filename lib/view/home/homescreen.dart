import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:shop/Model/productmodel.dart';
import 'package:shop/bloc/shop_bloc.dart';
import 'package:shop/view/home/detailscreen.dart';

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
    'Apple',
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
                const SizedBox(height: 15),
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
        'Shop Sports',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      actions: const [Icon(Icons.shopping_cart_outlined), SizedBox(width: 10)],
    );
  }

  // ---------------- Search bar ----------------

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          border: Border.all(color: Colors.grey),
        ),
        child: const TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  // ---------------- Slideshow ----------------

  Widget _buildSlideshow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ImageSlideshow(
          width: double.infinity,
          height: 210,
          initialPage: 0,
          indicatorColor: Colors.blue,
          indicatorBackgroundColor: Colors.grey,
          autoPlayInterval: 3000,
          isLoop: true,
          children: _bannerImages
              .map((path) => Image.asset(path, fit: BoxFit.cover))
              .toList(),
        ),
      ),
    );
  }

  // ---------------- Category header + "See all" ----------------

  Widget _buildCategoryHeader() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          GestureDetector(
            onTap: () => _selectCategory(0, ''),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green),
              ),
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
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
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: _categoryImages.length,
        itemBuilder: (context, index) {
          final catImage = _categoryImages[index];
          final label = _categoryLabels[index];
          final bool isSelected = selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _selectCategory(index, catImage),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: isSelected ? Colors.black : Colors.white,
                  border: isSelected
                      ? null
                      : Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _ProductCard(
            product: product,
            isFavorite: favorites.contains(product),
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    product.image,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(product.rate),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Text(
                        '\$${product.oldprice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                        ),
                        child: IconButton(
                          onPressed: () {
                            // 1. Select the product first
                            context.read<ShopBloc>().add(
                              SelectProduct(product),
                            ); // ← your ProductModel

                            // 2. Go to Detail Screen
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: onToggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${product.discount}%',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
