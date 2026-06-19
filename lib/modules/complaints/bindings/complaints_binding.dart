import 'package:get/get.dart';
import '../controller/complaints_controller.dart';
import '../../../data/repositories/complaint_repository.dart';

class ComplaintsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComplaintRepository>(() => ComplaintRepository());
    Get.lazyPut<ComplaintsController>(
      () => ComplaintsController(repo: Get.find<ComplaintRepository>()),
    );
  }
}
