import '../../core/network/api_client.dart';
import '../models/document_model.dart';

class DocumentRepository {
  final ApiClient _apiClient;

  DocumentRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<DocumentVerificationModel> verifyDocument(String id) async {
    final response = await _apiClient.verifyDocument(id);
    return DocumentVerificationModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<DocumentModel> generateDocument(
    String requestId,
    String name,
    String content,
  ) async {
    final response = await _apiClient.generateDocument(
      requestId,
      name,
      content,
    );
    return DocumentModel.fromJson(response.data as Map<String, dynamic>);
  }
}
