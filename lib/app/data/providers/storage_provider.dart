import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/app_settings.dart';
import '../models/job.dart';

class StorageProvider {
  static const String _settingsBoxName = 'settingsBox';
  static const String _jobsBoxName = 'jobsBox';
  static const String _settingsKey = 'app_settings';

  late Box _settingsBox;
  late Box _jobsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _settingsBox = await Hive.openBox(_settingsBoxName);
    _jobsBox = await Hive.openBox(_jobsBoxName);
  }

  // Settings
  Future<void> saveSettings(AppSettings settings) async {
    await _settingsBox.put(_settingsKey, settings.toJson());
  }

  AppSettings loadSettings() {
    try {
      final data = _settingsBox.get(_settingsKey);
      if (data != null) {
        return AppSettings.fromJson(Map<String, dynamic>.from(data));
      }
    } catch (e) {
      // If there's any error loading settings (e.g., corrupt data), return default
      debugPrint('Error loading settings: $e');
      // Clear corrupt data
      _settingsBox.delete(_settingsKey);
    }
    return AppSettings.defaultSettings();
  }

  // Jobs
  Future<void> saveJob(Job job) async {
    await _jobsBox.put(job.id, job.toJson());
  }

  List<Job> listJobs() {
    final jobs = <Job>[];
    for (var key in _jobsBox.keys) {
      final data = _jobsBox.get(key);
      if (data != null) {
        jobs.add(Job.fromJson(Map<String, dynamic>.from(data)));
      }
    }
    // Sort by createdAt descending
    jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return jobs;
  }

  Job? getJob(String id) {
    final data = _jobsBox.get(id);
    if (data != null) {
      return Job.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<void> deleteJob(String id) async {
    await _jobsBox.delete(id);
  }
}
