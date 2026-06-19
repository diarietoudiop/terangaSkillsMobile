import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/status_utils.dart';
import '../../../routes/agent_routes.dart';
import '../controllers/agent_controller.dart';

class AgentRequestsListView extends GetView<AgentController> {
  const AgentRequestsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.menu_1),
          onPressed: () => controller.openDrawer(),
        ),
        title: Text('Demandes à traiter', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh),
            onPressed: controller.loadRequests,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Row
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _FilterChip(label: 'Toutes', value: ''),
                _FilterChip(label: 'Soumises', value: 'SUBMITTED'),
                _FilterChip(label: 'En cours', value: 'IN_PROGRESS'),
                _FilterChip(label: 'Traitées', value: 'PROCESSED'),
                _FilterChip(label: 'Validées', value: 'VALIDATED'),
                _FilterChip(label: 'Terminées', value: 'COMPLETED'),
              ],
            ),
          ),
          const Divider(height: 1),
          // List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final list = controller.filteredRequests;
              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Iconsax.folder_open,
                        size: 64,
                        color: AppColors.grey500,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucune demande trouvée',
                        style: AppTextStyles.titleMedium,
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadRequests,
                color: AppColors.primary,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final req = list[i];
                    return _AgentRequestCard(
                      type: req.requestType?.name ?? req.type,
                      title: req.title,
                      status: req.status,
                      date: req.createdAt,
                      citizenName: req.citizen != null
                          ? '${req.citizen!.firstName} ${req.citizen!.lastName}'
                          : 'Citoyen Inconnu',
                      onTap: () {
                        controller.selectedRequest.value = req;
                        Get.toNamed(
                          AgentRoutes.agentRequestDetail,
                          arguments: {'id': req.id},
                        );
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends GetView<AgentController> {
  final String label;
  final String value;
  const _FilterChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.statusFilter.value == value;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) => controller.statusFilter.value = value,
          selectedColor: AppColors.primary.withOpacity(0.2),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.grey500,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          backgroundColor: AppColors.darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.darkBorder,
            ),
          ),
        ),
      );
    });
  }
}

class _AgentRequestCard extends StatelessWidget {
  final String type;
  final String title;
  final String status;
  final DateTime date;
  final String citizenName;
  final VoidCallback onTap;

  const _AgentRequestCard({
    required this.type,
    required this.title,
    required this.status,
    required this.date,
    required this.citizenName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = StatusUtils.requestStatusColor(status);
    final statusLabel = StatusUtils.requestStatusLabel(status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
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
                    type,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 16,
                  color: AppColors.grey500,
                ),
                const SizedBox(width: 4),
                Text(
                  citizenName,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: AppColors.grey500,
                ),
                const SizedBox(width: 4),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
