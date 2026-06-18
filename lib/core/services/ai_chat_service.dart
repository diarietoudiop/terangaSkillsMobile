import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class AiChatService {
  final Dio _dio = Dio();

  static const String _systemInstruction = 
      "Vous êtes TerangaAI, un assistant administratif chaleureux et bienveillant pour la plateforme numérique citoyenne TerangaSkills au Sénégal. "
      "Votre rôle est d'aider les citoyens sénégalais à préparer et soumettre leurs demandes administratives (extraits de naissance, certificats de résidence, etc.).\n\n"
      "CONSIGNES LINGUISTIQUES :\n"
      "- Parlez principalement en Wolof (langue nationale) de manière polie et naturelle (ex: Nanga def, lan la la mëna jabal tey?).\n"
      "- Vous pouvez alterner avec le Français si l'utilisateur s'exprime en français ou fait du code-switching (mélange Wolof/Français).\n\n"
      "CONSIGNES FONCTIONNELLES :\n"
      "- Votre but est de guider pas-à-pas l'utilisateur pour rédiger sa demande.\n"
      "- Posez des questions courtes et progressives, une seule à la fois, pour obtenir les détails indispensables :\n"
      "  1. Le type de demande (à choisir parmi : BIRTH_CERTIFICATE [Extrait de naissance], DEATH_CERTIFICATE [Acte de décès], RESIDENCE_CERTIFICATE [Certificat de résidence], LITERARY_COPY [Copie littérale], BIRTH_DECLARATION [Déclaration de naissance], OTHER [Autre]).\n"
      "  2. Le titre précis de sa demande.\n"
      "  3. Une description claire des détails (nom complet, date de naissance, lieu, filiation si nécessaire).\n\n"
      "SOUUMISSION DU DOSSIER :\n"
      "Une fois que vous avez COLLECTÉ les 3 informations (Type, Titre, Description), remerciez l'utilisateur chaleureusement en Wolof/Français et expliquez-lui que son dossier est prêt. "
      "À la toute fin de votre message, vous devez obligatoirement ajouter un bloc de code JSON structuré entre triple backticks exactement sous cette forme :\n"
      "```json\n"
      "{\n"
      "  \"action\": \"submit_request\",\n"
      "  \"type\": \"BIRTH_CERTIFICATE\",\n"
      "  \"title\": \"Le titre rédigé\",\n"
      "  \"description\": \"La description complète avec les détails collectés\"\n"
      "}\n"
      "```\n"
      "Attention : Ne générez ce bloc de code JSON QUE lorsque vous avez toutes les informations nécessaires.";

  Future<String> sendMessage(List<Map<String, dynamic>> chatHistory) async {
    final key = AppConstants.geminiApiKey;
    if (key == 'VOTRE_CLE_API_GEMINI_ICI' || key.isEmpty) {
      return "Erreur : La clé API Gemini n'est pas configurée dans AppConstants.";
    }

    final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$key';

    // Format history for Gemini API
    final contents = chatHistory.map((msg) {
      return {
        'role': msg['role'] == 'user' ? 'user' : 'model',
        'parts': [
          {'text': msg['text']}
        ]
      };
    }).toList();

    final payload = {
      'contents': contents,
      'systemInstruction': {
        'parts': [
          {'text': _systemInstruction}
        ]
      },
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 1000,
      }
    };

    try {
      final response = await _dio.post(
        url,
        data: payload,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final candidates = response.data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          if (content != null) {
            final parts = content['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              return parts[0]['text'] as String? ?? "Désolé, je n'ai pas pu générer de réponse.";
            }
          }
        }
      }
      return "Désolé, une erreur s'est produite lors de la génération de la réponse.";
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return "Erreur : Requête invalide (vérifiez le format ou la clé API).";
      } else if (e.response?.statusCode == 403) {
        return "Erreur : Clé API Gemini invalide ou non autorisée.";
      }
      return "Erreur de connexion avec l'IA : ${e.message}";
    } catch (e) {
      return "Erreur inattendue : $e";
    }
  }
}
