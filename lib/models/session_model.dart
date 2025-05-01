class SessionModel {
  final int userId;
  final String accessToken;
  final String refreshToken;
  final String? fullName;

  SessionModel(
      {required this.userId,
      required this.accessToken,
      required this.refreshToken,
      required this.fullName});

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      userId: json['user_id'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      fullName: json['full_name'],
    );
  }
}
