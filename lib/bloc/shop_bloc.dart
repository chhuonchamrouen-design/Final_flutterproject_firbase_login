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
    // new handlers
    on<SelectProduct>(onSelectProduct);
    on<ClearSelectedProduct>(onClearSelectedProduct);
    on<AddToCart>(onAddToCart);
    on<RemoveFromCart>(onRemoveFromCart);
    on<UpdateCartQuantity>(onUpdateCartQuantity);
  }
  // ---------- existing ----------
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

  void onToggleFavorite(ToggleFavorite event, Emitter<ShopState> emit) {
    final isAlreadyFavorite = state.favorites.contains(event.product);
    final updatedFavorites = List<ProductModel>.from(state.favorites);

    if (isAlreadyFavorite) {
      updatedFavorites.remove(event.product);
    } else {
      updatedFavorites.add(event.product);
    }

    emit(state.copy(favorites: updatedFavorites));
  }

  // ---------- new ----------
  void onSelectProduct(SelectProduct event, Emitter<ShopState> emit) {
    emit(state.copy(selectedProduct: event.product));
  }

  void onClearSelectedProduct(
    ClearSelectedProduct event,
    Emitter<ShopState> emit,
  ) {
    emit(state.copy(clearSelected: true));
  }

  void onAddToCart(AddToCart event, Emitter<ShopState> emit) {
    final exists = state.cart.any((p) => p.code == event.product.code);
    if (exists) return; // already in cart

    final updatedCart = List<ProductModel>.from(state.cart)..add(event.product);
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
        // create a new instance with updated quantity
        return ProductModel(
          code: p.code,
          name: p.name,
          category: p.category,
          oldprice: p.oldprice,
          discount: p.discount,
          image: p.image,
          quantity: event.quantity < 1 ? 1 : event.quantity,
          rate: p.rate,
          view: p.view,
          description: p.description,
          storage: p.storage,
          color: p.color,
          detail_item: p.detail_item,
          detail_sp: p.detail_sp,
        );
      }
      return p;
    }).toList();

    emit(state.copy(cart: updatedCart));
  }
}
