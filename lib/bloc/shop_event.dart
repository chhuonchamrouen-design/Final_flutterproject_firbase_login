part of 'shop_bloc.dart';
abstract class ShopEvent {}
//use for show all product 
class LoadProduct extends ShopEvent {}
//filter by this category
class FilterCategory extends ShopEvent {
  final String category;
  FilterCategory(this.category);
}
//use for select prodcut favarite
class ToggleFavorite extends ShopEvent {
  final ProductModel product;
  ToggleFavorite(this.product);
}