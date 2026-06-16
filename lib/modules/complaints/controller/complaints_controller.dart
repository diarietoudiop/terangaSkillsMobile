import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/complaint_model.dart';
import '../../../data/repositories/complaint_repository.dart';

class ComplaintsController extends GetxController {
  final ComplaintRepository _repo;

  ComplaintsController({ComplaintRepository? repo})
      : _repo = repo ?? ComplaintRepository();

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final complaints = <ComplaintModel>[].obs;
  final selectedComplaint = Rxn<ComplaintModel>();
  final pickedPhoto = Rxn<XFile>();
  final currentPosition = Rxn<Position>();

  final titleController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyComplaints();
  }

  Future<void> fetchMyComplaints() async {
    try {
      isLoading.value = true;
      complaints.value = await _repo.getMyComplaints();
    } on DioException catch (e) {
      AppSnackbar.error(_msg(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchComplaint(String id) async {
    try {
      isLoading.value = true;
      selectedComplaint.value = await _repo.getComplaint(id);
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
        AppSnackbar.warning('Veuillez activer la géolocalisation.');
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      currentPosition.value = pos;
      AppSnackbar.success('Position capturée !');
    } catch (e) {
      AppSnackbar.error('Impossible de récupérer la position.');
    }
  }

  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
        source: ImageSource.camera, imageQuality: 80);
    if (file != null) pickedPhoto.value = file;
  }

  Future<void> submitComplaint() async {
    if (titleController.value.text.isEmpty ||
        descriptionController.value.text.isEmpty) {
      AppSnackbar.warning('Veuillez remplir tous les champs.');
      return;
    }
    try {
      isSubmitting.value = true;
      MultipartFile? multiFile;
      if (pickedPhoto.value != null) {
        multiFile = await MultipartFile.fromFile(
          pickedPhoto.value!.path,
          filename: pickedPhoto.value!.name,
        );
      }
      await _repo.createComplaint(
        title: titleController.value.text.trim(),
        description: descriptionController.value.text.trim(),
        latitude: currentPosition.value?.latitude,
        longitude: currentPosition.value?.longitude,
        file: multiFile,
      );
      AppSnackbar.success('Réclamation soumise !');
      _clearForm();
      await fetchMyComplaints();
      Get.back();
    } on DioException catch (e) {
      AppSnackbar.error(_msg(e));
    } finally {
      isSubmitting.value = false;
    }
  }

  void _clearForm() {
    titleController.value.clear();
    descriptionController.value.clear();
    pickedPhoto.value = null;
    currentPosition.value = null;
  }

  String _msg(DioException e) =>
      e.error?.toString().split(':').last.trim() ?? 'Erreur réseau';
}
