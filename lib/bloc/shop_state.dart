part of 'shop_bloc.dart';

class ShopState {
  final List<ProductModel> allproduct;
  final List<ProductModel> filltercategory;
  final List<ProductModel> favorites;
  final List<ProductModel> cart;
  final ProductModel? selectedProduct; // for detail screen

  ShopState({
    this.allproduct = const [],
    this.filltercategory = const [],
    this.favorites = const [],
    this.cart = const [],
    this.selectedProduct,
  });

  ShopState copy({
    List<ProductModel>? allproduct,
    List<ProductModel>? filltercategory,
    List<ProductModel>? favorites,
    List<ProductModel>? cart,
    ProductModel? selectedProduct,
    bool clearSelected = false,
  }) {
    return ShopState(
      allproduct: allproduct ?? this.allproduct,
      filltercategory: filltercategory ?? this.filltercategory,
      favorites: favorites ?? this.favorites,
      cart: cart ?? this.cart,
      selectedProduct: clearSelected ? null : (selectedProduct ?? this.selectedProduct),
    );
  }
}