import 'package:get/get.dart';
import '../../../app/data/models/job.dart';
import '../../../app/data/repositories/job_repository.dart';
import '../../../app/core/logger.dart';

class HistoryController extends GetxController {
  final JobRepository _jobRepository;

  HistoryController(this._jobRepository);

  final jobs = <Job>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadJobs();
  }

  void loadJobs() {
    try {
      isLoading.value = true;
      jobs.value = _jobRepository.listJobs();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load jobs', e, stackTrace);
      Get.snackbar(
        'Lỗi',
        'Không thể tải lịch sử: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteJob(String id) async {
    try {
      await _jobRepository.deleteJob(id);
      jobs.removeWhere((job) => job.id == id);
      Get.snackbar(
        'Thành công',
        'Đã xóa job',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to delete job', e, stackTrace);
      Get.snackbar(
        'Lỗi',
        'Không thể xóa job: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void refresh() {
    loadJobs();
  }
}
