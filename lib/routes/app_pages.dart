import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/requests/bindings/requests_binding.dart';
import '../modules/requests/views/create_request_view.dart';
import '../modules/requests/views/request_detail_view.dart';
import '../modules/requests/views/requests_list_view.dart';
import '../modules/complaints/bindings/complaints_binding.dart';
import '../modules/complaints/views/complaints_list_view.dart';
import '../modules/complaints/views/create_complaint_view.dart';
import '../modules/complaints/views/complaint_detail_view.dart';
import '../modules/missing_docs/bindings/missing_docs_binding.dart';
import '../modules/missing_docs/views/create_missing_doc_view.dart';
import '../modules/missing_docs/views/missing_docs_list_view.dart';
import '../modules/missing_docs/views/missing_doc_detail_view.dart';
import '../modules/qr/bindings/qr_binding.dart';
import '../modules/qr/views/qr_scan_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/ai_assistant/bindings/ai_chat_binding.dart';
import '../modules/ai_assistant/views/ai_chat_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      bindings: [
        HomeBinding(),
        RequestsBinding(),
        ComplaintsBinding(),
        MissingDocsBinding(),
        DashboardBinding(),
      ],
    ),
    // Requests
    GetPage(
      name: AppRoutes.requestsList,
      page: () => const RequestsListView(),
      binding: RequestsBinding(),
    ),
    GetPage(
      name: AppRoutes.requestDetail,
      page: () => const RequestDetailView(),
      binding: RequestsBinding(),
    ),
    GetPage(
      name: AppRoutes.createRequest,
      page: () => const CreateRequestView(),
      binding: RequestsBinding(),
    ),
    // Complaints
    GetPage(
      name: AppRoutes.complaintsList,
      page: () => const ComplaintsListView(),
      binding: ComplaintsBinding(),
    ),
    GetPage(
      name: AppRoutes.complaintDetail,
      page: () => const ComplaintDetailView(),
      binding: ComplaintsBinding(),
    ),
    GetPage(
      name: AppRoutes.createComplaint,
      page: () => const CreateComplaintView(),
      binding: ComplaintsBinding(),
    ),
    // Missing Docs
    GetPage(
      name: AppRoutes.missingDocsList,
      page: () => const MissingDocsListView(),
      binding: MissingDocsBinding(),
    ),
    GetPage(
      name: AppRoutes.missingDocDetail,
      page: () => const MissingDocDetailView(),
      binding: MissingDocsBinding(),
    ),
    GetPage(
      name: AppRoutes.createMissingDoc,
      page: () => const CreateMissingDocView(),
      binding: MissingDocsBinding(),
    ),
    // QR
    GetPage(
      name: AppRoutes.qrScan,
      page: () => const QrScanView(),
      binding: QrBinding(),
    ),
    // Dashboard
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    // AI Assistant
    GetPage(
      name: AppRoutes.aiAssistant,
      page: () => const AiChatView(),
      binding: AiChatBinding(),
    ),
  ];
}
