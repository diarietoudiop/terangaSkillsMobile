import 'user_model.dart';
import 'request_type_model.dart';

class AdministrativeRequestModel {
  final String id;
  /// Legacy field kept for backward compat – maps to requestType.name
  final String type;
  final String? requestTypeId;
  final RequestTypeModel? requestType;
  final String title;
  final String description;
  final dynamic data;
  final List<String> attachments;
  final String status;
  final String citizenId;
  final UserModel? citizen;
  final String? assignedAgentId;
  final UserModel? assignedAgent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ActionLogModel>? history;
  final Map<String, dynamic>? document;

  const AdministrativeRequestModel({
    required this.id,
    required this.type,
    this.requestTypeId,
    this.requestType,
    required this.title,
    required this.description,
    this.data,
    required this.attachments,
    required this.status,
    required this.citizenId,
    this.citizen,
    this.assignedAgentId,
    this.assignedAgent,
    required this.createdAt,
    required this.updatedAt,
    this.history,
    this.document,
  });

  factory AdministrativeRequestModel.fromJson(Map<String, dynamic> json) {
    final map = (json['data'] is Map && !json.containsKey('title'))
        ? json['data'] as Map<String, dynamic>
        : json;

    // requestType object from the API
    final rtMap = map['requestType'] as Map<String, dynamic>?;
    final rtName = rtMap?['name']?.toString() ?? '';
    // 'type' can come from legacy enum or from requestType.name
    final typeStr = map['type']?.toString() ?? rtName;

    return AdministrativeRequestModel(
      id: map['id']?.toString() ?? '',
      type: typeStr.isNotEmpty ? typeStr : 'OTHER',
      requestTypeId: map['requestTypeId']?.toString(),
      requestType:
          rtMap != null ? RequestTypeModel.fromJson(rtMap) : null,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      data: map['data'],
      attachments: List<String>.from(map['attachments'] as List? ?? []),
      status: map['status'] as String? ?? 'SUBMITTED',
      citizenId: map['citizenId']?.toString() ?? '',
      citizen: map['citizen'] != null
          ? UserModel.fromJson(map['citizen'] as Map<String, dynamic>)
          : null,
      assignedAgentId: map['assignedAgentId'] as String?,
      assignedAgent: map['assignedAgent'] != null
          ? UserModel.fromJson(map['assignedAgent'] as Map<String, dynamic>)
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
      document: map['document'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'description': description,
    'data': data,
    'attachments': attachments,
    'status': status,
    'citizenId': citizenId,
    'assignedAgentId': assignedAgentId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class ActionLogModel {
  final String id;
  final String action;
  final String? description;
  final String actorId;
  final UserModel? actor;
  final DateTime createdAt;

  const ActionLogModel({
    required this.id,
    required this.action,
    this.description,
    required this.actorId,
    this.actor,
    required this.createdAt,
  });

  factory ActionLogModel.fromJson(Map<String, dynamic> json) {
    return ActionLogModel(
      id: json['id'] as String,
      action: json['action'] as String,
      description: json['description'] as String?,
      actorId: json['actorId'] as String,
      actor: json['actor'] != null
          ? UserModel.fromJson(json['actor'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
