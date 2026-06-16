import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/status_utils.dart';
import '../controller/requests_controller.dart';

class RequestDetailView extends GetView<RequestsController> {
  const RequestDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Load fresh if navigated via route args
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['id'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchRequest(args['id'] as String);
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: Get.back,
        ),
        title: Text('Détail de la demande', style: AppTextStyles.titleMedium),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        final req = controller.selectedRequest.value;
        if (req == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Status Banner ──────────────────────
              _StatusBanner(status: req.status),
              const SizedBox(height: 24),
              // ─── Info Card ──────────────────────────
              _InfoCard(label: 'Type', value: StatusUtils.requestTypeLabel(req.type)),
              _InfoCard(label: 'Titre', value: req.title),
              _InfoCard(label: 'Description', value: req.description),
              _InfoCard(
                  label: 'Date de soumission',
                  value:
                      '${req.createdAt.day}/${req.createdAt.month}/${req.createdAt.year}'),
              if (req.assignedAgent != null)
                _InfoCard(
                    label: 'Agent assigné',
                    value: req.assignedAgent!.fullName),
              const SizedBox(height: 24),
              // ─── Timeline ───────────────────────────
              if (req.history != null && req.history!.isNotEmpty) ...[
                Text('Historique', style: AppTextStyles.titleMedium),
                const SizedBox(height: 16),
                ...req.history!.map((log) => _TimelineItem(log: log)),
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
    final color = StatusUtils.requestStatusColor(status);
    final label = StatusUtils.requestStatusLabel(status);
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
              width: 110,
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
