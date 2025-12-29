import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../app/data/models/job.dart';
import '../../../app/data/repositories/llm_repository.dart';
import '../../../app/data/repositories/job_repository.dart';
import '../../../app/data/repositories/settings_repository.dart';
import '../../../app/core/logger.dart';

class HomeController extends GetxController {
  final LlmRepository _llmRepository;
  final JobRepository _jobRepository;
  final SettingsRepository _settingsRepository;

  HomeController(
    this._llmRepository,
    this._jobRepository,
    this._settingsRepository,
  );

  // State
  final sourceText = ''.obs;
  final isRunning = false.obs;
  final currentStep = 0.obs; // 0=idle, 1=translator, 2=stylist, 3=qa
  final progress = 0.0.obs;

  final step1Text = ''.obs;
  final step2Text = ''.obs;
  final finalText = ''.obs;

  final step1RawJson = ''.obs;
  final step2RawJson = ''.obs;
  final step3RawJson = ''.obs;

  final qaIssues = <Map<String, dynamic>>[].obs;
  final score = 0.obs;

  final errorMessage = ''.obs;

  CancelToken? _cancelToken;
  Job? _currentJob;

  Future<void> runJob() async {
    if (sourceText.value.trim().isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng nhập văn bản cần dịch',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final settings = _settingsRepository.currentSettings;

    if (settings.baseUrl.isEmpty || settings.apiKey.isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng cấu hình API trong Settings',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Reset state
    isRunning.value = true;
    currentStep.value = 0;
    progress.value = 0.0;
    errorMessage.value = '';
    step1Text.value = '';
    step2Text.value = '';
    finalText.value = '';
    step1RawJson.value = '';
    step2RawJson.value = '';
    step3RawJson.value = '';
    qaIssues.clear();
    score.value = 0;

    _cancelToken = CancelToken();

    // Create job
    final jobId = const Uuid().v4();
    _currentJob = Job(
      id: jobId,
      createdAt: DateTime.now().toIso8601String(),
      sourceText: sourceText.value,
      targetLang: settings.targetLang,
      toneProfile: settings.toneProfile,
      formatRules: settings.formatRules,
      glossary: settings.glossary,
      status: 'running',
    );

    try {
      // Step 1: Translator
      AppLogger.info('Starting Step 1: Translator');
      currentStep.value = 1;
      progress.value = 0.33;

      final step1Result = await _llmRepository.runAgent1Translate(
        sourceText: sourceText.value,
        settings: settings,
        cancelToken: _cancelToken,
      );

      if (step1Result['success'] != true) {
        throw Exception(step1Result['error'] ?? 'Step 1 failed');
      }

      step1RawJson.value = step1Result['raw'] ?? '';
      final step1Data = step1Result['data'];
      step1Text.value = step1Data['translation'] ?? '';

      _currentJob = _currentJob!.copyWith(
        step1JsonRaw: step1RawJson.value,
        step1Text: step1Text.value,
      );

      AppLogger.info('Step 1 completed');

      // Step 2: Stylist
      AppLogger.info('Starting Step 2: Stylist');
      currentStep.value = 2;
      progress.value = 0.66;

      final step2Result = await _llmRepository.runAgent2Style(
        sourceText: sourceText.value,
        step1Translation: step1Text.value,
        settings: settings,
        cancelToken: _cancelToken,
      );

      if (step2Result['success'] != true) {
        throw Exception(step2Result['error'] ?? 'Step 2 failed');
      }

      step2RawJson.value = step2Result['raw'] ?? '';
      final step2Data = step2Result['data'];
      step2Text.value = step2Data['refined'] ?? '';

      _currentJob = _currentJob!.copyWith(
        step2JsonRaw: step2RawJson.value,
        step2Text: step2Text.value,
      );

      AppLogger.info('Step 2 completed');

      // Step 3: QA
      AppLogger.info('Starting Step 3: QA');
      currentStep.value = 3;
      progress.value = 1.0;

      final step3Result = await _llmRepository.runAgent3Qa(
        sourceText: sourceText.value,
        step2Refined: step2Text.value,
        settings: settings,
        cancelToken: _cancelToken,
      );

      if (step3Result['success'] != true) {
        throw Exception(step3Result['error'] ?? 'Step 3 failed');
      }

      step3RawJson.value = step3Result['raw'] ?? '';
      final step3Data = step3Result['data'];
      finalText.value = step3Data['final'] ?? '';

      final issuesList = step3Data['issues'];
      if (issuesList != null && issuesList is List) {
        qaIssues.value = List<Map<String, dynamic>>.from(
          issuesList.map((e) => Map<String, dynamic>.from(e)),
        );
      }

      score.value = step3Data['score'] ?? 0;

      _currentJob = _currentJob!.copyWith(
        step3JsonRaw: step3RawJson.value,
        finalText: finalText.value,
        qaIssues: qaIssues,
        score: score.value,
        status: 'done',
      );

      AppLogger.info('Step 3 completed');

      // Save job
      await _jobRepository.saveJob(_currentJob!);

      Get.snackbar(
        'Thành công',
        'Dịch hoàn tất! Score: ${score.value}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      AppLogger.error('Job failed', e, stackTrace);
      errorMessage.value = e.toString();

      _currentJob = _currentJob!.copyWith(
        status: 'error',
        errorMessage: e.toString(),
      );

      await _jobRepository.saveJob(_currentJob!);

      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isRunning.value = false;
      _cancelToken = null;
    }
  }

  void cancelJob() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('User cancelled');
      isRunning.value = false;
      errorMessage.value = 'Đã hủy bởi người dùng';

      if (_currentJob != null) {
        _currentJob = _currentJob!.copyWith(
          status: 'cancelled',
          errorMessage: 'Cancelled by user',
        );
        _jobRepository.saveJob(_currentJob!);
      }

      Get.snackbar(
        'Đã hủy',
        'Job đã được hủy',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void clearAll() {
    sourceText.value = '';
    step1Text.value = '';
    step2Text.value = '';
    finalText.value = '';
    step1RawJson.value = '';
    step2RawJson.value = '';
    step3RawJson.value = '';
    qaIssues.clear();
    score.value = 0;
    errorMessage.value = '';
    currentStep.value = 0;
    progress.value = 0.0;
  }
}
