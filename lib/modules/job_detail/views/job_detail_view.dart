import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/job_detail_controller.dart';
import '../../../app/core/utils.dart';

class JobDetailView extends GetView<JobDetailController> {
  const JobDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Detail'),
      ),
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final job = controller.job.value;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (job == null) {
          return const Center(child: Text('Job not found'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Job Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Job Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('ID: ${job.id}'),
                    Text('Created: ${AppUtils.formatDateTime(job.createdAt)}'),
                    Text('Status: ${AppUtils.getJobStatusLabel(job.status)}'),
                    if (job.score != null) Text('Score: ${job.score}'),
                    if (job.errorMessage != null)
                      Text(
                        'Error: ${job.errorMessage}',
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Source Text
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Source Text',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    SelectableText(job.sourceText),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Final Text
            if (job.finalText != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Final Translation',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SelectableText(job.finalText!),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // QA Issues
            if (job.qaIssues != null && job.qaIssues!.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'QA Issues',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...job.qaIssues!.map((issue) => ListTile(
                            leading: Icon(
                              _getIssueIcon(issue['severity']),
                              color: _getIssueSeverityColor(issue['severity']),
                            ),
                            title: Text(issue['type'] ?? ''),
                            subtitle: Text(issue['suggestion'] ?? ''),
                          )),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Raw JSON Sections
            ExpansionTile(
              title: const Text('Step 1 Raw JSON'),
              children: [
                if (job.step1JsonRaw != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      job.step1JsonRaw!,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No data'),
                  ),
              ],
            ),
            ExpansionTile(
              title: const Text('Step 2 Raw JSON'),
              children: [
                if (job.step2JsonRaw != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      job.step2JsonRaw!,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No data'),
                  ),
              ],
            ),
            ExpansionTile(
              title: const Text('Step 3 Raw JSON'),
              children: [
                if (job.step3JsonRaw != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      job.step3JsonRaw!,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No data'),
                  ),
              ],
            ),
          ],
        );
      }),
    );
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
}
