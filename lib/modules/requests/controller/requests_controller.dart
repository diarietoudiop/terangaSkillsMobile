import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/administrative_request_model.dart';
import '../../../data/repositories/administrative_request_repository.dart';

class RequestsController extends GetxController {
  final AdministrativeRequestRepository _repo;

  RequestsController({AdministrativeRequestRepository? repo})
      : _repo = repo ?? AdministrativeRequestRepository();

  // ─── State ───────────────────────────────────────────
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final requests = <AdministrativeRequestModel>[].obs;
  final selectedRequest = Rxn<AdministrativeRequestModel>();

  // ─── Form ────────────────────────────────────────────
  final selectedType = 'BIRTH_CERTIFICATE'.obs;
  final titleController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;
  final pickedFiles = <XFile>[].obs;

  static const List<Map<String, String>> requestTypes = [
    {'value': 'BIRTH_CERTIFICATE', 'label': 'Extrait de naissance'},
    {'value': 'DEATH_CERTIFICATE', 'label': 'Acte de décès'},
    {'value': 'RESIDENCE_CERTIFICATE', 'label': 'Certificat de résidence'},
    {'value': 'LITERARY_COPY', 'label': 'Copie littérale'},
    {'value': 'BIRTH_DECLARATION', 'label': 'Déclaration de naissance'},
    {'value': 'OTHER', 'label': 'Autre'},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchMyRequests();
  }

  // ─── Fetch ───────────────────────────────────────────
  Future<void> fetchMyRequests() async {
    try {
      isLoading.value = true;
      requests.value = await _repo.getMyRequests();
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
    if (titleController.value.text.isEmpty ||
        descriptionController.value.text.isEmpty) {
      AppSnackbar.warning('Veuillez remplir tous les champs.');
      return;
    }
    try {
      isSubmitting.value = true;
      final multiparts = await Future.wait(
        pickedFiles.map((f) async => MultipartFile.fromFile(
              f.path,
              filename: f.name,
            )),
      );
      await _repo.createRequest(
        type: selectedType.value,
        title: titleController.value.text.trim(),
        description: descriptionController.value.text.trim(),
        files: multiparts.isEmpty ? null : multiparts,
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
    selectedType.value = 'BIRTH_CERTIFICATE';
  }

  String _msg(DioException e) =>
      e.error?.toString().split(':').last.trim() ?? 'Erreur réseau';
}
