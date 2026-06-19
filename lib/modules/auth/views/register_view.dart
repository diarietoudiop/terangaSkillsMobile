import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/ts_logo.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
        title: Text('Créer un compte', style: AppTextStyles.titleMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ─── Decorative Blurred Background Blobs ───
          Positioned(
            top: -50,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.info.withOpacity(0.08),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(color: Colors.transparent),
            ),
          ),

          // ─── Main Content ───
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: TsLogo(size: 48)),
                    const SizedBox(height: 28),

                    // ─── Form Card (Glassmorphic) ───
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.darkBorder.withOpacity(0.4),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 25,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rejoignez CIVILINK 🇸🇳',
                            style: AppTextStyles.headlineSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Créez votre espace citoyen numérique',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.grey400,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ─── Name Row ───
                          Row(
                            children: [
                              Expanded(
                                child: AuthTextField(
                                  controller:
                                      controller.firstNameController.value,
                                  label: 'Prénom',
                                  hint: 'Jean',
                                  prefixIcon: Icons.person_outline,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: AuthTextField(
                                  controller:
                                      controller.lastNameController.value,
                                  label: 'Nom',
                                  hint: 'Diop',
                                  prefixIcon: Icons.person_outline,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // ─── Email ───
                          AuthTextField(
                            controller:
                                controller.registerEmailController.value,
                            label: 'Email',
                            hint: 'votre@email.com',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 14),

                          // ─── Phone ───
                          AuthTextField(
                            controller: controller.phoneController.value,
                            label: 'Téléphone (optionnel)',
                            hint: '+221 70 000 00 00',
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icons.phone_outlined,
                          ),
                          const SizedBox(height: 14),

                          // ─── Password ───
                          Obx(
                            () => AuthTextField(
                              controller:
                                  controller.registerPasswordController.value,
                              label: 'Mot de passe',
                              hint: 'min. 6 caractères',
                              obscureText: !controller.isPasswordVisible.value,
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: GestureDetector(
                                onTap: controller.togglePasswordVisibility,
                                child: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.grey500,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // ─── Confirm Password ───
                          Obx(
                            () => AuthTextField(
                              controller:
                                  controller.confirmPasswordController.value,
                              label: 'Confirmer le mot de passe',
                              hint: '••••••••',
                              obscureText:
                                  !controller.isConfirmPasswordVisible.value,
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: GestureDetector(
                                onTap:
                                    controller.toggleConfirmPasswordVisibility,
                                child: Icon(
                                  controller.isConfirmPasswordVisible.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.grey500,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // ─── Register Button ───
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : controller.register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Créer mon compte',
                                        style: AppTextStyles.buttonText
                                            .copyWith(color: Colors.white),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ─── Register Link ───
                    Center(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: RichText(
                          text: TextSpan(
                            text: 'Déjà inscrit ? ',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey500,
                            ),
                            children: [
                              TextSpan(
                                text: 'Se connecter',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
