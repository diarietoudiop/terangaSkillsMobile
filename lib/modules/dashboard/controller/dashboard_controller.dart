import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/error_translator.dart';
import '../../../data/models/dashboard_model.dart';
import '../../../data/repositories/dashboard_repository.dart';

class DashboardController extends GetxController {
  final DashboardRepository _repo;

  DashboardController({DashboardRepository? repo})
    : _repo = repo ?? DashboardRepository();

  final isLoading = false.obs;
  final stats = Rxn<DashboardStatsModel>();

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      isLoading.value = true;
      stats.value = await _repo.getStats();
    } on DioException catch (e) {
      final rawMsg = e.response?.data?['message']?.toString() ??
          e.error?.toString().split(':').last.trim() ??
          'Impossible de charger les statistiques';
      AppSnackbar.error(ErrorTranslator.translate(rawMsg));
    } catch (e) {
      AppSnackbar.error(ErrorTranslator.translate('Erreur: $e'));
    } finally {
      isLoading.value = false;
    }
  }
}
