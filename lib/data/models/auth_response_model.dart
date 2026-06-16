class AuthResponseModel {
  final String accessToken;
  final Map<String, dynamic> user;

  const AuthResponseModel({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token']?.toString() ?? '',
      user: json['user'] != null ? Map<String, dynamic>.from(json['user'] as Map) : {},
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'user': user,
      };
}
