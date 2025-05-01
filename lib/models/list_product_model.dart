class ProductModel {
  final List<ProductDataModel> productDataModel;

  ProductModel({
    required this.productDataModel,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productDataModel: List<ProductDataModel>.from(
            json["data"].map((x) => ProductDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "productDataModel":
            List<dynamic>.from(productDataModel.map((x) => x.toJson())),
      };
}

class ProductDataModel {
  final int id;
  final String title;
  final String thumbnail;
  final int price;
  final String category;
  final String gender;
  final List<String> tags;

  ProductDataModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.category,
    required this.gender,
    required this.tags,
  });

  factory ProductDataModel.fromJson(Map<String, dynamic> json) =>
      ProductDataModel(
        id: json["id"],
        title: json["title"],
        thumbnail: json["thumbnail"],
        price: json["price"],
        category: json["category"],
        gender: json["gender"],
        tags: List<String>.from(json["tags"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "thumbnail": thumbnail,
        "price": price,
        "category": category,
        "gender": gender,
        "tags": List<dynamic>.from(tags.map((x) => x)),
      };
}
