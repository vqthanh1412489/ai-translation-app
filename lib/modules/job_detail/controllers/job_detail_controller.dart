import 'package:get/get.dart';
import '../../../app/data/models/job.dart';
import '../../../app/data/repositories/job_repository.dart';
import '../../../app/core/logger.dart';

class JobDetailController extends GetxController {
  final JobRepository _jobRepository;

  JobDetailController(this._jobRepository);

  final job = Rxn<Job>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final jobId = Get.parameters['id'];
    if (jobId != null) {
      loadJob(jobId);
    }
  }

  void loadJob(String id) {
    try {
      isLoading.value = true;
      job.value = _jobRepository.getJob(id);
      if (job.value == null) {
        Get.snackbar(
          'Lỗi',
          'Không tìm thấy job',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back();
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load job', e, stackTrace);
      Get.snackbar(
        'Lỗi',
        'Không thể tải job: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
