import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: controller.fetchStats),
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
                const Icon(Icons.bar_chart_rounded,
                    size: 72, color: AppColors.grey600),
                const SizedBox(height: 16),
                Text('Statistiques indisponibles',
                    style: AppTextStyles.titleMedium),
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
              // ─── KPI Row ──────────────────────────
              Text('KPIs Globaux', style: AppTextStyles.titleMedium),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                    child: _KpiCard(
                  label: 'Citoyens',
                  value: s.users.total.toString(),
                  icon: Icons.people_rounded,
                  color: AppColors.info,
                )),
                const SizedBox(width: 12),
                Expanded(
                    child: _KpiCard(
                  label: 'Demandes',
                  value: s.administrativeRequests.total.toString(),
                  icon: Icons.description_rounded,
                  color: AppColors.primary,
                )),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                    child: _KpiCard(
                  label: 'Réclamations',
                  value: s.complaints.total.toString(),
                  icon: Icons.report_rounded,
                  color: AppColors.warning,
                )),
                const SizedBox(width: 12),
                Expanded(
                    child: _KpiCard(
                  label: 'Docs Perdus',
                  value: s.missingDocuments.total.toString(),
                  icon: Icons.find_in_page_rounded,
                  color: AppColors.error,
                )),
              ]),
              const SizedBox(height: 28),
              // ─── Requests Chart ────────────────────
              Text('Demandes administratives', style: AppTextStyles.titleMedium),
              const SizedBox(height: 16),
              _RequestsChart(stats: s.administrativeRequests),
              const SizedBox(height: 28),
              // ─── Completion Rates ──────────────────
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
                  )),
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
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: const Border.fromBorderSide(
            BorderSide(color: AppColors.darkBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value,
              style:
                  AppTextStyles.headlineMedium.copyWith(color: color)),
          Text(label,
              style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey500)),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border:
            const Border.fromBorderSide(BorderSide(color: AppColors.darkBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: pending,
                    color: AppColors.statusPending,
                    radius: 40,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: inProgress,
                    color: AppColors.statusInReview,
                    radius: 40,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: completed,
                    color: AppColors.statusCompleted,
                    radius: 40,
                    showTitle: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Legend(color: AppColors.statusPending,
                  label: 'En attente', value: stats.pending),
              const SizedBox(height: 8),
              _Legend(color: AppColors.statusInReview,
                  label: 'En cours', value: stats.inProgress),
              const SizedBox(height: 8),
              _Legend(color: AppColors.statusCompleted,
                  label: 'Complétés', value: stats.completed),
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
  const _Legend(
      {required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text('$label ($value)',
            style:
                AppTextStyles.bodySmall.copyWith(color: AppColors.grey400)),
      ],
    );
  }
}

class _RateBar extends StatelessWidget {
  final String label;
  final double rate;
  final Color color;

  const _RateBar(
      {required this.label, required this.rate, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: const Border.fromBorderSide(
            BorderSide(color: AppColors.darkBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.bodySmall),
              Text('${rate.toStringAsFixed(1)}%',
                  style: AppTextStyles.labelMedium.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: rate / 100,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
