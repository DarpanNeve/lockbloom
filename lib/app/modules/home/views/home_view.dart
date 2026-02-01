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
      body: Obx(() {
        final index = controller.currentIndex.value;
        return IndexedStack(
          index: index,
          children: const [
             _HomeTab(),
             SavedPasswordsView(),
             SettingsView(),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
           top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
             width: 1,
          ),
        ),
      ),
      child: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changePage,
          // ThemeService handles styling now, but we add custom icons here
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard_rounded),
              label: 'home'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.lock_clock_outlined),
              selectedIcon: const Icon(Icons.lock_clock_rounded),
              label: 'vault'.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.tune_outlined),
              selectedIcon: const Icon(Icons.tune_rounded),
              label: 'settings'.tr,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: true,
          snap: true,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'app_name'.tr, 
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20.sp,
              fontFamily: 'Inter',
            ),
          ),
          actions: [
            Padding(
             padding: EdgeInsets.only(right: 16.w),
             child: CircleAvatar(
               backgroundColor: Theme.of(context).colorScheme.primaryContainer,
               radius: 16.w,
               child: Image.asset('assets/images/icon.png', width: 20.w),
             ),
            ),
          ],
        ),
        
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd.w),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
               _buildWelcomeBanner(context),
               SizedBox(height: 32.h),
               _buildSectionHeader(context, 'quick_actions'.tr),
               SizedBox(height: 16.h),
               _buildQuickActionsGrid(context),
               SizedBox(height: 32.h),
               const PasswordGeneratorCard(),
               SizedBox(height: 32.h),
               _buildStatisticsSection(context),
               SizedBox(height: 32.h),
               _buildSectionHeader(context, 'recent_passwords'.tr),
               SizedBox(height: 16.h),
               const RecentPasswordsList(),
               SizedBox(height: 100.h),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeBanner(BuildContext context) {
     return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
               Icon(Icons.waving_hand_rounded, color: Colors.white, size: 24.sp),
               SizedBox(width: 8.w),
               Text(
                'welcome_back'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'welcome_message'.tr,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.add_rounded,
            title: 'add_password'.tr,
            color: Theme.of(context).colorScheme.primary,
            onTap: () => Get.bottomSheet(
                const AddPasswordSheet(),
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
              ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.grid_view_rounded,
            title: 'browse_vault'.tr,
            color: Theme.of(context).colorScheme.secondary,
            onTap: () => Get.find<HomeController>().changePage(1),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, {required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24.w),
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    final passwordController = Get.find<PasswordController>();
    return Obx(() {
       final stats = passwordController.passwordStats;
       if (stats.isEmpty) return const SizedBox.shrink();

       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           _buildSectionHeader(context, 'statistics'.tr),
           SizedBox(height: 16.h),
           Container(
             padding: EdgeInsets.all(20.w),
             decoration: BoxDecoration(
               color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
               borderRadius: BorderRadius.circular(24),
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 _buildStatItem(context, (stats['total'] ?? 0).toString(), 'total_passwords'.tr),
                 Container(width: 1, height: 40.h, color: Theme.of(context).dividerColor),
                 _buildStatItem(context, (stats['favorites'] ?? 0).toString(), 'favorites'.tr),
               ],
             ),
           ),
         ],
       );
    });
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
