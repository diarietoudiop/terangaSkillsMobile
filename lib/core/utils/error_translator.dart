class ErrorTranslator {
  ErrorTranslator._();

  static String translate(String? errorMessage) {
    if (errorMessage == null || errorMessage.isEmpty) return 'Erreur inconnue';

    final msg = errorMessage.toLowerCase();

    if (msg.contains('unauthorized')) return 'Non autorisé';
    if (msg.contains('forbidden')) return 'Accès refusé';
    if (msg.contains('invalid credentials')) return 'Identifiants invalides';
    if (msg.contains('user not found')) return 'Utilisateur introuvable';
    if (msg.contains('request not found')) return 'Demande introuvable';
    if (msg.contains('document not found')) return 'Document introuvable';
    if (msg.contains('internal server error')) return 'Erreur interne du serveur';
    if (msg.contains('email already exists') || msg.contains('unique constraint failed on the fields: (`email`)')) {
      return 'Cet email est déjà utilisé';
    }
    if (msg.contains('bad request')) return 'Requête invalide';
    if (msg.contains('missing') && msg.contains('token')) return 'Session expirée, veuillez vous reconnecter';
    if (msg.contains('not found')) return 'Ressource introuvable';
    if (msg.contains('jwt expired')) return 'Session expirée, veuillez vous reconnecter';

    // Fallback: return the original message if no translation is found, but maybe capitalize it
    return errorMessage;
  }
}
