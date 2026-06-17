import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/document_model.dart';
import '../../../data/repositories/document_repository.dart';

class QrController extends GetxController {
  final DocumentRepository _repo;

  QrController({DocumentRepository? repo})
      : _repo = repo ?? DocumentRepository();

  final isVerifying = false.obs;
  final verificationResult = Rxn<DocumentVerificationModel>();
  final scannedCode = ''.obs;

  void onQrDetected(String code) {
    if (scannedCode.value == code || isVerifying.value) return;
    scannedCode.value = code;
    // Extract document ID from the QR code URL
    final id = _extractDocumentId(code);
    if (id != null) {
      verifyDocument(id);
    } else {
      AppSnackbar.warning('QR Code non reconnu.');
    }
  }

  String? _extractDocumentId(String raw) {
    // Robustly extract standard 36-char UUID format from any URL or string
    final uuidRegex = RegExp(
        r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}');
    final match = uuidRegex.firstMatch(raw);
    if (match != null) {
      return match.group(0);
    }
    return null;
  }

  Future<void> verifyDocument(String id) async {
    try {
      isVerifying.value = true;
      verificationResult.value = null;
      final result = await _repo.verifyDocument(id);
      verificationResult.value = result;
    } on DioException catch (e) {
      AppSnackbar.error(e.error?.toString().split(':').last.trim() ??
          'Erreur de vérification');
    } finally {
      isVerifying.value = false;
    }
  }

  void reset() {
    scannedCode.value = '';
    verificationResult.value = null;
  }
}
