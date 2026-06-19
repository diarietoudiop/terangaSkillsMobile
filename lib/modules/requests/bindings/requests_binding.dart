import 'package:get/get.dart';
import '../controller/requests_controller.dart';
import '../../../data/repositories/administrative_request_repository.dart';

class RequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdministrativeRequestRepository>(
      () => AdministrativeRequestRepository(),
    );
    Get.lazyPut<RequestsController>(
      () =>
          RequestsController(repo: Get.find<AdministrativeRequestRepository>()),
    );
  }
}
