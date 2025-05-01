class EditProfileModel {
  final Map<String, dynamic> updatedFields;

  EditProfileModel({required this.updatedFields});

  Map<String, dynamic> toJson() => updatedFields; // Langsung return map
}
