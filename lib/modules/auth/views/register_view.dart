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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Center(child: TsLogo(size: 48)),
              const SizedBox(height: 24),
              Text('Rejoignez TerangaSkills 🇸🇳',
                  style: AppTextStyles.headlineSmall),
              const SizedBox(height: 6),
              Text(
                'Créez votre espace citoyen numérique',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.grey500),
              ),
              const SizedBox(height: 32),
              // ─── Name Row ────────────────────────
              Row(children: [
                Expanded(
                  child: AuthTextField(
                    controller: controller.firstNameController.value,
                    label: 'Prénom',
                    hint: 'Jean',
                    prefixIcon: Icons.person_outline,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AuthTextField(
                    controller: controller.lastNameController.value,
                    label: 'Nom',
                    hint: 'Diop',
                    prefixIcon: Icons.person_outline,
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              AuthTextField(
                controller: controller.registerEmailController.value,
                label: 'Email',
                hint: 'votre@email.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: controller.phoneController.value,
                label: 'Téléphone (optionnel)',
                hint: '+221 70 000 00 00',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
              ),
              const SizedBox(height: 16),
              Obx(() => AuthTextField(
                    controller: controller.registerPasswordController.value,
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
                  )),
              const SizedBox(height: 16),
              Obx(() => AuthTextField(
                    controller: controller.confirmPasswordController.value,
                    label: 'Confirmer le mot de passe',
                    hint: '••••••••',
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: GestureDetector(
                      onTap: controller.toggleConfirmPasswordVisibility,
                      child: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.grey500,
                        size: 20,
                      ),
                    ),
                  )),
              const SizedBox(height: 32),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.register,
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5, color: Colors.white),
                            )
                          : Text('Créer mon compte',
                              style: AppTextStyles.buttonText),
                    ),
                  )),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: RichText(
                    text: TextSpan(
                      text: 'Déjà inscrit ? ',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.grey500),
                      children: [
                        TextSpan(
                          text: 'Se connecter',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
