import 'user_model.dart';
import 'administrative_request_model.dart';

class MissingDocumentModel {
  final String id;
  final String title;
  final String description;
  final String? photoUrl;
  final String? lastSeenLocation;
  final double? latitude;
  final double? longitude;
  final String status;
  final bool isVerified;
  final String reportedById;
  final UserModel? reportedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ActionLogModel>? history;

  const MissingDocumentModel({
    required this.id,
    required this.title,
    required this.description,
    this.photoUrl,
    this.lastSeenLocation,
    this.latitude,
    this.longitude,
    required this.status,
    required this.isVerified,
    required this.reportedById,
    this.reportedBy,
    required this.createdAt,
    required this.updatedAt,
    this.history,
  });

  factory MissingDocumentModel.fromJson(Map<String, dynamic> json) {
    final map = (json['data'] is Map && !json.containsKey('title'))
        ? json['data'] as Map<String, dynamic>
        : json;
    return MissingDocumentModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      lastSeenLocation: map['lastSeenLocation'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      status: map['status'] as String? ?? 'MISSING',
      isVerified: map['isVerified'] as bool? ?? false,
      reportedById: map['reportedById']?.toString() ?? '',
      reportedBy: map['reportedBy'] != null
          ? UserModel.fromJson(map['reportedBy'] as Map<String, dynamic>)
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      history: map['history'] != null
          ? (map['history'] as List)
                .map((e) => ActionLogModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'photoUrl': photoUrl,
    'lastSeenLocation': lastSeenLocation,
    'latitude': latitude,
    'longitude': longitude,
    'status': status,
    'isVerified': isVerified,
    'reportedById': reportedById,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  bool get hasLocation => latitude != null && longitude != null;
  bool get isFound => status == 'FOUND';
}
