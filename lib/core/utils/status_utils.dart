import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StatusUtils {
  StatusUtils._();

  static Color requestStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SUBMITTED':
      case 'ASSIGNED':
        return AppColors.statusPending;
      case 'IN_PROGRESS':
      case 'PROCESSED':
      case 'VALIDATED':
        return AppColors.statusInReview;
      case 'REJECTED':
        return AppColors.statusRejected;
      case 'COMPLETED':
        return AppColors.statusCompleted;
      default:
        return AppColors.grey400;
    }
  }

  static String requestStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'SUBMITTED':
        return 'Soumise';
      case 'ASSIGNED':
        return 'Assignée';
      case 'IN_PROGRESS':
        return 'En cours';
      case 'PROCESSED':
        return 'Traitée';
      case 'VALIDATED':
        return 'Validée';
      case 'REJECTED':
        return 'Rejetée';
      case 'COMPLETED':
        return 'Terminée';
      default:
        return status;
    }
  }

  static Color complaintStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return AppColors.statusOpen;
      case 'IN_PROGRESS':
        return AppColors.statusInReview;
      case 'RESOLVED':
        return AppColors.statusResolved;
      case 'CLOSED':
        return AppColors.statusClosed;
      default:
        return AppColors.grey400;
    }
  }

  static String complaintStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return 'Ouvert';
      case 'IN_PROGRESS':
        return 'En cours';
      case 'RESOLVED':
        return 'Résolu';
      case 'CLOSED':
        return 'Fermé';
      default:
        return status;
    }
  }

  static Color missingDocStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'MISSING':
        return AppColors.statusMissing;
      case 'FOUND':
        return AppColors.statusFound;
      case 'RETURNED':
        return AppColors.statusCompleted;
      case 'ARCHIVED':
        return AppColors.grey500;
      default:
        return AppColors.grey400;
    }
  }

  static String missingDocStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'MISSING':
        return 'Perdu';
      case 'FOUND':
        return 'Trouvé';
      case 'RETURNED':
        return 'Rendu';
      case 'ARCHIVED':
        return 'Archivé';
      default:
        return status;
    }
  }

  static String requestTypeLabel(String type) {
    switch (type.toUpperCase()) {
      case 'BIRTH_CERTIFICATE':
        return 'Extrait de naissance';
      case 'DEATH_CERTIFICATE':
        return 'Acte de décès';
      case 'RESIDENCE_CERTIFICATE':
        return 'Certificat de résidence';
      case 'LITERARY_COPY':
        return 'Copie littérale';
      case 'BIRTH_DECLARATION':
        return 'Déclaration de naissance';
      case 'OTHER':
        return 'Autre';
      default:
        return type;
    }
  }
}
