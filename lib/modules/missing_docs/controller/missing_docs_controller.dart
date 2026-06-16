import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/missing_document_model.dart';
import '../../../data/repositories/missing_document_repository.dart';

class MissingDocsController extends GetxController {
  final MissingDocumentRepository _repo;

  MissingDocsController({MissingDocumentRepository? repo})
      : _repo = repo ?? MissingDocumentRepository();

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final docs = <MissingDocumentModel>[].obs;
  final selectedDoc = Rxn<MissingDocumentModel>();
  final pickedPhoto = Rxn<XFile>();
  final currentPosition = Rxn<Position>();

  final titleController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;
  final lastSeenController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    try {
      isLoading.value = true;
      docs.value = await _repo.getAll();
    } on DioException catch (e) {
      AppSnackbar.error(_msg(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDoc(String id) async {
    try {
      isLoading.value = true;
      selectedDoc.value = await _repo.getById(id);
    } on DioException catch (e) {
      AppSnackbar.error(_msg(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> captureLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackbar.warning('Activez la géolocalisation.');
        return;
      }
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      currentPosition.value = pos;
      AppSnackbar.success('Position capturée !');
    } catch (_) {
      AppSnackbar.error('Impossible de récupérer la position.');
    }
  }

  Future<void> pickPhoto() async {
    final f = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (f != null) pickedPhoto.value = f;
  }

  Future<void> submit() async {
    if (titleController.value.text.isEmpty ||
        descriptionController.value.text.isEmpty) {
      AppSnackbar.warning('Remplissez les champs obligatoires.');
      return;
    }
    try {
      isSubmitting.value = true;
      MultipartFile? multiFile;
      if (pickedPhoto.value != null) {
        multiFile = await MultipartFile.fromFile(pickedPhoto.value!.path,
            filename: pickedPhoto.value!.name);
      }
      await _repo.create(
        title: titleController.value.text.trim(),
        description: descriptionController.value.text.trim(),
        lastSeenLocation: lastSeenController.value.text.isEmpty
            ? null
            : lastSeenController.value.text.trim(),
        latitude: currentPosition.value?.latitude,
        longitude: currentPosition.value?.longitude,
        file: multiFile,
      );
      AppSnackbar.success('Signalement publié !');
      _clear();
      await fetchAll();
      Get.back();
    } on DioException catch (e) {
      AppSnackbar.error(_msg(e));
    } finally {
      isSubmitting.value = false;
    }
  }

  void _clear() {
    titleController.value.clear();
    descriptionController.value.clear();
    lastSeenController.value.clear();
    pickedPhoto.value = null;
    currentPosition.value = null;
  }

  String _msg(DioException e) =>
      e.error?.toString().split(':').last.trim() ?? 'Erreur réseau';
}
