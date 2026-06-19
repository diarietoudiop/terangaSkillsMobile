import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/ai_chat_service.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/administrative_request_repository.dart';
import '../../requests/controller/requests_controller.dart';

class AiChatController extends GetxController {
  final AiChatService _chatService = AiChatService();
  final AdministrativeRequestRepository _repo = AdministrativeRequestRepository();

  final messages = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  
  final textController = TextEditingController();
  final scrollController = ScrollController();

  // Reactive state for parsed request action if detected in AI response
  final pendingAction = Rxn<Map<String, String>>();

  @override
  void onInit() {
    super.onInit();
    // Welcome message in Wolof
    messages.add({
      'role': 'model',
      'text': "Na nga def ? TerangaAI laa, sa ndabal ci wàllu karange ak say jokkoo ci mairie bi. Lan la la mëna jabal tey ?\n\n(Bonjour ! Je suis TerangaAI, votre assistant administratif pour TerangaSkills. Comment puis-je vous aider aujourd'hui ?)",
      'timestamp': DateTime.now(),
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> sendMessage() async {
    final query = textController.text.trim();
    if (query.isEmpty) return;

    textController.clear();
    pendingAction.value = null; // Clear any pending submit action

    // User message
    messages.add({
      'role': 'user',
      'text': query,
      'timestamp': DateTime.now(),
    });
    
    _scrollToBottom();
    isLoading.value = true;

    try {
      // Build history payload for Gemini
      final history = messages.map((m) => {
        'role': m['role'],
        'text': m['text']
      }).toList();

      final response = await _chatService.sendMessage(history);

      // Model response
      messages.add({
        'role': 'model',
        'text': response,
        'timestamp': DateTime.now(),
      });

      // Scan response for JSON actions
      _checkForJsonAction(response);
    } catch (e) {
      AppSnackbar.error("Erreur assistant: $e");
    } finally {
      isLoading.value = false;
      _scrollToBottom();
    }
  }

  void _checkForJsonAction(String response) {
    try {
      // Look for ```json ... ``` blocks
      final regExp = RegExp(r'```json\s*([\s\S]*?)\s*```');
      final match = regExp.firstMatch(response);
      if (match != null && match.groupCount >= 1) {
        final jsonStr = match.group(1)?.trim();
        if (jsonStr != null && jsonStr.isNotEmpty) {
          final data = json.decode(jsonStr) as Map<String, dynamic>;
          if (data['action'] == 'submit_request') {
            pendingAction.value = {
              'type': data['type']?.toString() ?? 'OTHER',
              'title': data['title']?.toString() ?? '',
              'description': data['description']?.toString() ?? '',
            };
          }
        }
      }
    } catch (e) {
      // Silent catch (parsing error or not a JSON command)
      debugPrint("Parsing action failed: $e");
    }
  }

  Future<void> submitAssistRequest(String type, String title, String description) async {
    try {
      isSubmitting.value = true;

      String? requestTypeId;
      if (Get.isRegistered<RequestsController>()) {
        final reqCtrl = Get.find<RequestsController>();
        final types = reqCtrl.requestTypes;
        if (types.isNotEmpty) {
          final matched = types.firstWhereOrNull(
            (t) => t.name.toLowerCase().contains(type.toLowerCase()) || 
                   type.toLowerCase().contains(t.name.toLowerCase())
          );
          requestTypeId = matched?.id ?? types.first.id;
        }
      }

      if (requestTypeId == null) {
        final reqCtrl = Get.put(RequestsController());
        await reqCtrl.fetchRequestTypes();
        final types = reqCtrl.requestTypes;
        if (types.isNotEmpty) {
          final matched = types.firstWhereOrNull(
            (t) => t.name.toLowerCase().contains(type.toLowerCase()) || 
                   type.toLowerCase().contains(t.name.toLowerCase())
          );
          requestTypeId = matched?.id ?? types.first.id;
        }
      }

      if (requestTypeId == null || requestTypeId.isEmpty) {
        throw Exception("Aucun type de demande configuré par la mairie.");
      }

      await _repo.createRequest(
        requestTypeId: requestTypeId,
        title: title,
        description: description,
      );
      
      AppSnackbar.success("Votre demande '$title' a été soumise avec succès !");
      pendingAction.value = null; // Consume action

      // Add success confirmation in chat
      messages.add({
        'role': 'model',
        'text': "Sa dossier wacc na tey, yonnee nanu ko ! Ndabal li wéy na.\n(Votre demande a bien été soumise ! L'assistant reste à votre écoute.)",
        'timestamp': DateTime.now(),
      });

      // Refresh list in requests tab if active
      if (Get.isRegistered<RequestsController>()) {
        Get.find<RequestsController>().fetchMyRequests();
      }
    } catch (e) {
      AppSnackbar.error("Échec de la soumission: $e");
    } finally {
      isSubmitting.value = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
