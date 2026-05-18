import 'package:flutter/material.dart';
import 'core/di.dart';
import 'core/theme/app_theme.dart';
import 'features/food/presentation/pages/food_list_page.dart';

void main() {
  setupDI();
  runApp(const FoodBankApp());
}

class FoodBankApp extends StatelessWidget {
  const FoodBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Bank',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const FoodListPage(),
    );
  }
}
