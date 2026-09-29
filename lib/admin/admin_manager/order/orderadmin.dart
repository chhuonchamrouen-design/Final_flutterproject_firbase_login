import 'package:flutter/material.dart';

class Orderadmin extends StatefulWidget {
  const Orderadmin({super.key});

  @override
  State<Orderadmin> createState() => _OrderadminState();
}

class _OrderadminState extends State<Orderadmin> {
  final List<Map<String, dynamic>> orders = [
    {
      'id': 'Order ID',
      'date': 'Feb. 14',
      'name': 'Juancho Pedro',
      'amount': '₱790.00',
      'status1': 'Awaiting Payment',
      'status1Color': const Color(0xFFFFF3CD),
      'status1TextColor': const Color(0xFF856404),
      'status2': 'For Pickup at 10:20am',
      'status2Color': const Color(0xFFFFF3CD),
      'status2TextColor': const Color(0xFF856404),
      'avatarColor': Colors.orange,
    },
    {
      'id': 'Order ID',
      'date': 'Feb. 11',
      'name': 'William Pella',
      'amount': '₱270.00',
      'status1': 'Paid',
      'status1Color': const Color(0xFFD4EDDA),
      'status1TextColor': const Color(0xFF155724),
      'status2': 'Processing',
      'status2Color': const Color(0xFFCCE5FF),
      'status2TextColor': const Color(0xFF004085),
      'avatarColor': Colors.brown,
    },
    {
      'id': 'Order ID',
      'date': 'Feb. 11',
      'name': 'Jenna Cat',
      'amount': '₱120.00',
      'status1': 'Refunded',
      'status1Color': const Color(0xFFF8D7DA),
      'status1TextColor': const Color(0xFF721C24),
      'status2': 'Delivery Cancelled',
      'status2Color': const Color(0xFFF8D7DA),
      'status2TextColor': const Color(0xFF721C24),
      'avatarColor': Colors.pink,
    },
    {
      'id': 'Order ID',
      'date': 'Feb. 10',
      'name': 'Tiffany Irinade',
      'amount': '₱559.00',
      'status1': 'Paid',
      'status1Color': const Color(0xFFD4EDDA),
      'status1TextColor': const Color(0xFF155724),
      'status2': 'Out for Delivery',
      'status2Color': const Color(0xFFD4EDDA),
      'status2TextColor': const Color(0xFF155724),
      'avatarColor': Colors.green,
    },
    {
      'id': 'Order ID',
      'date': 'Feb. 09',
      'name': 'Billy Bobby Brown',
      'amount': '₱1,000.00',
      'status1': 'Paid',
      'status1Color': const Color(0xFFD4EDDA),
      'status1TextColor': const Color(0xFF155724),
      'status2': 'Processing',
      'status2Color': const Color(0xFFCCE5FF),
      'status2TextColor': const Color(0xFF004085),
      'avatarColor': Colors.blueGrey,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Orders',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Order ID + Date + Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order['id']}  ${order['date']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      order['amount'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Customer + Status badges
                Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: order['avatarColor'],
                      child: Text(
                        order['name'][0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Name + Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['name'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _buildStatusChip(
                                order['status1'],
                                order['status1Color'],
                                order['status1TextColor'],
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: _buildStatusChip(
                                  order['status2'],
                                  order['status2Color'],
                                  order['status2TextColor'],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),

      // ===== Bottom Navigation =====
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Products',
          ),
        ],
        onTap: (index) {
          // TODO: navigate between Orders / Products
        },
      ),
    );
  }

  Widget _buildStatusChip(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}