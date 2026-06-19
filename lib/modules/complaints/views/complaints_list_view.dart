import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/status_utils.dart';
import '../../../routes/app_routes.dart';
import '../controller/complaints_controller.dart';
import '../../home/controller/home_controller.dart';

class ComplaintsListView extends GetView<ComplaintsController> {
  const ComplaintsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.menu_1),
          onPressed: () {
            if (Get.isRegistered<HomeController>()) {
              Get.find<HomeController>().openDrawer();
            }
          },
        ),
        title: Text('Mes Réclamations', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh),
            onPressed: controller.fetchMyComplaints,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Shimmer.fromColors(
            baseColor: AppColors.darkCard,
            highlightColor: AppColors.darkBorder,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (_, __) => Container(
                height: 90,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        }
        if (controller.complaints.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.danger5,
                      size: 64,
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Aucune réclamation', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Signalez un problème ou une anomalie dans votre commune.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.createComplaint),
                    icon: const Icon(Icons.add_rounded),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: const Text('Nouvelle réclamation'),
                  ),
                ],
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchMyComplaints,
          color: AppColors.primary,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.complaints.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final c = controller.complaints[i];
              final statusColor = StatusUtils.complaintStatusColor(c.status);
              final statusLabel = StatusUtils.complaintStatusLabel(c.status);
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.darkCard.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: statusColor.withOpacity(0.22),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      controller.selectedComplaint.value = c;
                      Get.toNamed(
                        AppRoutes.complaintDetail,
                        arguments: {'id': c.id},
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Iconsax.danger,
                              color: statusColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.title,
                                  style: AppTextStyles.titleSmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  c.description,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.grey500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        statusLabel,
                                        style: AppTextStyles.labelSmall
                                            .copyWith(
                                              color: statusColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    const Spacer(),
                                    if (c.hasLocation)
                                      const Icon(
                                        Iconsax.location5,
                                        size: 14,
                                        color: AppColors.primaryLight,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Iconsax.arrow_right_3,
                            color: AppColors.grey500,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
