import 'package:shop/Model/productmodel.dart';

enum OrderStatus { placed, processing, delivered, cancelled }

class OrderModel {
  final String id;
  final List<ProductModel> items;
  final double total;
  final String deliveryMethod;
  final String paymentMethod;
  final String address;
  final String contact;
  final DateTime placedAt;
  final OrderStatus status;

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.deliveryMethod,
    required this.paymentMethod,
    required this.address,
    required this.contact,
    required this.placedAt,
    this.status = OrderStatus.placed,
  });

  int get itemCount => items.fold(0, (sum, p) => sum + p.quantity);
}