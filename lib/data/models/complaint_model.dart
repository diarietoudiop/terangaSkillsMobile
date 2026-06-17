import 'user_model.dart';
import 'administrative_request_model.dart';

class ComplaintModel {
  final String id;
  final String title;
  final String description;
  final String? photoUrl;
  final double? latitude;
  final double? longitude;
  final String status;
  final String citizenId;
  final UserModel? citizen;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ActionLogModel>? history;

  const ComplaintModel({
    required this.id,
    required this.title,
    required this.description,
    this.photoUrl,
    this.latitude,
    this.longitude,
    required this.status,
    required this.citizenId,
    this.citizen,
    required this.createdAt,
    required this.updatedAt,
    this.history,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    final map = (json['data'] is Map && !json.containsKey('title'))
        ? json['data'] as Map<String, dynamic>
        : json;
    return ComplaintModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      status: map['status'] as String? ?? 'OPEN',
      citizenId: map['citizenId']?.toString() ?? '',
      citizen: map['citizen'] != null
          ? UserModel.fromJson(map['citizen'] as Map<String, dynamic>)
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
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'citizenId': citizenId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  bool get hasLocation => latitude != null && longitude != null;
}
