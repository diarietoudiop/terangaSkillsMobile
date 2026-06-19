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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Type Selector (Dynamic) ─────────────────
            Text(
              'Type de demande *',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.grey400,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.isLoadingTypes.value) {
                return Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              }
              if (controller.requestTypes.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.warning,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Types indisponibles — Vérifiez la connexion',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.grey400,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: controller.fetchRequestTypes,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                        ),
                        child: const Text(
                          'Réessayer',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                );
              }
              final selectedId =
                  controller.requestTypes.any(
                    (t) => t.id == controller.selectedTypeId.value,
                  )
                  ? controller.selectedTypeId.value
                  : controller.requestTypes.first.id;

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedId,
                    isExpanded: true,
                    dropdownColor: AppColors.darkSurface,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    borderRadius: BorderRadius.circular(12),
                    items: controller.requestTypes.map((t) {
                      return DropdownMenuItem<String>(
                        value: t.id,
                        child: Text(
                          t.departmentName != null
                              ? '${t.name} — ${t.departmentName}'
                              : t.name,
                          style: AppTextStyles.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) controller.selectedTypeId.value = v;
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            // ─── Titre ───────────────────────────────────
            AuthTextField(
              controller: controller.titleController.value,
              label: 'Titre *',
              hint: 'Ex: Demande d\'extrait de naissance',
              prefixIcon: Icons.title_rounded,
            ),
            const SizedBox(height: 16),

            // ─── Description (optionnel avec guide) ──────
            AuthTextField(
              controller: controller.descriptionController.value,
              label: 'Informations complémentaires (optionnel)',
              hint: controller.descriptionHint,
              prefixIcon: Icons.notes_rounded,
              maxLines: 4,
            ),
            const SizedBox(height: 8),
            Obx(
              () => controller.descriptionHint.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.info.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.info,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Ex. pour acte de naissance : numéro de registre.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.info,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),

            // ─── File Attachments ─────────────────────────
            Text(
              'Pièces jointes (optionnel)',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.grey400,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Column(
                children: [
                  ...controller.pickedFiles.asMap().entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.darkCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.darkBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.attach_file_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                e.value.name,
                                style: AppTextStyles.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.removeFile(e.key),
                              child: const Icon(
                                Icons.close_rounded,
                                color: AppColors.grey500,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.pickFiles,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.25),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_upload_rounded,
                            color: AppColors.primary,
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Ajouter des fichiers',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          Text('JPG, PNG', style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ─── Upload Progress ──────────────────────────
            Obx(() {
              if (!controller.isSubmitting.value)
                return const SizedBox.shrink();
              final pct = (controller.uploadProgress.value * 100).toInt();
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: controller.uploadProgress.value,
                        backgroundColor: AppColors.darkBorder,
                        color: AppColors.primary,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Envoi en cours... $pct%',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                  ],
                ),
              );
            }),

            // ─── Submit ───────────────────────────────────
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () => _showPaymentSheet(context),
                  icon: controller.isSubmitting.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.payment_rounded),
                  label: Text(
                    controller.isSubmitting.value
                        ? 'Envoi en cours...'
                        : 'Passer au paiement',
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentSheet(BuildContext context) {
    if (controller.selectedTypeId.value.isEmpty) {
      Get.snackbar(
        'Attention',
        'Veuillez sélectionner un type de demande.',
        backgroundColor: AppColors.warning.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }
    if (controller.titleController.value.text.trim().isEmpty) {
      Get.snackbar(
        'Attention',
        'Le titre est obligatoire.',
        backgroundColor: AppColors.warning.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    const int cost = 2500;
    final phoneCtrl = TextEditingController();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border(top: BorderSide(color: AppColors.darkBorder)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.darkBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Simulation de paiement',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Frais de dossier pour votre demande',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
                const SizedBox(height: 16),
                // Amount display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.monetization_on_outlined,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$cost FCFA',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Numéro Mobile Money',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.grey400,
                  ),
                ),
                const SizedBox(height: 8),
                // Phone field – using TextEditingController (no closure var)
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.text,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ex: 77 123 45 67',
                    hintStyle: TextStyle(color: AppColors.grey500),
                    prefixIcon: const Icon(
                      Icons.phone_android,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    fillColor: AppColors.darkCard,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.darkBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.darkBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final phone = phoneCtrl.text.replaceAll(
                        RegExp(r'\s+'),
                        '',
                      );
                      if (phone.length < 9) {
                        Get.snackbar(
                          'Numéro invalide',
                          'Entrez un numéro valide (min 9 chiffres)',
                          backgroundColor: AppColors.error.withOpacity(0.9),
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                        );
                        return;
                      }
                      phoneCtrl.dispose();
                      Get.back();
                      Future.delayed(
                        const Duration(milliseconds: 300),
                        controller.submitRequest,
                      );
                    },
                    icon: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Confirmer le paiement',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
