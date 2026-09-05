part of 'shop_bloc.dart';

class ShopState {
  final List<ProductModel> allproduct;
  final List<ProductModel> filltercategory;
  final List<ProductModel> favorites;
  ShopState({
    //give the initizal value 
    this.allproduct = const [],
    this.filltercategory = const [],
    this.favorites = const [],
  });
  ShopState copy({
    List<ProductModel>? allproduct,
    List<ProductModel>? filltercategory,
    List<ProductModel>? favorites,
  }) {
    return ShopState(
      allproduct: allproduct ?? this.allproduct,
      filltercategory: filltercategory ?? this.filltercategory,
      favorites: favorites ?? this.favorites,
    );
  }
}