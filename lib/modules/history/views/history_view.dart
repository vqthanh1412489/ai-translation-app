import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';
import '../../../app/core/utils.dart';
import '../../../app/routes/app_routes.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refresh,
          ),
        ],
      ),
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final jobs = controller.jobs;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (jobs.isEmpty) {
          return const Center(
            child: Text('Chưa có job nào'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(
                  AppUtils.truncateText(job.sourceText, 50),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(AppUtils.formatDateTime(job.createdAt)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildStatusChip(job.status),
                        if (job.score != null) ...[
                          const SizedBox(width: 8),
                          Chip(
                            label: Text('Score: ${job.score}'),
                            backgroundColor: _getScoreColor(job.score!),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmDelete(context, job.id),
                ),
                onTap: () => Get.toNamed(
                  AppRoutes.jobDetail.replaceAll(':id', job.id),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'done':
        color = Colors.green;
        break;
      case 'running':
        color = Colors.blue;
        break;
      case 'error':
        color = Colors.red;
        break;
      case 'cancelled':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(AppUtils.getJobStatusLabel(status)),
      backgroundColor: color.withOpacity(0.2),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green.withOpacity(0.2);
    if (score >= 60) return Colors.orange.withOpacity(0.2);
    return Colors.red.withOpacity(0.2);
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn xóa job này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteJob(id);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
