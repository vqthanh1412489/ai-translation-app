import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../app/routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Translation'),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => Get.toNamed(AppRoutes.history),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Get.toNamed(AppRoutes.settings),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Step 1'),
              Tab(text: 'Step 2'),
              Tab(text: 'Final'),
              Tab(text: 'QA'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Input section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Văn bản cần dịch',
                      hintText: 'Nhập hoặc dán văn bản...',
                    ),
                    onChanged: (value) => controller.sourceText.value = value,
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final isRunning = controller.isRunning.value;
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: isRunning ? null : controller.runJob,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Chạy'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isRunning)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: controller.cancelJob,
                              icon: const Icon(Icons.stop),
                              label: const Text('Dừng'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        if (!isRunning)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: controller.clearAll,
                              icon: const Icon(Icons.clear),
                              label: const Text('Xóa'),
                            ),
                          ),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  // Step Progress Indicators
                  Obx(() {
                    final isRunning = controller.isRunning.value;
                    final currentStep = controller.currentStep.value;
                    final progress = controller.progress.value;
                    final finalText = controller.finalText.value;
                    final errorMessage = controller.errorMessage.value;

                    // Show success card when done
                    if (!isRunning &&
                        currentStep == 3 &&
                        finalText.isNotEmpty &&
                        errorMessage.isEmpty) {
                      return Card(
                        color: Colors.green.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green, size: 32),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hoàn thành!',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Dịch thành công với score: ${controller.score.value}/100',
                                      style: TextStyle(
                                          color: Colors.green.shade700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (!isRunning && currentStep == 0) {
                      return const SizedBox.shrink();
                    }

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Progress bar with percentage
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 8,
                                    backgroundColor: Colors.grey.shade200,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Step indicators
                            Row(
                              children: [
                                _buildStepIndicator(
                                  context,
                                  stepNumber: 1,
                                  label: 'Translator',
                                  icon: Icons.translate,
                                  isActive: currentStep == 1,
                                  isDone: currentStep > 1,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 2,
                                    color: currentStep > 1
                                        ? Colors.green
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                _buildStepIndicator(
                                  context,
                                  stepNumber: 2,
                                  label: 'Stylist',
                                  icon: Icons.style,
                                  isActive: currentStep == 2,
                                  isDone: currentStep > 2,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 2,
                                    color: currentStep > 2
                                        ? Colors.green
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                _buildStepIndicator(
                                  context,
                                  stepNumber: 3,
                                  label: 'QA',
                                  icon: Icons.verified,
                                  isActive: currentStep == 3,
                                  isDone: currentStep > 3,
                                ),
                              ],
                            ),
                            if (isRunning) ...[
                              const SizedBox(height: 12),
                              Center(
                                child: Text(
                                  _getStepLabel(currentStep),
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  // Error Log Display
                  Obx(() {
                    final errorMessage = controller.errorMessage.value;
                    if (errorMessage.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Card(
                      color: Colors.red.shade50,
                      child: ExpansionTile(
                        leading: const Icon(Icons.error, color: Colors.red),
                        title: const Text(
                          'Error Log',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Tap to view details',
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            color: Colors.red.shade100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Error Details:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.copy),
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(text: errorMessage),
                                        );
                                        Get.snackbar(
                                          'Copied',
                                          'Error message copied to clipboard',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
                                      tooltip: 'Copy error',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SelectableText(
                                  errorMessage,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const Divider(height: 1),
            // Tab content
            Expanded(
              child: TabBarView(
                children: [
                  _buildStep1Tab(),
                  _buildStep2Tab(),
                  _buildFinalTab(),
                  _buildQaTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepLabel(int step) {
    switch (step) {
      case 1:
        return 'Đang dịch (Step 1/3)...';
      case 2:
        return 'Đang chỉnh văn phong (Step 2/3)...';
      case 3:
        return 'Đang kiểm tra chất lượng (Step 3/3)...';
      default:
        return '';
    }
  }

  Widget _buildStep1Tab() {
    return Obx(() {
      final text = controller.step1Text.value;
      final rawJson = controller.step1RawJson.value;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Translation',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (text.isEmpty)
              const Text('Chưa có kết quả')
            else
              SelectableText(text),
            const SizedBox(height: 24),
            ExpansionTile(
              title: const Text('Raw JSON'),
              children: [
                if (rawJson.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Chưa có dữ liệu'),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(
                      rawJson,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStep2Tab() {
    return Obx(() {
      final text = controller.step2Text.value;
      final rawJson = controller.step2RawJson.value;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Refined',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (text.isEmpty)
              const Text('Chưa có kết quả')
            else
              SelectableText(text),
            const SizedBox(height: 24),
            ExpansionTile(
              title: const Text('Raw JSON'),
              children: [
                if (rawJson.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Chưa có dữ liệu'),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(
                      rawJson,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFinalTab() {
    return Obx(() {
      final text = controller.finalText.value;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Final Translation',
                  style: Get.textTheme.titleLarge,
                ),
                const Spacer(),
                if (text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: text));
                      Get.snackbar(
                        'Copied',
                        'Đã copy vào clipboard',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (text.isEmpty)
              const Text('Chưa có kết quả')
            else
              SelectableText(text),
          ],
        ),
      );
    });
  }

  Widget _buildQaTab() {
    return Obx(() {
      final score = controller.score.value;
      final issues = controller.qaIssues;
      final rawJson = controller.step3RawJson.value;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quality Score',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (score == 0)
              const Text('Chưa có kết quả')
            else
              Row(
                children: [
                  Text(
                    '$score',
                    style: Get.textTheme.displayMedium?.copyWith(
                      color: _getScoreColor(score),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(' / 100'),
                ],
              ),
            const SizedBox(height: 24),
            Text(
              'Issues',
              style: Get.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (issues.isEmpty)
              const Text('Không có vấn đề')
            else
              ...issues.map((issue) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        _getIssueIcon(issue['severity']),
                        color: _getIssueSeverityColor(issue['severity']),
                      ),
                      title: Text(issue['type'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (issue['source_excerpt'] != null)
                            Text('Source: ${issue['source_excerpt']}'),
                          if (issue['target_excerpt'] != null)
                            Text('Target: ${issue['target_excerpt']}'),
                          if (issue['suggestion'] != null)
                            Text(
                              'Suggestion: ${issue['suggestion']}',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )),
            const SizedBox(height: 24),
            ExpansionTile(
              title: const Text('Raw JSON'),
              children: [
                if (rawJson.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Chưa có dữ liệu'),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(
                      rawJson,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  IconData _getIssueIcon(String? severity) {
    switch (severity) {
      case 'high':
        return Icons.error;
      case 'medium':
        return Icons.warning;
      case 'low':
        return Icons.info;
      default:
        return Icons.help;
    }
  }

  Color _getIssueSeverityColor(String? severity) {
    switch (severity) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStepIndicator(
    BuildContext context, {
    required int stepNumber,
    required String label,
    required IconData icon,
    required bool isActive,
    required bool isDone,
  }) {
    Color color;
    if (isDone) {
      color = Colors.green;
    } else if (isActive) {
      color = Colors.blue;
    } else {
      color = Colors.grey;
    }

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDone
                ? Colors.green
                : isActive
                    ? Colors.blue
                    : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDone ? Icons.check : icon,
            color: isDone || isActive ? Colors.white : Colors.grey.shade600,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
}
