import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/status_utils.dart';
import '../controller/missing_docs_controller.dart';

class MissingDocDetailView extends GetView<MissingDocsController> {
  const MissingDocDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Load fresh if navigated via route args
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['id'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchDoc(args['id'] as String);
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: Get.back,
        ),
        title: Text('Détail du document perdu', style: AppTextStyles.titleMedium),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        final doc = controller.selectedDoc.value;
        if (doc == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Photo ──────────────────────────────
              if (doc.photoUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: doc.photoUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: double.infinity,
                      height: 200,
                      color: AppColors.darkBorder,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                      ),
                      child: const Icon(Icons.broken_image_rounded,
                          color: AppColors.error, size: 48),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ─── Status Banner ──────────────────────
              _StatusBanner(status: doc.status),
              const SizedBox(height: 24),

              // ─── Info Card ──────────────────────────
              _InfoCard(label: 'Titre', value: doc.title),
              _InfoCard(label: 'Description', value: doc.description),
              
              if (doc.lastSeenLocation != null)
                _InfoCard(label: 'Dernier lieu vu', value: doc.lastSeenLocation!),
                
              _InfoCard(
                  label: 'Signalé le',
                  value:
                      '${doc.createdAt.day}/${doc.createdAt.month}/${doc.createdAt.year}'),
              
              if (doc.hasLocation)
                _InfoCard(
                    label: 'Position GPS',
                    value: '${doc.latitude!.toStringAsFixed(4)}, ${doc.longitude!.toStringAsFixed(4)}'),

              const SizedBox(height: 24),
              
              // ─── Timeline ───────────────────────────
              if (doc.history != null && doc.history!.isNotEmpty) ...[
                Text('Historique', style: AppTextStyles.titleMedium),
                const SizedBox(height: 16),
                ...doc.history!.map((log) => _TimelineItem(log: log)),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String status;
  const _StatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = StatusUtils.missingDocStatusColor(status);
    final label = StatusUtils.missingDocStatusLabel(status);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: color, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Statut actuel',
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.grey500)),
              Text(label,
                  style: AppTextStyles.titleSmall.copyWith(color: color)),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: const Border.fromBorderSide(
              BorderSide(color: AppColors.darkBorder)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(label,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.grey500)),
            ),
            Expanded(
              child: Text(value, style: AppTextStyles.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final dynamic log;
  const _TimelineItem({required this.log});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryDark, width: 2),
              ),
            ),
            Container(width: 2, height: 40, color: AppColors.darkBorder),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log.action ?? '',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.primary)),
                if (log.description != null)
                  Text(log.description,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.grey400)),
                Text(
                  '${log.createdAt.day}/${log.createdAt.month}/${log.createdAt.year}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
