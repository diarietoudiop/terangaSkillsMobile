import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/status_utils.dart';
import '../../../routes/app_routes.dart';
import '../controller/requests_controller.dart';

class RequestsListView extends GetView<RequestsController> {
  const RequestsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Demandes', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh),
            onPressed: controller.fetchMyRequests,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) return _buildShimmer();
        if (controller.requests.isEmpty) return _buildEmpty();
        return RefreshIndicator(
          onRefresh: controller.fetchMyRequests,
          color: AppColors.primary,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.requests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final req = controller.requests[i];
              return _RequestCard(
                type: StatusUtils.requestTypeLabel(req.type),
                title: req.title,
                status: req.status,
                date: req.createdAt,
                onTap: () {
                  controller.selectedRequest.value = req;
                  Get.toNamed(AppRoutes.requestDetail,
                      arguments: {'id': req.id});
                },
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkCard,
      highlightColor: AppColors.darkBorder,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
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

  Widget _buildEmpty() {
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
                Iconsax.folder_open5,
                size: 64,
                color: AppColors.grey500,
              ),
            ),
            const SizedBox(height: 24),
            Text('Aucune demande', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Soumettez votre première demande administrative en quelques clics !',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.createRequest),
              icon: const Icon(Icons.add_rounded),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              label: const Text('Nouvelle demande'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final String type;
  final String title;
  final String status;
  final DateTime date;
  final VoidCallback onTap;

  const _RequestCard({
    required this.type,
    required this.title,
    required this.status,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = StatusUtils.requestStatusColor(status);
    final statusLabel = StatusUtils.requestStatusLabel(status);

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
          onTap: onTap,
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
                    Iconsax.document_text,
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
                        type,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.grey500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        title,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              statusLabel,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${date.day}/${date.month}/${date.year}',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 11,
                            ),
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
  }
}
