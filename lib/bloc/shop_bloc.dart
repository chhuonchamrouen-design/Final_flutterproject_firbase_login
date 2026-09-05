import 'package:bloc/bloc.dart';
import 'package:shop/Model/productmodel.dart';
import 'package:shop/controller/productcontroller.dart';
part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final Productcontroller product = Productcontroller();

  ShopBloc() : super(ShopState()) {
    //load product 
    on<LoadProduct>((event, emit) {
      onProduct(event, emit);
    });
    //filter category
    on<FilterCategory>((event, emit) {
      onFilterCategory(event, emit);
    });
    //selectfavarite of itme 
    on<ToggleFavorite>((event, emit) {
      onToggleFavorite(event, emit);
    });
  }
//function for update allproduct and filttercategory 
  void onProduct(LoadProduct event, Emitter<ShopState> emit) {
    emit(
      state.copy(
        allproduct: product.products,
        filltercategory: product.products,
      ),
    );
  }
//function for filter all item 
//if selexct all that show all item else select by other product is show by on item 
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
//fucntion for select go to favarite item 
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
}