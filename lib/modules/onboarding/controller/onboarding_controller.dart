import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_routes.dart';

class OnboardingPageModel {
  final String title;
  final String description;
  final IconData icon;

  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingController extends GetxController {
  final _storage = GetStorage();
  final pageController = PageController();
  final currentIndex = 0.obs;

  final pages = [
    OnboardingPageModel(
      title: 'Bienvenue sur CIVILINK',
      description: 'La plateforme de gouvernance territoriale qui rapproche les citoyens de leur administration.',
      icon: Icons.account_balance_rounded,
    ),
    OnboardingPageModel(
      title: 'Demandes Administratives',
      description: 'Effectuez vos demandes de documents officiels en quelques clics, sans vous déplacer.',
      icon: Icons.description_rounded,
    ),
    OnboardingPageModel(
      title: 'Réclamations & Signalements',
      description: 'Signalez un problème dans votre commune ou faites une réclamation facilement.',
      icon: Icons.report_problem_rounded,
    ),
    OnboardingPageModel(
      title: 'Objets Perdus & Trouvés',
      description: 'Déclarez la perte d\'un document ou signalez un objet trouvé pour aider la communauté.',
      icon: Icons.find_in_page_rounded,
    ),
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void next() {
    if (currentIndex.value == pages.length - 1) {
      _finishOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    _storage.write('isFirstLaunch', false);
    Get.offAllNamed(AppRoutes.login);
  }
}
