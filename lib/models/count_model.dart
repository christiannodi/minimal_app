class CountModel {
  final CountDataModel countDataModel;

  CountModel({
    required this.countDataModel,
  });

  factory CountModel.fromJson(Map<String, dynamic> json) => CountModel(
        countDataModel: CountDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "countDataModel": countDataModel.toJson(),
      };
}

class CountDataModel {
  final int cart;
  final int pending;
  final int paid;
  final int shipped;

  CountDataModel({
    required this.cart,
    required this.pending,
    required this.paid,
    required this.shipped,
  });

  factory CountDataModel.fromJson(Map<String, dynamic> json) => CountDataModel(
        cart: json["cart"] ?? 0,
        pending: json["pending"] ?? 0,
        paid: json["paid"] ?? 0,
        shipped: json["shipped"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "cart": cart,
        "pending": pending,
        "paid": paid,
        "shipped": shipped,
      };
}
