import 'package:get/get.dart';
import '../models/app_settings.dart';
import '../providers/storage_provider.dart';

class SettingsRepository {
  final StorageProvider _storageProvider;
  final Rx<AppSettings> settings = AppSettings.defaultSettings().obs;

  SettingsRepository(this._storageProvider) {
    loadSettings();
  }

  void loadSettings() {
    settings.value = _storageProvider.loadSettings();
  }

  Future<void> saveSettings(AppSettings newSettings) async {
    await _storageProvider.saveSettings(newSettings);
    settings.value = newSettings;
  }

  AppSettings get currentSettings => settings.value;
}
