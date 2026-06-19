import 'package:get/get.dart';
import '../../../data/models/investment_project_model.dart';
import '../../../data/repositories/investment_project_repository.dart';

class InvestmentProjectsController extends GetxController {
  final InvestmentProjectRepository _repository;

  InvestmentProjectsController({InvestmentProjectRepository? repository})
    : _repository = repository ?? InvestmentProjectRepository();

  final projects = <InvestmentProjectModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    isLoading.value = true;
    error.value = '';
    try {
      final res = await _repository.getProjects();
      projects.value = res;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() => fetchProjects();
}
