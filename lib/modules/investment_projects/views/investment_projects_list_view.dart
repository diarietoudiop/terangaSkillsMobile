import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/investment_projects_controller.dart';
import 'package:intl/intl.dart';

class InvestmentProjectsListView extends GetView<InvestmentProjectsController> {
  const InvestmentProjectsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        title: Text(
          'Projets d\'Investissement',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.text),
        ),
        iconTheme: IconThemeData(color: AppColors.text),
        actions: [
          IconButton(
            icon: Icon(Iconsax.refresh, color: AppColors.text),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.projects.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.error.value.isNotEmpty && controller.projects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Iconsax.warning_2, color: AppColors.error, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Une erreur est survenue',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.text,
                  ),
                ),
                Text(
                  controller.error.value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refreshData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        if (controller.projects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.building,
                  size: 64,
                  color: AppColors.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun projet trouvé',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          );
        }

        final formatter = NumberFormat.currency(
          locale: 'fr_FR',
          symbol: 'FCFA',
        );

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          color: AppColors.primary,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.projects.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final p = controller.projects[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            p.name,
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColors.text,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(p.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getStatusText(p.status),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: _getStatusColor(p.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (p.description != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        p.description!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Budget: ${formatter.format(p.budget)}',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${p.progress}%',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (p.progress / 100).clamp(0.0, 1.0).toDouble(),
                        backgroundColor: AppColors.darkBorder,
                        color: AppColors.primary,
                        minHeight: 6,
                      ),
                    ),
                    if (p.company != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Iconsax.buildings,
                            size: 14,
                            color: AppColors.grey400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            p.company!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.grey400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PLANNED':
        return AppColors.info;
      case 'IN_PROGRESS':
        return AppColors.warning;
      case 'COMPLETED':
        return AppColors.success;
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.grey500;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'PLANNED':
        return 'Planifié';
      case 'IN_PROGRESS':
        return 'En cours';
      case 'COMPLETED':
        return 'Terminé';
      case 'CANCELLED':
        return 'Annulé';
      default:
        return status;
    }
  }
}
