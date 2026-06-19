import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/administrative_request_model.dart';
import '../../../data/models/request_type_model.dart';
import '../../../data/repositories/administrative_request_repository.dart';
import '../../auth/controller/auth_controller.dart';

class RequestsController extends GetxController {
  final AdministrativeRequestRepository _repo;
  final ApiClient _apiClient;

  RequestsController({
    AdministrativeRequestRepository? repo,
    ApiClient? apiClient,
  })  : _repo = repo ?? AdministrativeRequestRepository(),
        _apiClient = apiClient ?? ApiClient();

  // ─── State ───────────────────────────────────────────
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final isLoadingTypes = false.obs;
  final uploadProgress = 0.0.obs;
  final requests = <AdministrativeRequestModel>[].obs;
  final selectedRequest = Rxn<AdministrativeRequestModel>();

  // ─── Dynamic Request Types from API ──────────────────
  final requestTypes = <RequestTypeModel>[].obs;

  // ─── Form ────────────────────────────────────────────
  /// selectedTypeId holds the UUID of the selected RequestType
  final selectedTypeId = ''.obs;
  final titleController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;
  final pickedFiles = <XFile>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequestTypes();
    fetchMyRequests();
  }

  // ─── Load request types from backend ─────────────────
  Future<void> fetchRequestTypes() async {
    try {
      isLoadingTypes.value = true;
      final response = await _apiClient.getRequestTypes();
      final data = response.data;
      final List raw = (data is Map)
          ? (data['data'] ?? data['requestTypes'] ?? data as List? ?? [])
          : (data as List? ?? []);
      requestTypes.value = raw
          .map((e) => RequestTypeModel.fromJson(e as Map<String, dynamic>))
          .toList();
      if (requestTypes.isNotEmpty && selectedTypeId.value.isEmpty) {
        selectedTypeId.value = requestTypes.first.id;
      }
    } catch (_) {
      // Silent fail — form still shows an empty dropdown with a clear message
    } finally {
      isLoadingTypes.value = false;
    }
  }

  // ─── Fetch ───────────────────────────────────────────
  Future<void> fetchMyRequests() async {
    try {
      isLoading.value = true;
      final auth = Get.find<AuthController>();
      final isAgent = auth.currentUser.value?.isAgent ?? false;
      if (isAgent) {
        requests.value = await _repo.getAllRequests();
      } else {
        requests.value = await _repo.getMyRequests();
      }
    } on DioException catch (e) {
      AppSnackbar.error(_msg(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRequest(String id) async {
    try {
      isLoading.value = true;
      selectedRequest.value = await _repo.getRequest(id);
    } on DioException catch (e) {
      AppSnackbar.error(_msg(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Submit ──────────────────────────────────────────
  Future<void> submitRequest() async {
    if (selectedTypeId.value.isEmpty) {
      AppSnackbar.warning('Veuillez sélectionner un type de demande.');
      return;
    }
    if (titleController.value.text.isEmpty ||
        descriptionController.value.text.isEmpty) {
      AppSnackbar.warning('Veuillez remplir tous les champs.');
      return;
    }
    try {
      isSubmitting.value = true;
      uploadProgress.value = 0.0;
      final multiparts = await Future.wait(
        pickedFiles.map(
          (f) async => MultipartFile.fromFile(f.path, filename: f.name),
        ),
      );
      await _repo.createRequest(
        requestTypeId: selectedTypeId.value,
        title: titleController.value.text.trim(),
        description: descriptionController.value.text.trim(),
        files: multiparts.isEmpty ? null : multiparts,
        onSendProgress: (sent, total) {
          if (total > 0) uploadProgress.value = sent / total;
        },
      );
      AppSnackbar.success('Demande soumise avec succès !');
      _clearForm();
      await fetchMyRequests();
      Get.back();
    } on DioException catch (e) {
      AppSnackbar.error(_msg(e));
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> generateDocumentAndComplete(
    String requestId,
    String content,
  ) async {
    try {
      isLoading.value = true;
      await _repo.updateStatus(requestId, 'COMPLETED');
      await _repo.generateDocument(
        requestId,
        'Document_Final_$requestId.pdf',
        content,
      );
      await fetchRequest(requestId);
      AppSnackbar.success('Document généré et demande terminée.');
    } catch (e) {
      AppSnackbar.error('Erreur lors de la génération du document');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickFiles() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage(imageQuality: 80);
    pickedFiles.addAll(files);
  }

  void removeFile(int index) => pickedFiles.removeAt(index);

  void _clearForm() {
    titleController.value.clear();
    descriptionController.value.clear();
    pickedFiles.clear();
    if (requestTypes.isNotEmpty) {
      selectedTypeId.value = requestTypes.first.id;
    }
  }

  String _msg(DioException e) =>
      e.error?.toString().split(':').last.trim() ?? 'Erreur réseau';
}
