import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/status_utils.dart';
import '../controller/ai_chat_controller.dart';

class AiChatView extends GetView<AiChatController> {
  const AiChatView({super.key});

  @override
  Widget build(BuildContext context) {
    // Register dependency on Theme to react to dynamic light/dark mode switch
    Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: Get.back,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TerangaAI 🇸🇳', style: AppTextStyles.titleMedium),
            const SizedBox(height: 2),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Assistant Wolof en ligne',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.success,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Chat Messages History ───
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.messages.length,
                  itemBuilder: (_, index) {
                    final msg = controller.messages[index];
                    final isUser = msg['role'] == 'user';
                    
                    // Strip JSON block from model messages to keep text clean
                    final rawText = msg['text'] as String;
                    final cleanText = rawText
                        .replaceAll(RegExp(r'```json[\s\S]*?```'), '')
                        .trim();

                    if (cleanText.isEmpty && !isUser) {
                      return const SizedBox.shrink();
                    }

                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: isUser
                              ? AppColors.primary
                              : (Get.isDarkMode
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isUser ? 16 : 0),
                            bottomRight: Radius.circular(isUser ? 0 : 16),
                          ),
                        ),
                        child: Text(
                          cleanText,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isUser 
                                ? Colors.white 
                                : AppColors.text,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            // ─── Special Action Widget (Pre-filled Request Card) ───
            Obx(() {
              final action = controller.pendingAction.value;
              if (action == null) return const SizedBox.shrink();

              final type = action['type'] ?? 'OTHER';
              final title = action['title'] ?? '';
              final description = action['description'] ?? '';
              final typeLabel = StatusUtils.requestTypeLabel(type);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Iconsax.document_text5, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dossier prêt à soumettre !',
                                style: AppTextStyles.titleSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                typeLabel,
                                style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20, thickness: 0.8),
                    Text(
                      'Titre :',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey500),
                    ),
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Détails de la demande :',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey500),
                    ),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Obx(() {
                        final submitting = controller.isSubmitting.value;
                        return ElevatedButton(
                          onPressed: submitting
                              ? null
                              : () => controller.submitAssistRequest(type, title, description),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: submitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Valider & Soumettre la demande',
                                  style: AppTextStyles.buttonText.copyWith(color: Colors.white),
                                ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }),

            // ─── Chat Input Area ───
            Obx(() {
              final activeLoading = controller.isLoading.value;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  border: Border(
                    top: BorderSide(color: AppColors.darkBorder, width: 0.8),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? const Color(0xFF1F2937)
                              : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: controller.textController,
                          enabled: !activeLoading,
                          style: AppTextStyles.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Mbindal say laaj fi... / Posez vos questions...',
                            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey500),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onSubmitted: (_) => controller.sendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: activeLoading ? null : controller.sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: activeLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
