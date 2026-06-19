import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/home_controller.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final homeController = Get.find<HomeController>();
    final connService = Get.find<ConnectivityService>();
    final isDarkMode =
        (GetStorage().read<bool>('is_dark_mode') ?? Get.isPlatformDarkMode).obs;

    return Drawer(
      backgroundColor: AppColors.darkBackground,
      child: SafeArea(
        child: Column(
          children: [
            // ─── Header: User Profile ─────────────────────
            Obx(() {
              final user = auth.currentUser.value;
              final firstName = user?.firstName ?? '';
              final lastName = user?.lastName ?? '';
              final email = user?.email ?? '';
              final phone = user?.phone ?? 'Non spécifié';
              final initial = firstName.isNotEmpty
                  ? firstName[0].toUpperCase()
                  : 'U';

              String roleText = user?.role == 'AGENT' ? 'Agent' : 'Citoyen';
              if (user?.isAgent == true && user?.service != null) {
                final srvName =
                    user!.service!['name'] ?? user.service!['title'] ?? '';
                if (srvName.isNotEmpty) {
                  roleText += ' - Service $srvName';
                }
              }

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.darkBorder, width: 0.8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          child: Text(
                            initial,
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$firstName $lastName',
                                style: AppTextStyles.titleLarge.copyWith(
                                  color: AppColors.text,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.grey400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  roleText,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Phone Info Card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.darkBorder.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.call,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tél : $phone',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Get.isDarkMode
                                  ? AppColors.grey300
                                  : AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Connectivity Badge inside Drawer
                    Obx(() {
                      final connected = connService.isConnected.value;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: connected
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: connected
                                ? AppColors.success.withOpacity(0.3)
                                : AppColors.error.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              connected
                                  ? Icons.wifi_rounded
                                  : Icons.wifi_off_rounded,
                              color: connected
                                  ? AppColors.success
                                  : AppColors.error,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              connected
                                  ? 'Connexion : En ligne'
                                  : 'Connexion : Hors ligne',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: connected
                                    ? AppColors.success
                                    : AppColors.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),

            // ─── Menu Navigation Options ───────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                children: [
                  _DrawerItem(
                    icon: Iconsax.home,
                    label: 'Accueil',
                    onTap: () {
                      Get.back(); // close drawer
                      homeController.changeTab(0);
                    },
                  ),
                  _DrawerItem(
                    icon: Iconsax.document,
                    label: 'Mes Demandes',
                    onTap: () {
                      Get.back();
                      homeController.changeTab(1);
                    },
                  ),
                  _DrawerItem(
                    icon: Iconsax.danger,
                    label: 'Mes Réclamations',
                    onTap: () {
                      Get.back();
                      homeController.changeTab(2);
                    },
                  ),
                  _DrawerItem(
                    icon: Iconsax.search_normal_1,
                    label: 'Mes Documents',
                    onTap: () {
                      Get.back();
                      homeController.changeTab(3);
                    },
                  ),
                  _DrawerItem(
                    icon: Iconsax.building,
                    label: 'Projets d\'Investissement',
                    onTap: () {
                      Get.back();
                      Get.toNamed(AppRoutes.investmentProjectsList);
                    },
                  ),
                  Divider(
                    color: AppColors.darkBorder,
                    height: 24,
                    thickness: 0.8,
                  ),
                  _DrawerItem(
                    icon: Iconsax.scan,
                    label: 'Scanner QR Code',
                    onTap: () {
                      Get.back();
                      Get.toNamed(AppRoutes.qrScan);
                    },
                  ),
                  if (auth.currentUser.value?.isAgent == false) ...[
                    _DrawerItem(
                      icon: Iconsax.messages_1,
                      label: 'Assistant IA Wolof',
                      onTap: () {
                        Get.back();
                        Get.toNamed(AppRoutes.aiAssistant);
                      },
                    ),
                    Divider(
                      color: AppColors.darkBorder,
                      height: 24,
                      thickness: 0.8,
                    ),
                  ],
                  Obx(
                    () => ListTile(
                      leading: Icon(
                        isDarkMode.value ? Iconsax.moon : Iconsax.sun_1,
                        color: AppColors.grey400,
                        size: 22,
                      ),
                      title: Text(
                        'Mode sombre',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Switch.adaptive(
                        value: isDarkMode.value,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          isDarkMode.value = val;
                          GetStorage().write('is_dark_mode', val);
                          Get.changeThemeMode(
                            val ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Footer: Log Out ───────────────────────────
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.darkBorder, width: 0.8),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.back();
                    auth.logout();
                  },
                  icon: const Icon(Iconsax.logout, color: AppColors.error),
                  label: Text(
                    'Se déconnecter',
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey400, size: 22),
      title: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: AppColors.primary.withOpacity(0.08),
      splashColor: AppColors.primary.withOpacity(0.15),
    );
  }
}
