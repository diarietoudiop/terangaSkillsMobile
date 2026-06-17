class DocumentModel {
  final String id;
  final String name;
  final String fileUrl;
  final String? qrCodeUrl;
  final bool isVerified;
  final String? administrativeRequestId;
  final DateTime createdAt;

  const DocumentModel({
    required this.id,
    required this.name,
    required this.fileUrl,
    this.qrCodeUrl,
    required this.isVerified,
    this.administrativeRequestId,
    required this.createdAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    final map = (json['data'] is Map && !json.containsKey('name')) ? json['data'] as Map<String, dynamic> : json;
    return DocumentModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      fileUrl: map['fileUrl']?.toString() ?? '',
      qrCodeUrl: map['qrCodeUrl'] as String?,
      isVerified: map['isVerified'] as bool? ?? false,
      administrativeRequestId: map['administrativeRequestId'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'fileUrl': fileUrl,
        'qrCodeUrl': qrCodeUrl,
        'isVerified': isVerified,
        'administrativeRequestId': administrativeRequestId,
        'createdAt': createdAt.toIso8601String(),
      };
}

class DocumentVerificationModel {
  final bool isValid;
  final DocumentModel? document;
  final String? message;

  const DocumentVerificationModel({
    required this.isValid,
    this.document,
    this.message,
  });

  factory DocumentVerificationModel.fromJson(Map<String, dynamic> json) {
    final map = (json['data'] is Map && !json.containsKey('isVerified') && !json.containsKey('isValid'))
        ? json['data'] as Map<String, dynamic>
        : json;
    return DocumentVerificationModel(
      isValid: (map['isVerified'] ?? map['isValid']) as bool? ?? false,
      document: map['document'] != null
          ? DocumentModel.fromJson(map['document'] as Map<String, dynamic>)
          : (map['id'] != null ? DocumentModel.fromJson(map) : null),
      message: map['message'] as String?,
    );
  }
}
