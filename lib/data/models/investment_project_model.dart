class InvestmentProjectModel {
  final String id;
  final String name;
  final String? description;
  final num budget;
  final num progress;
  final String? company;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;

  const InvestmentProjectModel({
    required this.id,
    required this.name,
    this.description,
    required this.budget,
    required this.progress,
    this.company,
    required this.status,
    this.startDate,
    this.endDate,
  });

  factory InvestmentProjectModel.fromJson(Map<String, dynamic> json) {
    final map = (json['data'] is Map && !json.containsKey('name'))
        ? json['data'] as Map<String, dynamic>
        : json;
    return InvestmentProjectModel(
      id: map['id']?.toString() ?? '',
      name:
          map['name']?.toString() ??
          map['title']?.toString() ??
          'Projet sans nom',
      description: map['description']?.toString(),
      budget: map['budget'] as num? ?? 0,
      progress: map['progress'] as num? ?? 0,
      company: map['company']?.toString() ?? map['contractor']?.toString(),
      status: map['status']?.toString() ?? 'PLANNED',
      startDate: map['startDate'] != null
          ? DateTime.tryParse(map['startDate'].toString())
          : null,
      endDate: map['endDate'] != null
          ? DateTime.tryParse(map['endDate'].toString())
          : null,
    );
  }
}
