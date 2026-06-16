import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/status_utils.dart';
import '../../../routes/app_routes.dart';
import '../controller/missing_docs_controller.dart';

class MissingDocsListView extends GetView<MissingDocsController> {
  const MissingDocsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents Perdus', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: controller.fetchAll),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Shimmer.fromColors(
            baseColor: AppColors.darkCard,
            highlightColor: AppColors.darkBorder,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6,
              itemBuilder: (_, __) => Container(
                height: 120,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        }
        if (controller.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.find_in_page_rounded,
                    size: 72, color: AppColors.grey600),
                const SizedBox(height: 16),
                Text('Aucun document signalé', style: AppTextStyles.titleMedium),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.createMissingDoc),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Signaler un document'),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchAll,
          color: AppColors.primary,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final doc = controller.docs[i];
              final statusColor = StatusUtils.missingDocStatusColor(doc.status);
              final statusLabel = StatusUtils.missingDocStatusLabel(doc.status);
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    controller.selectedDoc.value = doc;
                    Get.toNamed(AppRoutes.missingDocDetail,
                        arguments: {'id': doc.id});
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(16),
                      border: const Border.fromBorderSide(
                          BorderSide(color: AppColors.darkBorder)),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: doc.photoUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: doc.photoUrl!,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    width: 64,
                                    height: 64,
                                    color: AppColors.darkBorder,
                                  ),
                                  errorWidget: (_, __, ___) => _DocIcon(),
                                )
                              : _DocIcon(),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doc.title,
                                  style: AppTextStyles.titleSmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              if (doc.lastSeenLocation != null)
                                Row(children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 12, color: AppColors.grey500),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(doc.lastSeenLocation!,
                                        style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.grey500),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ]),
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
                                if (doc.isVerified)
                                  const Icon(Icons.verified_rounded,
                                      size: 14, color: AppColors.info),
                              ]),
                            ],
                          ),
                        ),
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

class _DocIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.find_in_page_rounded,
          color: AppColors.error, size: 28),
    );
  }
}
