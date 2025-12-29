class AppUtils {
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String formatDateTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoString;
    }
  }

  static String getJobStatusLabel(String status) {
    switch (status) {
      case 'idle':
        return 'Chờ';
      case 'running':
        return 'Đang chạy';
      case 'done':
        return 'Hoàn thành';
      case 'error':
        return 'Lỗi';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }
}
