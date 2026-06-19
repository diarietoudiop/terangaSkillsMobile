import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: AppConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: AppConstants.receiveTimeout,
        ),
        contentType: 'application/json',
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.addAll([AuthInterceptor(), ErrorInterceptor()]);
  }

  factory ApiClient() {
    _instance ??= ApiClient._();
    return _instance!;
  }

  Dio get dio => _dio;

  // ─── AUTH ──────────────────────────────────────────────
  Future<Response> login(Map<String, dynamic> data) =>
      _dio.post('/auth/login', data: data);

  Future<Response> register(Map<String, dynamic> data) =>
      _dio.post('/auth/register', data: data);

  Future<Response> getMe() => _dio.get('/auth/me');

  // ─── ADMINISTRATIVE REQUESTS ───────────────────────────
  Future<Response> createAdminRequest(
    FormData formData, {
    ProgressCallback? onSendProgress,
  }) => _dio.post(
    '/administrative-requests',
    data: formData,
    onSendProgress: onSendProgress,
  );

  Future<Response> getAdminRequests() => _dio.get('/administrative-requests');

  Future<Response> getMyAdminRequests() =>
      _dio.get('/administrative-requests/my-requests');

  Future<Response> getAdminRequest(String id) =>
      _dio.get('/administrative-requests/$id');

  Future<Response> updateAdminRequest(String id, Map<String, dynamic> data) =>
      _dio.patch('/administrative-requests/$id', data: data);

  Future<Response> updateAdminRequestStatus(String id, String status) => _dio
      .patch('/administrative-requests/$id/status', data: {'status': status});

  Future<Response> assignAgentToRequest(String id, String agentId) => _dio
      .patch('/administrative-requests/$id/assign', data: {'agentId': agentId});

  Future<Response> deleteAdminRequest(String id) =>
      _dio.delete('/administrative-requests/$id');

  // ─── COMPLAINTS ────────────────────────────────────────
  Future<Response> createComplaint(
    FormData formData, {
    ProgressCallback? onSendProgress,
  }) =>
      _dio.post('/complaints', data: formData, onSendProgress: onSendProgress);

  Future<Response> getComplaints() => _dio.get('/complaints');

  Future<Response> getMyComplaints() => _dio.get('/complaints/my-complaints');

  Future<Response> getComplaint(String id) => _dio.get('/complaints/$id');

  Future<Response> updateComplaint(String id, Map<String, dynamic> data) =>
      _dio.patch('/complaints/$id', data: data);

  Future<Response> updateComplaintStatus(String id, String status) =>
      _dio.patch('/complaints/$id/status', data: {'status': status});

  Future<Response> deleteComplaint(String id) => _dio.delete('/complaints/$id');

  // ─── MISSING DOCUMENTS ─────────────────────────────────
  Future<Response> createMissingDocument(
    FormData formData, {
    ProgressCallback? onSendProgress,
  }) => _dio.post(
    '/missing-documents',
    data: formData,
    onSendProgress: onSendProgress,
  );

  Future<Response> getMissingDocuments() => _dio.get('/missing-documents');

  Future<Response> getMissingDocument(String id) =>
      _dio.get('/missing-documents/$id');

  Future<Response> updateMissingDocument(
    String id,
    Map<String, dynamic> data,
  ) => _dio.patch('/missing-documents/$id', data: data);

  Future<Response> updateMissingDocumentStatus(String id, String status) =>
      _dio.patch('/missing-documents/$id/status', data: {'status': status});

  Future<Response> deleteMissingDocument(String id) =>
      _dio.delete('/missing-documents/$id');

  // ─── DOCUMENTS / QR ────────────────────────────────────
  Future<Response> generateDocument(
    String requestId,
    String name,
    String content,
  ) => _dio.post(
    '/documents/generate/$requestId',
    data: {'name': name, 'content': content},
  );

  Future<Response> verifyDocument(String id) =>
      _dio.get('/documents/verify/$id');

  // ─── DEPARTMENTS / SERVICES ────────────────────────────
  Future<Response> getDepartments() => _dio.get('/departments');

  Future<Response> getRequestTypes() =>
      _dio.get('/departments/request-types/all');

  // ─── INVESTMENT PROJECTS ───────────────────────────────
  Future<Response> getInvestmentProjects() => _dio.get('/investment-projects');

  Future<Response> getInvestmentProject(String id) =>
      _dio.get('/investment-projects/$id');

  // ─── DASHBOARD ─────────────────────────────────────────
  Future<Response> getDashboardStats() => _dio.get('/dashboard/statistics');
}
