import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/controllers/password_controller.dart';
import 'package:lockbloom/app/modules/home/controllers/home_controller.dart';
import 'package:lockbloom/app/routes/app_pages.dart';
import 'package:lockbloom/app/widgets/password_generator_card.dart';
import 'package:lockbloom/app/widgets/password_strength_indicator.dart';
import 'package:lockbloom/app/widgets/recent_passwords_list.dart';
import 'package:lockbloom/app/modules/saved_passwords/views/saved_passwords_view.dart';
import 'package:lockbloom/app/modules/settings/views/settings_view.dart';
import 'package:lockbloom/app/themes/app_theme.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      Scaffold(
        appBar: AppBar(title: const Text('LockBloom'), centerTitle: true),
        body: SingleChildScrollView(
          // The original HomeView content
          padding: EdgeInsets.all(AppTheme.spacingMd.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(context),

              SizedBox(height: AppTheme.spacingXl.h),

              // Password Generator Card
              const PasswordGeneratorCard(),

              SizedBox(height: AppTheme.spacingXl.h),

              // Quick Actions
              _buildQuickActions(context),

              SizedBox(height: AppTheme.spacingXl.h),

              // Recent Passwords
              _buildRecentPasswordsSection(context),

              SizedBox(height: AppTheme.spacingXl.h),

              // Statistics
              _buildStatisticsSection(context),
            ],
          ),
        ),
      ),
      const SavedPasswordsView(), // Saved Passwords page
      const SettingsView(), // Settings page
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: _pages,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppTheme.spacingLg.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.spacingMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(height: AppTheme.spacingSm.h),
          Text(
            'Generate secure passwords and manage your credentials safely.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
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
        Text('Quick Actions', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: AppTheme.spacingMd.h),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.add_rounded,
                title: 'Add Password',
                subtitle: 'Save a new password',
                onTap: () => _showAddPasswordDialog(context),
              ),
            ),
            SizedBox(width: AppTheme.spacingMd.w),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.list_rounded,
                title: 'View All',
                subtitle: 'Browse passwords',
                onTap: () => Get.toNamed(Routes.SAVED_PASSWORDS),
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingMd.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              SizedBox(height: AppTheme.spacingMd.h),
              Container(
                padding: EdgeInsets.all(AppTheme.spacingSm.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
              SizedBox(height: AppTheme.spacingMd.h),
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
                style: Theme.of(context).textTheme.labelLarge,
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
              'Recent Passwords',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextButton(
              onPressed: () => Get.toNamed(Routes.SAVED_PASSWORDS),
              child: const Text('View All'),
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

    return FutureBuilder<Map<String, dynamic>>(
      future: passwordController.getPasswordStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final stats = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: AppTheme.spacingMd.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'Total Passwords',
                    value: stats['total'].toString(),
                    icon: Icons.lock_rounded,
                  ),
                ),
                SizedBox(width: AppTheme.spacingMd.w),
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'Favorites',
                    value: stats['favorites'].toString(),
                    icon: Icons.favorite_rounded,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingMd.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.w,
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacingSm.h),
            Text(
              title, 
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changePage,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'Passwords',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _showAddPasswordDialog(BuildContext context) {
    final passwordController = Get.find<PasswordController>();

    Get.dialog(
      AlertDialog(
        title: const Text('Quick Save Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: passwordController.labelController,
              decoration: const InputDecoration(
                labelText: 'Label',
                hintText: 'e.g., Gmail, Facebook',
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: passwordController.usernameController,
              decoration: const InputDecoration(labelText: 'Username/Email'),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: passwordController.passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    passwordController.passwordController.text =
                        passwordController.generatedPassword.value;
                  },
                  icon: const Icon(Icons.auto_awesome),
                  tooltip: 'Use Generated Password',
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              passwordController.savePassword(
                label: passwordController.labelController.text,
                username: passwordController.usernameController.text,
                password: passwordController.passwordController.text,
              );
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
