 class AppConstants {
  AppConstants._();

  static const String baseUrl = 'https://terangaskillsback-1-zxhy.onrender.com/api/v1';
  static const String geminiApiKey = 'AQ.AbRN6KxUpTq6fELWJlE5IoXo9a5fZ-1EaQ9JW4U26QqpwcNpA';
  //static const String apiVersion = '/v1';
  static const int connectTimeout = 90000;
  static const int receiveTimeout = 90000;

  static const String accessTokenKey = 'access_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String onboardingKey = 'onboarding_done';

  static const String appName = 'TerangaSkills';
  static const String appTagline = 'Gouvernance Numérique';

  static const int pageSize = 20;

  static const Duration cacheDuration = Duration(minutes: 10);
}
