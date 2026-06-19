class RequestTypeModel {
  final String id;
  final String name;
  final String? description;
  final String departmentId;
  final String? departmentName;

  const RequestTypeModel({
    required this.id,
    required this.name,
    this.description,
    required this.departmentId,
    this.departmentName,
  });

  factory RequestTypeModel.fromJson(Map<String, dynamic> json) {
    final dept = json['department'] as Map<String, dynamic>?;
    return RequestTypeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      departmentId: json['departmentId']?.toString() ?? '',
      departmentName: dept?['name']?.toString(),
    );
  }
}
