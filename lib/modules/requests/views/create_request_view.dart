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
            // ─── Type Selector (Dynamic) ─────────────────
            Text(
              'Type de demande',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.grey400),
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.isLoadingTypes.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }
              if (controller.requestTypes.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.fromBorderSide(
                      BorderSide(color: AppColors.darkBorder),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: AppColors.warning, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Impossible de charger les types de demande. Vérifiez la connexion.',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.grey400),
                        ),
                      ),
                      TextButton(
                        onPressed: controller.fetchRequestTypes,
                        child: const Text('Réessayer',
                            style: TextStyle(color: AppColors.primary)),
                      ),
                    ],
                  ),
                );
              }
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.fromBorderSide(
                    BorderSide(color: AppColors.darkBorder),
                  ),
                ),
                child: DropdownButtonFormField<String>(
                  value: controller.requestTypes
                          .any((t) => t.id == controller.selectedTypeId.value)
                      ? controller.selectedTypeId.value
                      : controller.requestTypes.first.id,
                  dropdownColor: AppColors.darkSurface,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  items: controller.requestTypes
                      .map(
                        (t) => DropdownMenuItem(
                          value: t.id,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(t.name,
                                  style: AppTextStyles.bodyMedium),
                              if (t.departmentName != null)
                                Text(
                                  'Service: ${t.departmentName}',
                                  style: AppTextStyles.caption.copyWith(
                                      color: AppColors.grey500),
                                ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) controller.selectedTypeId.value = v;
                  },
                ),
              );
            }),
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
            Text(
              'Pièces jointes',
              style:
                  AppTextStyles.labelMedium.copyWith(color: AppColors.grey400),
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
                          border: Border.fromBorderSide(
                            BorderSide(color: AppColors.darkBorder),
                          ),
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
                              onPressed: () => controller.removeFile(e.key),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
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
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.cloud_upload_rounded,
                              color: AppColors.primary, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            'Ajouter des fichiers',
                            style: AppTextStyles.labelMedium
                                .copyWith(color: AppColors.primary),
                          ),
                          Text('JPG, PNG (optionnel)',
                              style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // ─── Upload Progress ─────────────────────
            Obx(() {
              if (controller.isSubmitting.value) {
                final pct = (controller.uploadProgress.value * 100).toInt();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
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
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Téléversement...',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.grey400),
                          ),
                          Text(
                            '$pct%',
                            style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            // ─── Submit Button ───────────────────────
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
                              strokeWidth: 2, color: Colors.white),
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
      Get.snackbar('Attention', 'Veuillez sélectionner un type de demande.',
          backgroundColor: AppColors.warning.withOpacity(0.9),
          colorText: Colors.white);
      return;
    }
    if (controller.titleController.value.text.isEmpty ||
        controller.descriptionController.value.text.isEmpty) {
      Get.snackbar('Attention', 'Veuillez remplir tous les champs.',
          backgroundColor: AppColors.warning.withOpacity(0.9),
          colorText: Colors.white);
      return;
    }

    const int cost = 2500;
    String phoneNumber = '';

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: AppColors.darkBorder)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.darkBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text('Paiement de la demande',
                  style: AppTextStyles.titleMedium
                      .copyWith(color: AppColors.text)),
              const SizedBox(height: 4),
              Text('Frais de dossier',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.grey400)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on_outlined,
                        color: AppColors.primary, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      '$cost FCFA',
                      style: AppTextStyles.headlineSmall
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Numéro Mobile Money',
                style: AppTextStyles.labelMedium
                    .copyWith(color: AppColors.grey400),
              ),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.phone,
                autofocus: false,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.text),
                decoration: InputDecoration(
                  hintText: 'Ex: 77 123 45 67',
                  hintStyle: TextStyle(color: AppColors.grey500),
                  prefixIcon: const Icon(Icons.phone_android,
                      color: AppColors.primary),
                  filled: true,
                  fillColor: AppColors.darkCard,
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
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
                onChanged: (val) => phoneNumber = val,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final digits =
                        phoneNumber.replaceAll(RegExp(r'\s'), '');
                    if (digits.length < 9) {
                      Get.snackbar(
                        'Numéro invalide',
                        'Veuillez entrer un numéro valide (9 chiffres min.)',
                        backgroundColor: AppColors.error.withOpacity(0.9),
                        colorText: Colors.white,
                      );
                      return;
                    }
                    Get.back();
                    Future.delayed(const Duration(milliseconds: 300),
                        controller.submitRequest);
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Confirmer le paiement',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
