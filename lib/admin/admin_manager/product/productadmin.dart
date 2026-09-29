import 'package:flutter/material.dart';

class Productadmin extends StatefulWidget {
  const Productadmin({super.key});

  @override
  State<Productadmin> createState() => _ProductadminState();
}

class _ProductadminState extends State<Productadmin> {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Premium Cotton T-Shirt',
      'stock': 42,
      'image': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=200',
    },
    {
      'name': 'Classic Denim Jeans',
      'stock': 28,
      'image': 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=200',
    },
    {
      'name': 'Leather Sneakers',
      'stock': 15,
      'image': 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=200',
    },
    {
      'name': 'Wool Sweater',
      'stock': 7,
      'image': 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=200',
    },
    {
      'name': 'Running Shoes',
      'stock': 22,
      'image': 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=200',
    },
    {
      'name': 'Designer Sunglasses',
      'stock': 16,
      'image': 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=200',
    },
    {
      'name': 'Winter Coat',
      'stock': 9,
      'image': 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=200',
    },
  ];

  final List<String> categories = [
    'All',
    'Clothing',
    'Footwear',
    'Accessories',
    'Low Stock',
  ];

  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Products',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black, size: 26),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ===== Search Bar =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                filled: true,
                fillColor: const Color(0xFFF0F4F8),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ===== Category Chips =====
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = selectedCategory == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : const Color(0xFFF0F4F8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // ===== Product List =====
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final product = products[index];
                final isLowStock = product['stock'] < 10;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product['image'],
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                  title: Text(
                    product['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isLowStock ? Colors.red : Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${product['stock']} in stock',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
      // ===== Add Product Button =====
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF2196F3),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Product',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}