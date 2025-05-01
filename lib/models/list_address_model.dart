class AddressModel {
  final List<AddressDataModel> addressDataModel;

  AddressModel({
    required this.addressDataModel,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        addressDataModel: List<AddressDataModel>.from(
            json["data"].map((x) => AddressDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "addressDataModel":
            List<dynamic>.from(addressDataModel.map((x) => x.toJson())),
      };
}

class AddressDataModel {
  final int id;
  final int userId;
  final String name;
  final String phone;
  final String address;
  final String postalCode;
  final String district;
  final String city;
  final String province;
  final String notes;
  final int isDefault;
  final String flag;

  AddressDataModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.address,
    required this.postalCode,
    required this.district,
    required this.city,
    required this.province,
    required this.notes,
    required this.isDefault,
    required this.flag,
  });

  factory AddressDataModel.fromJson(Map<String, dynamic> json) =>
      AddressDataModel(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        postalCode: json["postal_code"],
        district: json["district"],
        city: json["city"],
        province: json["province"],
        notes: json["notes"],
        isDefault: json["is_default"],
        flag: json["flag"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "phone": phone,
        "address": address,
        "postal_code": postalCode,
        "district": district,
        "city": city,
        "province": province,
        "notes": notes,
        "is_default": isDefault,
        "flag": flag,
      };
}
