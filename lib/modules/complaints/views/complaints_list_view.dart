import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/status_utils.dart';
import '../../../routes/app_routes.dart';
import '../controller/complaints_controller.dart';

class ComplaintsListView extends GetView<ComplaintsController> {
  const ComplaintsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Réclamations', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: controller.fetchMyComplaints),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.report_off_rounded,
                    size: 72, color: AppColors.grey600),
                const SizedBox(height: 16),
                Text('Aucune réclamation', style: AppTextStyles.titleMedium),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.createComplaint),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Nouvelle réclamation'),
                ),
              ],
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
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    controller.selectedComplaint.value = c;
                    Get.toNamed(AppRoutes.complaintDetail,
                        arguments: {'id': c.id});
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(16),
                      border: const Border.fromBorderSide(
                          BorderSide(color: AppColors.darkBorder)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.report_rounded,
                              color: AppColors.warning, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.title,
                                  style: AppTextStyles.titleSmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(c.description,
                                  style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.grey500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 6),
                              Row(children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(statusLabel,
                                      style: AppTextStyles.labelSmall.copyWith(
                                          color: statusColor, fontSize: 10)),
                                ),
                                const Spacer(),
                                if (c.hasLocation)
                                  const Icon(Icons.location_on_rounded,
                                      size: 14, color: AppColors.grey500),
                              ]),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right_rounded,
                            color: AppColors.grey500, size: 20),
                      ],
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
