import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/providers/storage_provider.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final storageProvider = StorageProvider();
  await storageProvider.init();

  // Put StorageProvider in GetX so it can be used by bindings
  Get.put(storageProvider, permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AI Translation Workflow',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.home,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
