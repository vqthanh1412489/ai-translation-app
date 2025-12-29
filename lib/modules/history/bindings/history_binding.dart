import 'package:get/get.dart';
import '../../../app/data/repositories/job_repository.dart';
import '../controllers/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(
      () => HistoryController(Get.find<JobRepository>()),
    );
  }
}
