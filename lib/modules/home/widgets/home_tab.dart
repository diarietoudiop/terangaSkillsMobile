import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controller/auth_controller.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: CustomScrollView(
        slivers: [
          // ─── App Bar Premium ──────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.darkSurface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.darkSurface, AppColors.darkBackground],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() {
                          final name = auth.currentUser.value?.firstName ?? '';
                          return Text(
                            'Bonjour, ${name.isNotEmpty ? name : 'Citoyen'} 👋',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          );
                        }),
                        const SizedBox(height: 6),
                        Text(
                          'Que souhaitez-vous faire aujourd\'hui ?',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.grey400,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Obx(() {
                final name = auth.currentUser.value?.firstName ?? '';
                final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
                return Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          // ─── Quick Actions Premium ─────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Services rapides',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.15,
                    children: [
                      _PremiumActionCard(
                        icon: Icons.description_outlined,
                        label: 'Demande\nadministrative',
                        iconColor: const Color(0xFF60A5FA), // Soft Blue
                        onTap: () => Get.toNamed(AppRoutes.createRequest),
                      ),
                      _PremiumActionCard(
                        icon: Icons.report_outlined,
                        label: 'Signaler une\nréclamation',
                        iconColor: const Color(0xFFF87171), // Soft Red
                        onTap: () => Get.toNamed(AppRoutes.createComplaint),
                      ),
                      _PremiumActionCard(
                        icon: Icons.find_in_page_outlined,
                        label: 'Document\nperdu',
                        iconColor: const Color(0xFF34D399), // Soft Green
                        onTap: () => Get.toNamed(AppRoutes.createMissingDoc),
                      ),
                      _PremiumActionCard(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Scanner\nQR Code',
                        iconColor: const Color(0xFFA78BFA), // Soft Purple
                        onTap: () => Get.toNamed(AppRoutes.qrScan),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // ─── Recent Banner Premium ─────────────────
                  Text(
                    'Mes dernières demandes',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _PremiumRecentBanner(
                    onTap: () => Get.toNamed(AppRoutes.requestsList),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;

  const _PremiumActionCard({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.darkBorder.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: iconColor.withOpacity(0.1),
          highlightColor: iconColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const Spacer(),
                Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumRecentBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _PremiumRecentBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.15),
            AppColors.darkCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.history_rounded,
                      color: AppColors.primaryLight, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Voir mes demandes',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Suivez l\'état de vos dossiers en temps réel',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey400,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: AppColors.grey400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
