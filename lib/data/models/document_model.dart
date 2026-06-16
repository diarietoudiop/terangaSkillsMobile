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
    return DocumentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      fileUrl: json['fileUrl'] as String,
      qrCodeUrl: json['qrCodeUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      administrativeRequestId: json['administrativeRequestId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
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
    return DocumentVerificationModel(
      isValid: json['isVerified'] as bool? ?? false,
      document: json['document'] != null
          ? DocumentModel.fromJson(json['document'] as Map<String, dynamic>)
          : (json['id'] != null ? DocumentModel.fromJson(json) : null),
      message: json['message'] as String?,
    );
  }
}
