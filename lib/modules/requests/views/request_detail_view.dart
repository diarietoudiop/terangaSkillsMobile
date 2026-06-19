import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/status_utils.dart';
import '../../auth/controller/auth_controller.dart';
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
            child: CircularProgressIndicator(color: AppColors.primary),
          );
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
              _InfoCard(
                label: 'Type',
                value: StatusUtils.requestTypeLabel(req.type),
              ),
              _InfoCard(label: 'Titre', value: req.title),
              _InfoCard(label: 'Description', value: req.description),
              _InfoCard(
                label: 'Date de soumission',
                value:
                    '${req.createdAt.day}/${req.createdAt.month}/${req.createdAt.year}',
              ),
              if (req.assignedAgent != null)
                _InfoCard(
                  label: 'Agent assigné',
                  value: req.assignedAgent!.fullName,
                ),
              const SizedBox(height: 24),
              // ─── Timeline ───────────────────────────
              if (req.history != null && req.history!.isNotEmpty) ...[
                Text('Historique', style: AppTextStyles.titleMedium),
                const SizedBox(height: 16),
                ...req.history!.map((log) => _TimelineItem(log: log)),
              ],
              const SizedBox(height: 24),
              // ─── Actions ────────────────────────────
              _buildActions(context, req),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActions(BuildContext context, req) {
    final auth = Get.find<AuthController>();
    final isAgent = auth.currentUser.value?.isAgent ?? false;

    if (isAgent) {
      if (req.status != 'COMPLETED') {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showGenerateDocumentDialog(context, req.id),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text(
              'Terminer & Envoyer Document',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      }
    } else {
      // Citizen
      if (req.status == 'COMPLETED') {
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Mock download action
              Get.snackbar(
                'Téléchargement',
                'Le document est en cours de téléchargement...',
                backgroundColor: AppColors.primary.withOpacity(0.9),
                colorText: Colors.white,
              );
            },
            icon: const Icon(Icons.file_download, color: AppColors.primary),
            label: const Text(
              'Télécharger le document',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }

  void _showGenerateDocumentDialog(BuildContext context, String requestId) {
    String docContent = "";
    Get.defaultDialog(
      backgroundColor: AppColors.darkSurface,
      title: 'Générer le Document',
      titleStyle: AppTextStyles.titleMedium.copyWith(color: AppColors.text),
      content: Column(
        children: [
          Text(
            'Ce document sera envoyé au citoyen pour téléchargement.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey400),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.text),
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Contenu ou URL du document généré...',
              hintStyle: TextStyle(color: AppColors.grey500),
              filled: true,
              fillColor: AppColors.darkCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.darkBorder),
              ),
            ),
            onChanged: (val) => docContent = val,
          ),
        ],
      ),
      textConfirm: 'Générer et Terminer',
      textCancel: 'Annuler',
      confirmTextColor: Colors.white,
      cancelTextColor: AppColors.primary,
      buttonColor: AppColors.primary,
      onConfirm: () {
        Get.back();
        // Call the API to generate the document
        controller.generateDocumentAndComplete(requestId, docContent);
      },
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25), width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.info_circle, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Statut actuel',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.grey500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTextStyles.titleSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard.withOpacity(0.55),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.darkBorder.withOpacity(0.4),
            width: 0.8,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(height: 1.4),
              ),
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
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
            ),
            Container(
              width: 1.5,
              height: 50,
              color: AppColors.darkBorder.withOpacity(0.5),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.action ?? '',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (log.description != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    log.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey400,
                      height: 1.3,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  '${log.createdAt.day}/${log.createdAt.month}/${log.createdAt.year}',
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
