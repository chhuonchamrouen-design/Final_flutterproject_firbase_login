import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/Model/productmodel.dart';
import 'package:shop/bloc/shop_bloc.dart'; // adjust path if needed

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}
class _CheckoutScreenState extends State<CheckoutScreen> {
  // ---------- palette (same as cart) ----------
  static const Color pageBackground = Color(0xFFFFFFFF);
  static const Color rowBorder = Color(0xFFE6E6E6);
  static const Color greenButton = Color(0xFF3ECD5E);
  static const Color errorRed = Color(0xFFFF3B6B);

  // ---------- options (edit these lists to add more) ----------
  static const List<String> _locations = [
    'Phnom Penh',
    'Siem Reap',
    'Battambang',
    'Sihanoukville',
    'Kampot',
  ];

  static const List<_Option> _deliveries = [
    _Option(
      title: 'J&T Express',
      subtitle: '1-2 Day',
      badge: 'J&T',
      color: Color(0xFFE60012),
      rounded: false,
    ),
    _Option(
      title: 'Standard delivery',
      subtitle: '3-5 Day',
      icon: Icons.local_shipping_outlined,
      color: Color(0xFF546E7A),
    ),
    _Option(
      title: 'Store pickup',
      subtitle: 'Same day',
      icon: Icons.storefront_outlined,
      color: Color(0xFF3ECD5E),
    ),
  ];

  static const List<_Option> _payments = [
    _Option(title: 'ABA', badge: 'ABA', color: Color(0xFF005E7B)),
    _Option(title: 'ACLEDA', badge: 'AC', color: Color(0xFF1B4F9C)),
    _Option(title: 'Wing', badge: 'W', color: Color(0xFF7AC143)),
    _Option(
      title: 'Cash on delivery',
      icon: Icons.payments_outlined,
      color: Color(0xFF546E7A),
    ),
  ];

  String _location = 'Phnom Penh';
  int _delivery = 0;
  int _payment = 0;
  final TextEditingController _contactCtrl = TextEditingController();
  String? _contactError;

  @override
  void dispose() {
    _contactCtrl.dispose();
    super.dispose();
  }

