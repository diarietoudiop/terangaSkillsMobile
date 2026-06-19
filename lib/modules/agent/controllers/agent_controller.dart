import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/error_translator.dart';
import '../../../data/models/administrative_request_model.dart';
import '../../../data/repositories/administrative_request_repository.dart';

/// Statuses an Agent can apply
const List<Map<String, dynamic>> kAgentStatuses = [
  {'value': 'IN_PROGRESS', 'label': 'En cours de traitement', 'icon': Icons.autorenew},
  {'value': 'PROCESSED', 'label': 'Traité', 'icon': Icons.done},
  {'value': 'VALIDATED', 'label': 'Validé', 'icon': Icons.verified},
  {'value': 'COMPLETED', 'label': 'Terminé', 'icon': Icons.check_circle},
  {'value': 'REJECTED', 'label': 'Rejeté', 'icon': Icons.cancel},
];

class AgentController extends GetxController {
  final AdministrativeRequestRepository _repo;

  AgentController({
    AdministrativeRequestRepository? repo,
  })  : _repo = repo ?? AdministrativeRequestRepository();

  // ─── State ─────────────────────────────────────────────
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final isUploading = false.obs;
  final uploadProgress = 0.0.obs;

  final allRequests = <AdministrativeRequestModel>[].obs;
  final myRequests = <AdministrativeRequestModel>[].obs;
  final selectedRequest = Rxn<AdministrativeRequestModel>();

  // Filter
  final statusFilter = ''.obs; // '' = tous

  // Drawer
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  // ─── Computed ──────────────────────────────────────────
  List<AdministrativeRequestModel> get filteredRequests {
    if (statusFilter.value.isEmpty) return allRequests;
    return allRequests
        .where((r) => r.status == statusFilter.value)
        .toList();
  }

  // ─── Document to upload ────────────────────────────────
  final pickedDocFile = Rxn<XFile>();

  @override
  void onInit() {
    super.onInit();
    loadRequests();
  }

  // ─── Load all requests (accessible to this agent) ──────
  Future<void> loadRequests() async {
    try {
      isLoading.value = true;
      allRequests.value = await _repo.getAllRequests();
    } on DioException catch (e) {
      AppSnackbar.error(_msg(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadRequestDetail(String id) async {
    try {
      isLoading.value = true;
      selectedRequest.value = await _repo.getRequest(id);
    } on DioException catch (e) {
      AppSnackbar.error(_msg(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Update status ─────────────────────────────────────
  Future<void> updateStatus(String id, String status) async {
    try {
      isUpdating.value = true;
      await _repo.updateStatus(id, status);
      // Refresh the selected request
      await loadRequestDetail(id);
      await loadRequests();
      AppSnackbar.success('Statut mis à jour !');
    } on DioException catch (e) {
      AppSnackbar.error(_msg(e));
    } finally {
      isUpdating.value = false;
    }
  }

  // ─── Generate document & complete ──────────────────────
  Future<void> generateDocumentAndComplete(String requestId, String docName) async {
    try {
      isUploading.value = true;
      // 1. Generate document via API
      await _repo.generateDocument(requestId, docName, '');
      // 2. Mark as COMPLETED
      await _repo.updateStatus(requestId, 'COMPLETED');
      await loadRequestDetail(requestId);
      await loadRequests();
      AppSnackbar.success('Document généré et demande terminée !');
    } catch (e) {
      AppSnackbar.error('Erreur lors de la génération du document.');
    } finally {
      isUploading.value = false;
    }
  }

  // ─── Upload document attachment ─────────────────────────
  Future<void> pickDocument() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file != null) pickedDocFile.value = file;
  }

  Future<void> uploadDocumentForRequest(String requestId) async {
    if (pickedDocFile.value == null) {
      AppSnackbar.warning('Veuillez sélectionner un fichier.');
      return;
    }
    try {
      isUploading.value = true;
      await _repo.generateDocument(
        requestId,
        pickedDocFile.value!.name,
        '',
      );
      pickedDocFile.value = null;
      await loadRequestDetail(requestId);
      AppSnackbar.success('Document envoyé au citoyen !');
    } catch (e) {
      AppSnackbar.error('Erreur lors de l\'envoi du document.');
    } finally {
      isUploading.value = false;
    }
  }

  String _msg(DioException e) {
    final rawMsg = e.response?.data?['message']?.toString() ??
        e.error?.toString().split(':').last.trim() ??
        'Erreur réseau';
    return ErrorTranslator.translate(rawMsg);
  }
}
