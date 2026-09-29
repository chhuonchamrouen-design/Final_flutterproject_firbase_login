import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/Model/ordermodel.dart';
import 'package:shop/mod/appcolor.dart';
import 'package:shop/bloc/shop_bloc.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key, this.onBack});

  /// Called when the back arrow is tapped (switches Mainhomepage to Home tab)
  final VoidCallback? onBack;

  static const Color greenButton = Color(0xFF3ECD5E);
  static const Color priceRed = Color(0xFFFF3B30);

  void _goHome(BuildContext context) {
    if (onBack != null) {
      onBack!();
    } else {
      Navigator.of(context).maybePop(); // fallback if opened as a pushed page
    }
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} $hour12:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        final List<OrderModel> orders = state.orders;
        return Scaffold(
          backgroundColor: context.appPageBg,
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
                      // Plain back arrow, no border
                      GestureDetector(
                        onTap: () => _goHome(context),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.arrow_back,
                            color: context.appText,
                            size: 24,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'History Order',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: context.appText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 36), // balances the arrow width
                    ],
                  ),
                ),

                // ---------- Orders list / empty state ----------
                Expanded(
                  child: orders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 56,
                                color: context.appText.withAlpha(60),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No orders yet',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: context.appMuted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Orders you place will show up here.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: context.appText.withAlpha(100),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return _OrderCard(
                              order: orders[index],
                              cardBorder: context.appBorder,
                              priceRed: priceRed,
                              formatDate: _formatDate,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final Color cardBorder;
  final Color priceRed;
  final String Function(DateTime) formatDate;

  const _OrderCard({
    required this.order,
    required this.cardBorder,
    required this.priceRed,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final displayName = firstItem?.name ?? 'Order';
    final bold = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: context.appText,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Product image ----------
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: firstItem != null
                      ? Image.asset(
                          firstItem.image,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        )
                      : const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                ),
              ),
              const SizedBox(width: 14),
              // ---------- Order details ----------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'order #${order.id.length >= 6 ? order.id.substring(order.id.length - 6) : order.id}',
                      style: bold,
                    ),
                    const SizedBox(height: 2),
                    Text(formatDate(order.placedAt), style: bold),
                    const SizedBox(height: 2),
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bold,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${order.itemCount} item${order.itemCount == 1 ? '' : 's'}',
                      style: bold,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: context.appBorder, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${order.deliveryMethod} · ${order.paymentMethod}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: context.appText,
                  ),
                ),
              ),
              Text(
                '\$ ${order.total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: priceRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}