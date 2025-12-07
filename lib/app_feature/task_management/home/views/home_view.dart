import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DevMind',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Your Developer Companion',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      size: 28.sp,
                    ),
                    onPressed: () {
                      Get.changeThemeMode(
                        isDark ? ThemeMode.light : ThemeMode.dark,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              
              // Welcome Section
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back! 👋',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Organize your code snippets and plans in one place',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              
              // Features Grid
              Text(
                'Features',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  return Wrap(
                    spacing: 16.w,
                    runSpacing: 16.h,
                    children: [
                      _buildFeatureCard(
                        context,
                        icon: Icons.code,
                        title: 'Code Snippets',
                        description: 'Store and manage your code snippets',
                        color: const Color(0xFF3F51B5),
                        onTap: () => Get.toNamed('/snippets'),
                        width: isWide ? (constraints.maxWidth - 16.w) / 2 : constraints.maxWidth,
                      ),
                      _buildFeatureCard(
                        context,
                        icon: Icons.calendar_today,
                        title: 'Planner',
                        description: 'Plan your next development tasks',
                        color: const Color(0xFFFF5722),
                        onTap: () => Get.toNamed('/planner'),
                        width: isWide ? (constraints.maxWidth - 16.w) / 2 : constraints.maxWidth,
                      ),
                      _buildFeatureCard(
                        context,
                        icon: Icons.smart_toy,
                        title: 'AI Assistant',
                        description: 'Coming soon - AI-powered coding help',
                        color: const Color(0xFF9C27B0),
                        onTap: () {
                          Get.snackbar(
                            'Coming Soon',
                            'AI features will be available in the next update',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        width: isWide ? (constraints.maxWidth - 16.w) / 2 : constraints.maxWidth,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
    required double width,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: width,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 32.sp,
                color: color,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
