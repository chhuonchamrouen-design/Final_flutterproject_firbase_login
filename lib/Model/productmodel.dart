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
  List<String> storage;
  List<String> color;
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
}
