import 'package:get/get.dart';
import '../../../app/data/providers/llm_provider.dart';
import '../../../app/data/providers/storage_provider.dart';
import '../../../app/data/repositories/llm_repository.dart';
import '../../../app/data/repositories/job_repository.dart';
import '../../../app/data/repositories/settings_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Providers
    Get.lazyPut<StorageProvider>(() => StorageProvider(), fenix: true);
    Get.lazyPut<LlmProvider>(() => LlmProvider(), fenix: true);

    // Repositories
    Get.lazyPut<SettingsRepository>(
      () => SettingsRepository(Get.find<StorageProvider>()),
      fenix: true,
    );
    Get.lazyPut<JobRepository>(
      () => JobRepository(Get.find<StorageProvider>()),
      fenix: true,
    );
    Get.lazyPut<LlmRepository>(
      () => LlmRepository(Get.find<LlmProvider>()),
      fenix: true,
    );

    // Controller
    Get.lazyPut<HomeController>(
      () => HomeController(
        Get.find<LlmRepository>(),
        Get.find<JobRepository>(),
        Get.find<SettingsRepository>(),
      ),
    );
  }
}
