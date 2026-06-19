import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/widgets/profile_drawer.dart';
import 'agent_requests_list_view.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../controllers/agent_controller.dart';

class AgentHomeView extends StatefulWidget {
  const AgentHomeView({super.key});

  @override
  State<AgentHomeView> createState() => _AgentHomeViewState();
}

class _AgentHomeViewState extends State<AgentHomeView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AgentRequestsListView(),
    const DashboardView(),
  ];

  @override
  Widget build(BuildContext context) {
    Theme.of(context); // For dynamic theme

    final agentCtrl = Get.find<AgentController>();
    return Scaffold(
      key: agentCtrl.scaffoldKey,
      drawer: const ProfileDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface.withOpacity(0.95),
        border: Border(top: BorderSide(color: AppColors.darkBorder, width: 0.8)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey500,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.task_square),
            activeIcon: Icon(Iconsax.task_square5),
            label: 'Traitement',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.chart),
            activeIcon: Icon(Iconsax.chart_15),
            label: 'Tableau de bord',
          ),
        ],
      ),
    );
  }
}
