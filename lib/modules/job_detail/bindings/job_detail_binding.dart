import 'package:get/get.dart';
import '../../../app/data/repositories/job_repository.dart';
import '../controllers/job_detail_controller.dart';

class JobDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobDetailController>(
      () => JobDetailController(Get.find<JobRepository>()),
    );
  }
}
