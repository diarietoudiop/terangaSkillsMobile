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
    return ComplaintModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'OPEN',
      citizenId: json['citizenId'] as String,
      citizen: json['citizen'] != null
          ? UserModel.fromJson(json['citizen'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      history: json['history'] != null
          ? (json['history'] as List)
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
