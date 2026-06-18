import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../requests/views/requests_list_view.dart';
import '../../complaints/views/complaints_list_view.dart';
import '../../missing_docs/views/missing_docs_list_view.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../controller/home_controller.dart';
import '../widgets/home_tab.dart';
import '../widgets/profile_drawer.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Force dependency on Theme to trigger rebuild on theme mode change
    Theme.of(context);

    final pages = [
      HomeTab(),
      RequestsListView(),
      ComplaintsListView(),
      MissingDocsListView(),
      DashboardView(),
    ];

    return Obx(() => Scaffold(
          key: controller.scaffoldKey,
          drawer: const ProfileDrawer(),
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          ),
          floatingActionButton: _buildFab(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _buildBottomNav(),
        ));
  }

  Widget _buildFab() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.primaryLight, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _onFabPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add_rounded, size: 30, color: Colors.white),
      ),
    );
  }

  void _onFabPressed() {
    final idx = controller.currentIndex.value;
    switch (idx) {
      case 1:
        Get.toNamed(AppRoutes.createRequest);
        break;
      case 2:
        Get.toNamed(AppRoutes.createComplaint);
        break;
      case 3:
        Get.toNamed(AppRoutes.createMissingDoc);
        break;
      default:
        Get.toNamed(AppRoutes.createRequest);
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface.withOpacity(0.95),
        border: const Border(
          top: BorderSide(
            color: AppColors.darkBorder,
            width: 0.8,
          ),
        ),
      ),
      child: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavItem(
                      icon: Iconsax.home,
                      selectedIcon: Iconsax.home5,
                      label: 'Accueil',
                      index: 0,
                      current: controller.currentIndex.value,
                      onTap: () => controller.changeTab(0)),
                  _NavItem(
                      icon: Iconsax.document,
                      selectedIcon: Iconsax.document5,
                      label: 'Demandes',
                      index: 1,
                      current: controller.currentIndex.value,
                      onTap: () => controller.changeTab(1)),
                  const SizedBox(width: 48), // FAB space
                  _NavItem(
                      icon: Iconsax.danger,
                      selectedIcon: Iconsax.danger5,
                      label: 'Réclamations',
                      index: 2,
                      current: controller.currentIndex.value,
                      onTap: () => controller.changeTab(2)),
                  _NavItem(
                      icon: Iconsax.search_normal_1,
                      selectedIcon: Iconsax.search_status5,
                      label: 'Documents',
                      index: 3,
                      current: controller.currentIndex.value,
                      onTap: () => controller.changeTab(3)),
                ],
              )),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;
  final int current;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == current;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? AppColors.primary : AppColors.grey500,
                size: 22,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.grey500,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
