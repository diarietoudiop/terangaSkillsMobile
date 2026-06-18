import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/administrative_request_model.dart';

class AdministrativeRequestRepository {
  final ApiClient _apiClient;

  AdministrativeRequestRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<AdministrativeRequestModel> createRequest({
    required String type,
    required String title,
    required String description,
    Map<String, dynamic>? data,
    List<MultipartFile>? files,
    ProgressCallback? onSendProgress,
  }) async {
    final formData = FormData.fromMap({
      'type': type,
      'title': title,
      'description': description,
      if (data != null) 'data': data.toString(),
      if (files != null) 'files': files,
    });
    final response = await _apiClient.createAdminRequest(formData, onSendProgress: onSendProgress);
    return AdministrativeRequestModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<List<AdministrativeRequestModel>> getAllRequests() async {
    final response = await _apiClient.getAdminRequests();
    final data = response.data;
    final List list = (data is Map)
        ? (data['data'] ?? data['requests'] ?? data['administrativeRequests'] ?? [])
        : (data as List? ?? []);
    return list
        .map((e) =>
            AdministrativeRequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<AdministrativeRequestModel>> getMyRequests() async {
    final response = await _apiClient.getMyAdminRequests();
    final data = response.data;
    final List list = (data is Map)
        ? (data['data'] ?? data['requests'] ?? data['administrativeRequests'] ?? [])
        : (data as List? ?? []);
    return list
        .map((e) =>
            AdministrativeRequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AdministrativeRequestModel> getRequest(String id) async {
    final response = await _apiClient.getAdminRequest(id);
    return AdministrativeRequestModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<AdministrativeRequestModel> updateStatus(
      String id, String status) async {
    final response = await _apiClient.updateAdminRequestStatus(id, status);
    return AdministrativeRequestModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<AdministrativeRequestModel> assignAgent(
      String id, String agentId) async {
    final response = await _apiClient.assignAgentToRequest(id, agentId);
    return AdministrativeRequestModel.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<void> deleteRequest(String id) =>
      _apiClient.deleteAdminRequest(id);
}
