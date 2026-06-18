class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  // Requests
  static const String requestsList = '/requests';
  static const String requestDetail = '/requests/detail';
  static const String createRequest = '/requests/create';

  // Complaints
  static const String complaintsList = '/complaints';
  static const String complaintDetail = '/complaints/detail';
  static const String createComplaint = '/complaints/create';

  // Missing Documents
  static const String missingDocsList = '/missing-docs';
  static const String missingDocDetail = '/missing-docs/detail';
  static const String createMissingDoc = '/missing-docs/create';

  // QR
  static const String qrScan = '/qr/scan';

  // Dashboard
  static const String dashboard = '/dashboard';

  // AI Assistant
  static const String aiAssistant = '/ai-assistant';
}
