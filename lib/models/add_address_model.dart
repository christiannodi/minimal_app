class AddAddressModel {
  final Map<String, dynamic> updatedFields;

  AddAddressModel({required this.updatedFields});

  Map<String, dynamic> toJson() => updatedFields; // Langsung return map
}
