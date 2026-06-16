import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/missing_docs_controller.dart';
import '../../auth/widgets/auth_text_field.dart';

class CreateMissingDocView extends GetView<MissingDocsController> {
  const CreateMissingDocView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: Get.back),
        title:
            Text('Signaler un document perdu', style: AppTextStyles.titleMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthTextField(
              controller: controller.titleController.value,
              label: 'Type / Titre du document *',
              hint: 'Ex: Carte d\'identité nationale',
              prefixIcon: Icons.badge_outlined,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: controller.descriptionController.value,
              label: 'Description *',
              hint: 'Décrivez le document, son titulaire...',
              prefixIcon: Icons.notes_rounded,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: controller.lastSeenController.value,
              label: 'Dernier lieu vu (optionnel)',
              hint: 'Ex: Liberté 6, Dakar',
              prefixIcon: Icons.place_outlined,
            ),
            const SizedBox(height: 20),
            // ─── GPS ─────────────────────────────
            Text('Localisation', style: AppTextStyles.labelMedium
                .copyWith(color: AppColors.grey400)),
            const SizedBox(height: 8),
            Obx(() => GestureDetector(
                  onTap: controller.captureLocation,
                  child: Container(
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
                    child: Row(children: [
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
                            ? '${controller.currentPosition.value!.latitude.toStringAsFixed(4)}, ${controller.currentPosition.value!.longitude.toStringAsFixed(4)}'
                            : 'Capturer la position GPS',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: controller.currentPosition.value != null
                              ? AppColors.success
                              : AppColors.grey500,
                        ),
                      ),
                    ]),
                  ),
                )),
            const SizedBox(height: 20),
            // ─── Photo ──────────────────────────
            Text('Photo du document', style: AppTextStyles.labelMedium
                .copyWith(color: AppColors.grey400)),
            const SizedBox(height: 8),
            Obx(() => GestureDetector(
                  onTap: controller.pickPhoto,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(12),
                      border: const Border.fromBorderSide(
                          BorderSide(color: AppColors.darkBorder)),
                    ),
                    child: controller.pickedPhoto.value == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_photo_alternate_rounded,
                                  color: AppColors.grey500, size: 36),
                              const SizedBox(height: 8),
                              Text('Ajouter une photo',
                                  style: AppTextStyles.bodySmall
                                      .copyWith(color: AppColors.grey500)),
                            ],
                          )
                        : const Center(
                            child: Icon(Icons.check_circle_rounded,
                                color: AppColors.success, size: 40)),
                  ),
                )),
            const SizedBox(height: 32),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed:
                        controller.isSubmitting.value ? null : controller.submit,
                    icon: controller.isSubmitting.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.publish_rounded),
                    label: Text(
                        controller.isSubmitting.value
                            ? 'Publication...'
                            : 'Publier le signalement',
                        style: AppTextStyles.buttonText),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
