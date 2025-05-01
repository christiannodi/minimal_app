class OrderListModel {
  final List<OrderListDataModel> orderListDataModel;

  OrderListModel({
    required this.orderListDataModel,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
        orderListDataModel: List<OrderListDataModel>.from(
            json["data"].map((x) => OrderListDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderListDataModel":
            List<dynamic>.from(orderListDataModel.map((x) => x.toJson())),
      };
}

class OrderListDataModel {
  final int id;
  final int userId;
  final int addressId;
  final String status;
  final int price;
  final String invoiceUrl;
  final DateTime createdAt;
  final int shippingCost;
  final dynamic shippingInvoice;
  final List<OrderItem> orderItems;

  OrderListDataModel({
    required this.id,
    required this.userId,
    required this.addressId,
    required this.status,
    required this.price,
    required this.invoiceUrl,
    required this.createdAt,
    required this.shippingCost,
    required this.shippingInvoice,
    required this.orderItems,
  });

  factory OrderListDataModel.fromJson(Map<String, dynamic> json) =>
      OrderListDataModel(
        id: json["id"],
        userId: json["user_id"],
        addressId: json["address_id"],
        status: json["status"],
        price: json["price"],
        invoiceUrl: json["invoice_url"],
        createdAt: DateTime.parse(json["created_at"]),
        shippingCost: json["shipping_cost"],
        shippingInvoice: json["shipping_invoice"],
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "address_id": addressId,
        "status": status,
        "price": price,
        "invoice_url": invoiceUrl,
        "created_at": createdAt.toIso8601String(),
        "shipping_cost": shippingCost,
        "shipping_invoice": shippingInvoice,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
      };
}

class OrderItem {
  final int id;
  final String title;
  final int productVariantId;
  final int quantity;
  final int price;
  final String colourName;
  final String colourHex;
  final String thumbnail;

  OrderItem({
    required this.id,
    required this.title,
    required this.productVariantId,
    required this.quantity,
    required this.price,
    required this.colourName,
    required this.colourHex,
    required this.thumbnail,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        title: json["title"],
        productVariantId: json["product_variant_id"],
        quantity: json["quantity"],
        price: json["price"],
        colourName: json["colour_name"],
        colourHex: json["colour_hex"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "product_variant_id": productVariantId,
        "quantity": quantity,
        "price": price,
        "colour_name": colourName,
        "colour_hex": colourHex,
        "thumbnail": thumbnail,
      };
}
