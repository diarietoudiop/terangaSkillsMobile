import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/ts_logo.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              // ─── Logo ──────────────────────────────
              const Center(child: TsLogo()),
              const SizedBox(height: 48),
              // ─── Header ────────────────────────────
              Text('Bon retour 👋', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Connectez-vous à votre espace citoyen',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.grey500),
              ),
              const SizedBox(height: 40),
              // ─── Form ──────────────────────────────
              AuthTextField(
                controller: controller.loginEmailController.value,
                label: 'Email',
                hint: 'votre@email.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              Obx(() => AuthTextField(
                    controller: controller.loginPasswordController.value,
                    label: 'Mot de passe',
                    hint: '••••••••',
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
              const SizedBox(height: 32),
              // ─── Login Button ──────────────────────
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.login,
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text('Se connecter',
                              style: AppTextStyles.buttonText),
                    ),
                  )),
              const SizedBox(height: 20),
              // ─── Divider ───────────────────────────
              Row(children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('ou',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.grey500)),
                ),
                const Expanded(child: Divider()),
              ]),
              const SizedBox(height: 20),
              // ─── Register Link ─────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Get.toNamed(AppRoutes.register),
                  child: Text('Créer un compte',
                      style: AppTextStyles.buttonText
                          .copyWith(color: AppColors.primary)),
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
