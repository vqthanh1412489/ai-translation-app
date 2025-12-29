import 'package:get/get.dart';
import '../../../app/data/repositories/settings_repository.dart';
import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(Get.find<SettingsRepository>()),
    );
  }
}
