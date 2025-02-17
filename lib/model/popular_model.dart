class PopularProductsModel {
  final String price;
  final String name;
  final String image;

  PopularProductsModel({
    required this.price,
    required this.name,
    required this.image,
  });
}

var listPopular = [
  PopularProductsModel(
      name: "Windproof Vest",
      image: "assets/png/product/product1.png",
      price: "Rp599.000"),
  PopularProductsModel(
      name: "SUPIMA Cotton T-Shirt",
      image: "assets/png/product/product2.png",
      price: "Rp192.000"),
  PopularProductsModel(
      name: "Sweater Washable Mila",
      image: "assets/png/product/product3.png",
      price: "Rp599.000"),
  PopularProductsModel(
      name: "AIRism Cotton T-Shirt",
      image: "assets/png/product/product4.png",
      price: "Rp254.000"),
  PopularProductsModel(
      name: "DRY-EX T-Shirt",
      image: "assets/png/product/product5.png",
      price: "Rp205.000"),
];
