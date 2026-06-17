import 'package:get/get.dart';
import '../controller/dashboard_controller.dart';
import '../../../data/repositories/dashboard_repository.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRepository>(() => DashboardRepository());
    Get.lazyPut<DashboardController>(
        () => DashboardController(repo: Get.find<DashboardRepository>()));
  }
}
