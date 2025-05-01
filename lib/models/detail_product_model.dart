class DetailProductModel {
  final DetailProductDataModel detailProductDataModel;

  DetailProductModel({
    required this.detailProductDataModel,
  });

  factory DetailProductModel.fromJson(Map<String, dynamic> json) =>
      DetailProductModel(
        detailProductDataModel: DetailProductDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "detailProductDataModel": detailProductDataModel.toJson(),
      };
}

class DetailProductDataModel {
  final int id;
  final String title;
  final String description;
  final int basePrice;
  final String category;
  final String gender;
  final List<String> tags;
  final List<ProductImage> productImages;
  final List<ProductVariant> productVariants;

  DetailProductDataModel({
    required this.id,
    required this.title,
    required this.description,
    required this.basePrice,
    required this.category,
    required this.gender,
    required this.tags,
    required this.productImages,
    required this.productVariants,
  });

  factory DetailProductDataModel.fromJson(Map<String, dynamic> json) =>
      DetailProductDataModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        basePrice: json["base_price"],
        category: json["category"],
        gender: json["gender"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        productImages: List<ProductImage>.from(
            json["productImages"].map((x) => ProductImage.fromJson(x))),
        productVariants: List<ProductVariant>.from(
            json["productVariants"].map((x) => ProductVariant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "base_price": basePrice,
        "category": category,
        "gender": gender,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "productImages":
            List<dynamic>.from(productImages.map((x) => x.toJson())),
        "productVariants": List<dynamic>.from(productVariants.map((x) => x)),
      };
}

class ProductImage {
  final String url;

  ProductImage({
    required this.url,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}

class ProductVariant {
  final int id;
  final String size;
  final int stock;
  final int price; // Tambahkan price
  final Map<String, dynamic> colour;

  ProductVariant({
    required this.id,
    required this.size,
    required this.stock,
    required this.price, // Pastikan price ada di sini
    required this.colour,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json["id"],
      size: json["size"],
      stock: json["stock"],
      price: json["price"], // Ambil harga dari JSON
      colour: json["colours"], // Menyimpan warna dalam Map
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "size": size,
        "stock": stock,
        "price": price, // Tambahkan price ke toJson()
        "colours": colour,
      };
}
