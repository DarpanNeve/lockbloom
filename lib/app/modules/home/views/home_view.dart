import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
import 'package:lockbloom/app/modules/home/controllers/home_controller.dart';
import 'package:lockbloom/app/widgets/password_generator_card.dart';
import 'package:lockbloom/app/widgets/recent_passwords_list.dart';
import 'package:lockbloom/app/modules/saved_passwords/views/saved_passwords_view.dart';
import 'package:lockbloom/app/modules/settings/views/settings_view.dart';
import 'package:lockbloom/app/themes/app_theme.dart';
import 'package:lockbloom/app/modules/saved_passwords/views/widgets/add_password_sheet.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          final index = controller.currentIndex.value;
          switch (index) {
            case 0:
              return _buildHomeTab(context);
            case 1:
              return const SavedPasswordsView();
            case 2:
              return const SettingsView();
            default:
              return _buildHomeTab(context);
          }
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }
  
  Widget _buildHomeTab(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/icon.png',
              height: 24.w,
              width: 24.w,
            ),
            SizedBox(width: AppTheme.spacingSm.w),
            Text('app_name'.tr),
          ],
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppTheme.spacingMd.w),
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(context),

              SizedBox(height: AppTheme.spacingXl.h),

              const PasswordGeneratorCard(),

              SizedBox(height: AppTheme.spacingXl.h),

              _buildQuickActions(context),

              SizedBox(height: AppTheme.spacingXl.h),

              _buildRecentPasswordsSection(context),

              SizedBox(height: AppTheme.spacingXl.h),

              _buildStatisticsSection(context),
              
              SizedBox(height: AppTheme.spacingXl.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppTheme.spacingLg.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'welcome_back'.tr,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppTheme.spacingSm.h),
          Text(
            'welcome_message'.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'quick_actions'.tr, 
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppTheme.spacingMd.h),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.add_circle_outline_rounded,
                title: 'add_password'.tr,
                subtitle: 'save_new'.tr,
                onTap: () => Get.bottomSheet(
                  const AddPasswordSheet(),
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                ),
              ),
            ),
            SizedBox(width: AppTheme.spacingMd.w),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.view_list_rounded,
                title: 'view_all'.tr,
                subtitle: 'browse_vault'.tr,
                onTap: () => controller.changePage(1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingMd.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(AppTheme.spacingSm.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.w,
                ),
              ),
              SizedBox(height: AppTheme.spacingMd.h),
              Text(
                title, 
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppTheme.spacingXs.h),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentPasswordsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'recent_passwords'.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => controller.changePage(1),
              child: Text('view_all'.tr),
            ),
          ],
        ),
        SizedBox(height: AppTheme.spacingMd.h),
        const RecentPasswordsList(),
      ],
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    final passwordController = Get.find<PasswordController>();

    return Obx(() {
      final stats = passwordController.passwordStats;
      if (stats.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'statistics'.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppTheme.spacingMd.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'total_passwords'.tr,
                  value: (stats['total'] ?? 0).toString(),
                  icon: Icons.lock_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(width: AppTheme.spacingMd.w),
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'favorites'.tr,
                  value: (stats['favorites'] ?? 0).toString(),
                  icon: Icons.favorite_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingMd.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(AppTheme.spacingXs.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20.w,
                  ),
                ),
                Text(
                  value, 
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacingSm.h),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changePage,
          backgroundColor: Colors.transparent,
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          elevation: 0,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: 'home'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.lock_outline_rounded),
              selectedIcon: const Icon(Icons.lock_rounded),
              label: 'vault'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings_rounded),
              label: 'settings'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
