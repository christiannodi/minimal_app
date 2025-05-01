class UserModel {
  final UserDataModel userDataModel;

  UserModel({
    required this.userDataModel,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userDataModel: UserDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "userDataModel": userDataModel.toJson(),
      };
}

class UserDataModel {
  final int id;
  final int userId;
  final String username;
  final String avatar;
  final String fullName;
  final String birthdate;
  final String gender;
  final String email;
  final String phone;

  UserDataModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.avatar,
    required this.fullName,
    required this.birthdate,
    required this.gender,
    required this.email,
    required this.phone,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        username: json["username"] ?? "Unknown",
        avatar: json["avatar"] ??
            "https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png",
        fullName: json["full_name"] ?? "No Name",
        birthdate: json["birthdate"] ?? "0000-00-00T00:00:00.000Z",
        gender: json["gender"] ?? "Unknown",
        email: json["email"] ?? "Unknown",
        phone: json["phone"] ?? "Unknown",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "username": username,
        "avatar": avatar,
        "full_name": fullName,
        "birthdate": birthdate,
        "gender": gender,
        "email": email,
        "phone": phone
      };

  // ✅ Tambahkan copyWith() agar bisa update state tanpa membuat objek baru manual
  UserDataModel copyWith({
    int? id,
    int? userId,
    String? username,
    String? avatar,
    String? fullName,
    String? birthdate,
    String? gender,
    String? email,
    String? phone,
  }) {
    return UserDataModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      fullName: fullName ??
          this.fullName, // ✅ Bisa diperbarui tanpa mengubah objek asli
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
