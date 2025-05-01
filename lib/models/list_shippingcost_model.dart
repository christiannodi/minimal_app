class ShippingcostModel {
  final List<ShippingcostDataModel> shippingcostDataModel;

  ShippingcostModel({
    required this.shippingcostDataModel,
  });

  factory ShippingcostModel.fromJson(Map<String, dynamic> json) =>
      ShippingcostModel(
        shippingcostDataModel: List<ShippingcostDataModel>.from(
            json["data"].map((x) => ShippingcostDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shippingcostDataModel":
            List<dynamic>.from(shippingcostDataModel.map((x) => x.toJson())),
      };
}

class ShippingcostDataModel {
  final String name;
  final String code;
  final String service;
  final String description;
  final int cost;
  final String etd;

  ShippingcostDataModel({
    required this.name,
    required this.code,
    required this.service,
    required this.description,
    required this.cost,
    required this.etd,
  });

  factory ShippingcostDataModel.fromJson(Map<String, dynamic> json) =>
      ShippingcostDataModel(
        name: json["name"],
        code: json["code"],
        service: json["service"],
        description: json["description"],
        cost: json["cost"],
        etd: json["etd"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "service": service,
        "description": description,
        "cost": cost,
        "etd": etd,
      };
}

