import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:learn_flutter/core/app_theme.dart';
import 'package:learn_flutter/routes/app_binding.dart';
import 'package:learn_flutter/routes/app_pages.dart';
import 'package:learn_flutter/routes/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snack App',
      theme: AppTheme.light(),
      initialRoute: AppRoutes.home,
      getPages: AppPages.routes,
      initialBinding: AppBinding(),
    );
  }
}
