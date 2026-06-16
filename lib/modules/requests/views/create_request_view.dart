import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/requests_controller.dart';
import '../../auth/widgets/auth_text_field.dart';

class CreateRequestView extends GetView<RequestsController> {
  const CreateRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: Get.back,
        ),
        title: Text('Nouvelle demande', style: AppTextStyles.titleMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Type Selector ──────────────────────
            Text('Type de demande', style: AppTextStyles.labelMedium
                .copyWith(color: AppColors.grey400)),
            const SizedBox(height: 8),
            Obx(() => Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(12),
                    border: const Border.fromBorderSide(
                        BorderSide(color: AppColors.darkBorder)),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: controller.selectedType.value,
                    dropdownColor: AppColors.darkSurface,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    items: RequestsController.requestTypes
                        .map((t) => DropdownMenuItem(
                              value: t['value'],
                              child: Text(t['label']!,
                                  style: AppTextStyles.bodyMedium),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) controller.selectedType.value = v;
                    },
                  ),
                )),
            const SizedBox(height: 20),
            AuthTextField(
              controller: controller.titleController.value,
              label: 'Titre',
              hint: 'Ex: Demande d\'extrait de naissance',
              prefixIcon: Icons.title_rounded,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: controller.descriptionController.value,
              label: 'Description',
              hint: 'Décrivez votre demande en détail...',
              prefixIcon: Icons.notes_rounded,
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            // ─── File Attachments ───────────────────
            Text('Pièces jointes', style: AppTextStyles.labelMedium
                .copyWith(color: AppColors.grey400)),
            const SizedBox(height: 8),
            Obx(() => Column(
                  children: [
                    ...controller.pickedFiles.asMap().entries.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.darkCard,
                              borderRadius: BorderRadius.circular(10),
                              border: const Border.fromBorderSide(
                                  BorderSide(color: AppColors.darkBorder)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.attach_file_rounded,
                                    color: AppColors.primary, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    e.value.name,
                                    style: AppTextStyles.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded,
                                      color: AppColors.grey500, size: 18),
                                  onPressed: () =>
                                      controller.removeFile(e.key),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                        )),
                    GestureDetector(
                      onTap: controller.pickFiles,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              style: BorderStyle.solid),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.cloud_upload_rounded,
                                color: AppColors.primary, size: 32),
                            const SizedBox(height: 8),
                            Text('Ajouter des fichiers',
                                style: AppTextStyles.labelMedium
                                    .copyWith(color: AppColors.primary)),
                            Text('JPG, PNG (optionnel)',
                                style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 32),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : controller.submitRequest,
                    icon: controller.isSubmitting.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send_rounded),
                    label: Text(
                        controller.isSubmitting.value
                            ? 'Envoi en cours...'
                            : 'Soumettre la demande',
                        style: AppTextStyles.buttonText),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
