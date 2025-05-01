class AddCartModel {
  final Map<String, dynamic> updatedFields;

  AddCartModel({required this.updatedFields});

  Map<String, dynamic> toJson() => updatedFields; // Langsung return map
}
