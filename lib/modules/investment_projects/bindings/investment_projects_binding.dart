import 'package:get/get.dart';
import '../controllers/investment_projects_controller.dart';

class InvestmentProjectsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvestmentProjectsController>(
      () => InvestmentProjectsController(),
    );
  }
}
