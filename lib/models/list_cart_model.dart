class CartModel {
  final List<CartDataModel> cartDataModel;

  CartModel({
    required this.cartDataModel,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        cartDataModel: List<CartDataModel>.from(
            json["data"].map((x) => CartDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cartDataModel":
            List<dynamic>.from(cartDataModel.map((x) => x.toJson())),
      };
}

class CartDataModel {
  final int id;
  final int userId;
  final int productId;
  final int productVariantId;
  final String productTitle;
  late final int quantity;
  final String size;
  final int stock;
  final int price;
  final String colourName;
  final String colourHex;
  final String thumbnail;

  CartDataModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productVariantId,
    required this.productTitle,
    required this.quantity,
    required this.size,
    required this.stock,
    required this.price,
    required this.colourName,
    required this.colourHex,
    required this.thumbnail,
  });

  factory CartDataModel.fromJson(Map<String, dynamic> json) => CartDataModel(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        productVariantId: json["product_variant_id"],
        productTitle: json["product_title"],
        quantity: json["quantity"],
        size: json["size"],
        stock: json["stock"],
        price: json["price"],
        colourName: json["colour_name"],
        colourHex: json["colour_hex"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "product_variant_id": productVariantId,
        "product_title": productTitle,
        "quantity": quantity,
        "size": size,
        "stock": stock,
        "price": price,
        "colour_name": colourName,
        "colour_hex": colourHex,
        "thumbnail": thumbnail,
      };
}
