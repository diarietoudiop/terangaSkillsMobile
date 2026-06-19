import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/dashboard_controller.dart';
import '../../agent/controllers/agent_controller.dart';
import '../../home/controller/home_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.menu_1),
          onPressed: () {
            if (Get.isRegistered<AgentController>()) {
              Get.find<AgentController>().openDrawer();
            } else if (Get.isRegistered<HomeController>()) {
              Get.find<HomeController>().openDrawer();
            }
          },
        ),
        title: Text('Tableau de bord', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh),
            onPressed: controller.fetchStats,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) return _buildShimmer();
        final s = controller.stats.value;
        if (s == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Iconsax.chart_1, size: 72, color: AppColors.grey600),
                const SizedBox(height: 16),
                Text(
                  'Statistiques indisponibles',
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.fetchStats,
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── KPI Row ───
              // Text('KPIs Globaux', style: AppTextStyles.titleMedium),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _KpiCard(
                      label: 'Citoyens',
                      value: s.users.total.toString(),
                      icon: Iconsax.people,
                      color: AppColors.info,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KpiCard(
                      label: 'Demandes',
                      value: s.administrativeRequests.total.toString(),
                      icon: Iconsax.document_text,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _KpiCard(
                      label: 'Réclamations',
                      value: s.complaints.total.toString(),
                      icon: Iconsax.danger,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KpiCard(
                      label: 'Docs Perdus',
                      value: s.missingDocuments.total.toString(),
                      icon: Iconsax.search_normal_1,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ─── Requests Chart ───
              Text(
                'Demandes administratives',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 16),
              _RequestsChart(stats: s.administrativeRequests),
              const SizedBox(height: 28),

              // ─── Completion Rates ───
              Text('Taux de résolution', style: AppTextStyles.titleMedium),
              const SizedBox(height: 16),
              _RateBar(
                label: 'Demandes complétées',
                rate: s.administrativeRequests.completionRate,
                color: AppColors.success,
              ),
              const SizedBox(height: 12),
              _RateBar(
                label: 'Réclamations résolues',
                rate: s.complaints.resolutionRate,
                color: AppColors.warning,
              ),
              const SizedBox(height: 12),
              _RateBar(
                label: 'Documents retrouvés',
                rate: s.missingDocuments.foundRate,
                color: AppColors.info,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkCard,
      highlightColor: AppColors.darkBorder,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: List.generate(
            6,
            (_) => Container(
              height: 80,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.grey500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestsChart extends StatelessWidget {
  final dynamic stats;
  const _RequestsChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final pending = stats.pending.toDouble();
    final completed = stats.completed.toDouble();
    final inProgress = (stats.inProgress).toDouble();

    return Container(
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.darkBorder.withOpacity(0.4),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                sections: (pending == 0 && inProgress == 0 && completed == 0)
                    ? [
                        PieChartSectionData(
                          value: 1,
                          color: AppColors.darkBorder,
                          radius: 35,
                          showTitle: false,
                        ),
                      ]
                    : [
                        PieChartSectionData(
                          value: pending,
                          color: AppColors.statusPending,
                          radius: 35,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: inProgress,
                          color: AppColors.statusInReview,
                          radius: 35,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: completed,
                          color: AppColors.statusCompleted,
                          radius: 35,
                          showTitle: false,
                        ),
                      ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Legend(
                color: AppColors.statusPending,
                label: 'En attente',
                value: stats.pending,
              ),
              const SizedBox(height: 10),
              _Legend(
                color: AppColors.statusInReview,
                label: 'En cours',
                value: stats.inProgress,
              ),
              const SizedBox(height: 10),
              _Legend(
                color: AppColors.statusCompleted,
                label: 'Complétés',
                value: stats.completed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  final int value;
  const _Legend({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          '$label ($value)',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.grey400,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _RateBar extends StatelessWidget {
  final String label;
  final double rate;
  final Color color;

  const _RateBar({
    required this.label,
    required this.rate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.darkBorder.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${rate.toStringAsFixed(1)}%',
                style: AppTextStyles.labelMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: rate / 100,
              backgroundColor: color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
