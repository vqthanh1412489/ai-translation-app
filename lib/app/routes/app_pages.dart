import 'package:get/get.dart';
import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/settings/bindings/settings_binding.dart';
import '../../modules/settings/views/settings_view.dart';
import '../../modules/history/bindings/history_binding.dart';
import '../../modules/history/views/history_view.dart';
import '../../modules/job_detail/bindings/job_detail_binding.dart';
import '../../modules/job_detail/views/job_detail_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.jobDetail,
      page: () => const JobDetailView(),
      binding: JobDetailBinding(),
    ),
  ];
}
