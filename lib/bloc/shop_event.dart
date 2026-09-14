part of 'shop_bloc.dart';

abstract class ShopEvent {}

// load all products
class LoadProduct extends ShopEvent {}

// filter by category
class FilterCategory extends ShopEvent {
  final String category;
  FilterCategory(this.category);
}

// toggle favorite
class ToggleFavorite extends ShopEvent {
  final ProductModel product;
  ToggleFavorite(this.product);
}

// ========== NEW EVENTS ==========

// select product for Detail Screen
class SelectProduct extends ShopEvent {
  final ProductModel product;
  SelectProduct(this.product);
}

// clear selected product (optional)
class ClearSelectedProduct extends ShopEvent {}

// add to cart
class AddToCart extends ShopEvent {
  final ProductModel product;
  AddToCart(this.product);
}

// remove from cart
class RemoveFromCart extends ShopEvent {
  final ProductModel product;
  RemoveFromCart(this.product);
}

// increase / decrease quantity of a product in cart
class UpdateCartQuantity extends ShopEvent {
  final ProductModel product;
  final int quantity;
  UpdateCartQuantity(this.product, this.quantity);
}