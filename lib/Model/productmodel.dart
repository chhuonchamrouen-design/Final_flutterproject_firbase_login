class ProductModel {
  int code;
  String name;
  String category;
  double oldprice;
  int discount;
  String image;
  int quantity;
  String rate;
  String view;
  String description;
  String storage;
  String color;
  List<String> detail_item;
  List<String> detail_sp;

  ProductModel({
    required this.category,
    required this.code,
    this.quantity = 1,
    required this.color,
    required this.description,
    required this.discount,
    required this.image,
    required this.name,
    required this.oldprice,
    required this.rate,
    required this.storage,
    required this.view,
    required this.detail_item,
    required this.detail_sp,
  });
  /// Returns a copy of this product with the given fields replaced.
  ProductModel copyWith({
    int? code,
    String? name,
    String? category,
    double? oldprice,
    int? discount,
    String? image,
    int? quantity,
    String? rate,
    String? view,
    String? description,
    String? storage,
    String? color,
    List<String>? detail_item,
    List<String>? detail_sp,
  }) {
    return ProductModel(
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      oldprice: oldprice ?? this.oldprice,
      discount: discount ?? this.discount,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      view: view ?? this.view,
      description: description ?? this.description,
      storage: storage ?? this.storage,
      color: color ?? this.color,
      detail_item: detail_item ?? this.detail_item,
      detail_sp: detail_sp ?? this.detail_sp,
    );
  }
  // Two products are "the same" when they share the same code.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ProductModel && other.code == code);
  @override
  int get hashCode => code.hashCode;
}
