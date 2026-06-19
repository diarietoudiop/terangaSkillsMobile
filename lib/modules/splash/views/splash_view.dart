import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final slides = [
      _OnboardingSlide(
        icon: Icons.account_balance_rounded,
        title: 'Bienvenue sur\nTerangaSkills',
        description: 'La plateforme de gouvernance territoriale qui rapproche les citoyens de leur administration.',
      ),
      _OnboardingSlide(
        icon: Icons.description_rounded,
        title: 'Démarches &\nSignalements',
        description: 'Soumettez vos demandes de documents administratifs et signalez les incidents de votre quartier en quelques clics.',
      ),
      _OnboardingSlide(
        icon: Icons.chat_bubble_rounded,
        title: 'Assistant IA\nWolof (TerangaAI)',
        description: 'Échangez avec TerangaAI en wolof ou en français pour vous guider et remplir vos démarches automatiquement.',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header: Optional Small Logo / Icon ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.08),
                    ),
                    child: Icon(
                      Icons.widgets_rounded,
                      size: 20,
                      color: AppColors.primary.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Onboarding PageView ───
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Circle Icon Container
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFF7ED),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.06),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              slide.icon,
                              size: 72,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        
                        // Title
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h1.copyWith(
                            color: const Color(0xFF111827),
                            fontWeight: FontWeight.w800,
                            fontSize: 26,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Description
                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xFF6B7280),
                            fontSize: 14.5,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ─── Bottom Navigation Area ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Passer (Skip) Button
                  Obx(() {
                    final isLastPage = controller.currentPage.value == slides.length - 1;
                    return AnimatedOpacity(
                      opacity: isLastPage ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: TextButton(
                        onPressed: isLastPage ? null : controller.skip,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF9CA3AF),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        child: Text(
                          'Passer',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),

                  // Dots Indicator
                  Row(
                    children: List.generate(
                      slides.length,
                      (index) => Obx(() {
                        final isSelected = controller.currentPage.value == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isSelected ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0xFFE5E7EB),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Suivant / Commencer Button
                  Obx(() {
                    final isLastPage = controller.currentPage.value == slides.length - 1;
                    return ElevatedButton(
                      onPressed: controller.nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isLastPage ? 'Commencer' : 'Suivant',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  final IconData icon;
  final String title;
  final String description;

  _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
  });
}