  // ---------- generic "Change" bottom sheet ----------
  Future<void> _pick({
    required String title,
    required int selected,
    required List<_Option> options,
    required ValueChanged<int> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(options.length, (i) {
                final o = options[i];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: _leading(o),
                  title: Text(
                    o.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: o.subtitle == null ? null : Text(o.subtitle!),
                  trailing: Icon(
                    i == selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: i == selected ? greenButton : Colors.black38,
                  ),
                  onTap: () {
                    onSelected(i);
                    Navigator.pop(sheetContext);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _pickLocation() {
    _pick(
      title: 'Delivery location',
      selected: _locations.indexOf(_location),
      options: _locations
          .map(
            (l) => _Option(
              title: l,
              icon: Icons.location_on_outlined,
              color: Colors.black87,
            ),
          )
          .toList(),
      onSelected: (i) => setState(() => _location = _locations[i]),
    );
  }

  // ---------- Confirm order ----------
  void _confirm(BuildContext context, List<ProductModel> items) {
    if (_contactCtrl.text.trim().isEmpty) {
      setState(() => _contactError = 'Please enter your phone or Telegram');
      return;
    }
    setState(() => _contactError = null);

    final bloc = context.read<ShopBloc>();
    // clear the cart (no ClearCart event in the bloc, remove each item)
    for (final item in items) {
      bloc.add(RemoveFromCart(item));
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const CircleAvatar(
              radius: 32,
              backgroundColor: greenButton,
              child: Icon(Icons.check, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 16),
            const Text(
              'Order placed!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Thank you for your order.\nWe will contact you soon.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenButton,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Back to home',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        final List<ProductModel> items = state.cart;
        final double total = items.fold(
          0,
          (sum, p) => sum + (p.oldprice * p.quantity),
        );

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
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Checkout (${items.length})',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 30), // balances the back icon
                    ],
                  ),
                ),

                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ---------- Summary order ----------
                              _label('Summary order'),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 138,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: items.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 10),
                                  itemBuilder: (_, i) => _summaryCard(items[i]),
                                ),
                              ),

                              // ---------- Delivery location ----------
                              const SizedBox(height: 20),
                              _label('Delivery Location'),
                              const SizedBox(height: 8),
                              _row(
                                leading: const Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                title: _location,
                                onChange: _pickLocation,
                              ),

                              // ---------- Method of delivery ----------
                              const SizedBox(height: 20),
                              _label('Method of Delivery'),
                              const SizedBox(height: 8),
                              _row(
                                leading: _leading(_deliveries[_delivery]),
                                title: _location,
                                subtitle: _deliveries[_delivery].subtitle,
                                onChange: () => _pick(
                                  title: 'Method of delivery',
                                  selected: _delivery,
                                  options: _deliveries,
                                  onSelected: (i) =>
                                      setState(() => _delivery = i),
                                ),
                              ),

                              // ---------- Preferred contact line ----------
                              const SizedBox(height: 20),
                              _label('Preferred Contact Line'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _contactCtrl,
                                keyboardType: TextInputType.text,
                                onChanged: (_) {
                                  if (_contactError != null) {
                                    setState(() => _contactError = null);
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Phone number or Telegram',
                                  hintStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black38,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.phone_outlined,
                                    size: 20,
                                    color: Colors.black54,
                                  ),
                                  errorText: _contactError,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: rowBorder,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: greenButton,
                                      width: 1.5,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: errorRed,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: errorRed,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),

                              // ---------- Payment method ----------
                              const SizedBox(height: 20),
                              _label('Payment Method'),
                              const SizedBox(height: 8),
                              _row(
                                leading: _leading(_payments[_payment]),
                                title: _payments[_payment].title,
                                onChange: () => _pick(
                                  title: 'Payment method',
                                  selected: _payment,
                                  options: _payments,
                                  onSelected: (i) =>
                                      setState(() => _payment = i),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),

                // ---------- Confirm button ----------
                if (items.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(48, 8, 48, 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => _confirm(context, items),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenButton,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                        child: Text(
                          'Confirm Order \$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------- Widgets ----------
  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  // Small product card in the horizontal "Summary order" list
  Widget _summaryCard(ProductModel p) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: rowBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 58,
            width: double.infinity,
            child: Image.asset(
              p.image,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            p.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          Text(
            'colors: ${p.color.isNotEmpty ? p.color : '-'}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11),
          ),
          Text('Qty: ${p.quantity}', style: const TextStyle(fontSize: 11)),
          Text(
            'Price: \$${p.oldprice.toStringAsFixed(2)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  // Bordered row with "Change" on the right
  Widget _row({
    required Widget leading,
    required String title,
    String? subtitle,
    required VoidCallback onChange,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: rowBorder),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onChange,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Text('Change', style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  // Logo-style badge (J&T, ABA...) or icon for an option
  Widget _leading(_Option o) {
    if (o.badge != null) {
      return Container(
        width: o.rounded ? 30 : 34,
        height: o.rounded ? 30 : 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: o.color,
          shape: o.rounded ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: o.rounded ? null : BorderRadius.circular(4),
        ),
        child: Text(
          o.badge!,
          style: TextStyle(
            color: Colors.white,
            fontSize: o.rounded ? 9 : 11,
            fontWeight: FontWeight.w800,
            fontStyle: o.rounded ? FontStyle.normal : FontStyle.italic,
          ),
        ),
      );
    }
    return SizedBox(
      width: 30,
      child: Icon(o.icon ?? Icons.circle, color: o.color, size: 22),
    );
  }
}
class _Option {
  final String title;
  final String? subtitle;
  final String? badge; // short text logo
  final IconData? icon;
  final Color color;
  final bool rounded; // true = circle badge (ABA), false = square (J&T)
  const _Option({
    required this.title,
    this.subtitle,
    this.badge,
    this.icon,
    this.color = Colors.black87,
    this.rounded = true,
  });
}