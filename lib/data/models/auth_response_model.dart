class AuthResponseModel {
  final String accessToken;
  final Map<String, dynamic> user;

  const AuthResponseModel({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final map = (json['data'] is Map) ? json['data'] as Map<String, dynamic> : json;
    final token = map['access_token']?.toString() ??
        map['accessToken']?.toString() ??
        map['token']?.toString() ??
        json['access_token']?.toString() ??
        json['accessToken']?.toString() ??
        json['token']?.toString() ??
        '';
    final userMap = map['user'] ?? json['user'];
    return AuthResponseModel(
      accessToken: token,
      user: userMap != null ? Map<String, dynamic>.from(userMap as Map) : {},
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'user': user,
      };
}
