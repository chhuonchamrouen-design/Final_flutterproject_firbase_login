import 'package:bloc/bloc.dart';
import 'package:shop/Model/productmodel.dart';
import 'package:shop/controller/productcontroller.dart';
part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final Productcontroller product = Productcontroller();
  ShopBloc() : super(ShopState()) {
    on<LoadProduct>(onProduct);
    on<FilterCategory>(onFilterCategory);
    on<ToggleFavorite>(onToggleFavorite);
    on<SelectProduct>(onSelectProduct);
    on<ClearSelectedProduct>(onClearSelectedProduct);
    on<AddToCart>(onAddToCart);
    on<RemoveFromCart>(onRemoveFromCart);
    on<UpdateCartQuantity>(onUpdateCartQuantity);
  }

  void onProduct(LoadProduct event, Emitter<ShopState> emit) {
    emit(
      state.copy(
        allproduct: product.products,
        filltercategory: product.products,
      ),
    );
  }

  void onFilterCategory(FilterCategory event, Emitter<ShopState> emit) {
    if (event.category == "All") {
      emit(state.copy(filltercategory: state.allproduct));
    } else {
      final filtered = state.allproduct
          .where((p) => p.category == event.category)
          .toList();
      emit(state.copy(filltercategory: filtered));
    }
  }

  // FIX: compare by product code instead of object identity
  void onToggleFavorite(ToggleFavorite event, Emitter<ShopState> emit) {
    final isAlreadyFavorite = state.favorites.any(
      (p) => p.code == event.product.code,
    );

    final updatedFavorites = isAlreadyFavorite
        ? state.favorites.where((p) => p.code != event.product.code).toList()
        : [...state.favorites, event.product];

    emit(state.copy(favorites: updatedFavorites));
  }

  void onSelectProduct(SelectProduct event, Emitter<ShopState> emit) {
    emit(state.copy(selectedProduct: event.product));
  }

  void onClearSelectedProduct(
    ClearSelectedProduct event,
    Emitter<ShopState> emit,
  ) {
    emit(state.copy(clearSelected: true));
  }

  // FIX: if the product is already in the cart, increase its quantity
  // instead of silently ignoring the event.
  void onAddToCart(AddToCart event, Emitter<ShopState> emit) {
    final updatedCart = List<ProductModel>.from(state.cart);
    final index = updatedCart.indexWhere((p) => p.code == event.product.code);

    if (index == -1) {
      updatedCart.add(event.product);
    } else {
      final existing = updatedCart[index];
      updatedCart[index] = existing.copyWith(
        quantity: existing.quantity + event.product.quantity,
      );
    }

    emit(state.copy(cart: updatedCart));
  }

  void onRemoveFromCart(RemoveFromCart event, Emitter<ShopState> emit) {
    final updatedCart = state.cart
        .where((p) => p.code != event.product.code)
        .toList();
    emit(state.copy(cart: updatedCart));
  }

  void onUpdateCartQuantity(UpdateCartQuantity event, Emitter<ShopState> emit) {
    final updatedCart = state.cart.map((p) {
      if (p.code == event.product.code) {
        return p.copyWith(quantity: event.quantity < 1 ? 1 : event.quantity);
      }
      return p;
    }).toList();

    emit(state.copy(cart: updatedCart));
  }
}