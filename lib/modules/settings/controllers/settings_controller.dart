import 'package:get/get.dart';
import '../../../app/data/models/app_settings.dart';
import '../../../app/data/models/agent_config.dart';
import '../../../app/data/repositories/settings_repository.dart';
import '../../../app/core/logger.dart';

class SettingsController extends GetxController {
  final SettingsRepository _settingsRepository;

  SettingsController(this._settingsRepository);

  // Rx settings
  late Rx<AppSettings> settings;

  @override
  void onInit() {
    super.onInit();
    settings = _settingsRepository.settings;
  }

  Future<void> saveSettings(AppSettings newSettings) async {
    try {
      await _settingsRepository.saveSettings(newSettings);
      Get.snackbar(
        'Thành công',
        'Đã lưu cài đặt',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save settings', e, stackTrace);
      Get.snackbar(
        'Lỗi',
        'Không thể lưu cài đặt: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void updateBaseUrl(String value) {
    settings.value = settings.value.copyWith(baseUrl: value);
  }

  void updateApiKey(String value) {
    settings.value = settings.value.copyWith(apiKey: value);
  }

  void updateTargetLang(String value) {
    settings.value = settings.value.copyWith(targetLang: value);
  }

  void updateToneProfile(String value) {
    settings.value = settings.value.copyWith(toneProfile: value);
  }

  void updateFormatRules(List<String> value) {
    settings.value = settings.value.copyWith(formatRules: value);
  }

  void updateGlossary(Map<String, String> value) {
    settings.value = settings.value.copyWith(glossary: value);
  }

  void updateAgent1(AgentConfig value) {
    settings.value = settings.value.copyWith(agent1: value);
  }

  void updateAgent2(AgentConfig value) {
    settings.value = settings.value.copyWith(agent2: value);
  }

  void updateAgent3(AgentConfig value) {
    settings.value = settings.value.copyWith(agent3: value);
  }

  Future<void> resetToDefaults() async {
    try {
      final defaultSettings = AppSettings.defaultSettings();
      await _settingsRepository.saveSettings(defaultSettings);
      Get.snackbar(
        'Thành công',
        'Đã khôi phục cài đặt mặc định',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to reset settings', e, stackTrace);
      Get.snackbar(
        'Lỗi',
        'Không thể khôi phục cài đặt: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
