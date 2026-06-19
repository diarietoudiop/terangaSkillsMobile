import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/status_utils.dart';
import '../controllers/agent_controller.dart';

class AgentRequestDetailView extends GetView<AgentController> {
  const AgentRequestDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments['id'] as String;
    // Reload to get fresh data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadRequestDetail(id);
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: Get.back,
        ),
        title: Text('Traitement demande', style: AppTextStyles.titleMedium),
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.selectedRequest.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final req = controller.selectedRequest.value;
        if (req == null)
          return const Center(child: Text('Demande introuvable'));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── STATUS ───
              _buildStatusBanner(req.status),
              const SizedBox(height: 24),

              // ─── INFO ───
              Text('Informations générales', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              _buildInfoCard(req),
              const SizedBox(height: 24),

              // ─── CITIZEN ───
              if (req.citizen != null) ...[
                Text('Demandeur', style: AppTextStyles.titleMedium),
                const SizedBox(height: 12),
                _buildCitizenCard(req.citizen!),
                const SizedBox(height: 24),
              ],

              // ─── ACTIONS ───
              Text('Actions Agent', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              _buildActionCard(req, context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusBanner(String status) {
    final color = StatusUtils.requestStatusColor(status);
    final label = StatusUtils.requestStatusLabel(status);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Iconsax.info_circle, color: color),
          const SizedBox(width: 12),
          Text(
            'Statut actuel : $label',
            style: AppTextStyles.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(req) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(label: 'Type', value: req.requestType?.name ?? req.type),
          const Divider(height: 24),
          _InfoRow(label: 'Titre', value: req.title),
          const Divider(height: 24),
          Text(
            'Description',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: 4),
          Text(req.description, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildCitizenCard(citizen) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: Text(
              citizen.firstName[0].toUpperCase(),
              style: const TextStyle(
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
                  '${citizen.firstName} ${citizen.lastName}',
                  style: AppTextStyles.titleSmall,
                ),
                Text(
                  citizen.email,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
                if (citizen.phone != null)
                  Text(
                    citizen.phone!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey400,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(req, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Changer le statut
          Text('Changer le statut', style: AppTextStyles.labelMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kAgentStatuses.map((s) {
              final val = s['value'] as String;
              final label = s['label'] as String;
              final isCurrent = req.status == val;
              return ActionChip(
                label: Text(label),
                backgroundColor: isCurrent
                    ? AppColors.primary
                    : AppColors.darkSurface,
                labelStyle: TextStyle(
                  color: isCurrent ? Colors.white : AppColors.grey300,
                ),
                onPressed: isCurrent
                    ? null
                    : () => controller.updateStatus(req.id, val),
              );
            }).toList(),
          ),
          const Divider(height: 32),

          // 2. Joindre un document final
          Text('Document final', style: AppTextStyles.labelMedium),
          const SizedBox(height: 8),
          if (req.document != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Document généré : ${req.document!['name'] ?? 'Document'}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.pickedDocFile.value != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.darkBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.file_present,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.pickedDocFile.value!.name,
                              style: AppTextStyles.bodySmall,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                controller.pickedDocFile.value = null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.pickDocument,
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Sélectionner'),
                        ),
                      ),
                      if (controller.pickedDocFile.value != null) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.isUploading.value
                                ? null
                                : () => controller.uploadDocumentForRequest(
                                    req.id,
                                  ),
                            child: controller.isUploading.value
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Envoyer'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
