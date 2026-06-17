class AuthResponseModel {
  final String accessToken;
  final Map<String, dynamic> user;

  const AuthResponseModel({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final token = json['access_token']?.toString() ??
        json['accessToken']?.toString() ??
        json['token']?.toString() ??
        '';
    return AuthResponseModel(
      accessToken: token,
      user: json['user'] != null ? Map<String, dynamic>.from(json['user'] as Map) : {},
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'user': user,
      };
}
