class AppConstants {
  AppConstants._();

  static const String baseUrl =
      'https://terangaskillsback-1-zxhy.onrender.com/api/v1';
  //static const String apiVersion = '/v1';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const String accessTokenKey = 'access_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String onboardingKey = 'onboarding_done';

  static const String appName = 'TerangaSkills';
  static const String appTagline = 'Gouvernance Numérique';

  static const int pageSize = 20;

  static const Duration cacheDuration = Duration(minutes: 10);
}
