import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../models/missing_document_model.dart';

class MissingDocumentRepository {
  final ApiClient _apiClient;

  MissingDocumentRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<MissingDocumentModel> create({
    required String title,
    required String description,
    String? lastSeenLocation,
    double? latitude,
    double? longitude,
    MultipartFile? file,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      if (lastSeenLocation != null) 'lastSeenLocation': lastSeenLocation,
      if (latitude != null) 'latitude': latitude.toString(),
      if (longitude != null) 'longitude': longitude.toString(),
      if (file != null) 'file': file,
    });
    final response = await _apiClient.createMissingDocument(formData);
    return MissingDocumentModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<MissingDocumentModel>> getAll() async {
    final response = await _apiClient.getMissingDocuments();
    final data = response.data;
    final List list = (data is Map)
        ? (data['data'] ?? data['missingDocuments'] ?? [])
        : (data as List? ?? []);
    return list
        .map((e) => MissingDocumentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MissingDocumentModel> getById(String id) async {
    final response = await _apiClient.getMissingDocument(id);
    return MissingDocumentModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<MissingDocumentModel> updateStatus(String id, String status) async {
    final response = await _apiClient.updateMissingDocumentStatus(id, status);
    return MissingDocumentModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> delete(String id) => _apiClient.deleteMissingDocument(id);
}
