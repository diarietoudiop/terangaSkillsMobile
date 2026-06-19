import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/complaint_model.dart';

class ComplaintRepository {
  final ApiClient _apiClient;

  ComplaintRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<ComplaintModel> createComplaint({
    required String title,
    required String description,
    double? latitude,
    double? longitude,
    MultipartFile? file,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      if (latitude != null) 'latitude': latitude.toString(),
      if (longitude != null) 'longitude': longitude.toString(),
      if (file != null) 'file': file,
    });
    final response = await _apiClient.createComplaint(formData);
    return ComplaintModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<ComplaintModel>> getAllComplaints() async {
    final response = await _apiClient.getComplaints();
    final data = response.data;
    final List list = (data is Map)
        ? (data['data'] ?? data['complaints'] ?? [])
        : (data as List? ?? []);
    return list
        .map((e) => ComplaintModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ComplaintModel>> getMyComplaints() async {
    final response = await _apiClient.getMyComplaints();
    final data = response.data;
    final List list = (data is Map)
        ? (data['data'] ?? data['complaints'] ?? [])
        : (data as List? ?? []);
    return list
        .map((e) => ComplaintModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ComplaintModel> getComplaint(String id) async {
    final response = await _apiClient.getComplaint(id);
    return ComplaintModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ComplaintModel> updateStatus(String id, String status) async {
    final response = await _apiClient.updateComplaintStatus(id, status);
    return ComplaintModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteComplaint(String id) => _apiClient.deleteComplaint(id);
}
