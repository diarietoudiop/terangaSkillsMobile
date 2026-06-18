import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/complaints_controller.dart';
import '../../auth/widgets/auth_text_field.dart';

class CreateComplaintView extends GetView<ComplaintsController> {
  const CreateComplaintView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: Get.back),
        title: Text('Nouvelle réclamation', style: AppTextStyles.titleMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthTextField(
              controller: controller.titleController.value,
              label: 'Titre',
              hint: 'Ex: Panne d\'éclairage public',
              prefixIcon: Icons.title_rounded,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: controller.descriptionController.value,
              label: 'Description',
              hint: 'Décrivez le problème en détail...',
              prefixIcon: Icons.notes_rounded,
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            // ─── Location ──────────────────────────
            Text('Localisation', style: AppTextStyles.labelMedium
                .copyWith(color: AppColors.grey400)),
            const SizedBox(height: 8),
            Obx(() => GestureDetector(
                  onTap: controller.captureLocation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: controller.currentPosition.value != null
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.darkCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.currentPosition.value != null
                            ? AppColors.success.withOpacity(0.4)
                            : AppColors.darkBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          controller.currentPosition.value != null
                              ? Icons.my_location_rounded
                              : Icons.location_off_rounded,
                          color: controller.currentPosition.value != null
                              ? AppColors.success
                              : AppColors.grey500,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          controller.currentPosition.value != null
                              ? 'Position : ${controller.currentPosition.value!.latitude.toStringAsFixed(4)}, ${controller.currentPosition.value!.longitude.toStringAsFixed(4)}'
                              : 'Appuyez pour capturer la position GPS',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: controller.currentPosition.value != null
                                ? AppColors.success
                                : AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            // ─── Photo ─────────────────────────────
            Text('Photo (optionnel)', style: AppTextStyles.labelMedium
                .copyWith(color: AppColors.grey400)),
            const SizedBox(height: 8),
            Obx(() => GestureDetector(
                  onTap: controller.pickPhoto,
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.fromBorderSide(
                          BorderSide(color: AppColors.darkBorder)),
                    ),
                    child: controller.pickedPhoto.value == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.camera_alt_rounded,
                                  color: AppColors.grey500, size: 36),
                              const SizedBox(height: 8),
                              Text('Prendre une photo',
                                  style: AppTextStyles.bodySmall
                                      .copyWith(color: AppColors.grey500)),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              controller.pickedPhoto.value!.path,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.image_rounded,
                                color: AppColors.primary,
                                size: 48,
                              ),
                            ),
                          ),
                  ),
                )),
            const SizedBox(height: 32),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : controller.submitComplaint,
                    icon: controller.isSubmitting.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send_rounded),
                    label: Text(
                        controller.isSubmitting.value
                            ? 'Envoi...'
                            : 'Soumettre la réclamation',
                        style: AppTextStyles.buttonText),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
