class DashboardStatsModel {
  final UsersStats users;
  final AdminRequestsStats administrativeRequests;
  final ComplaintsStats complaints;
  final MissingDocsStats missingDocuments;

  const DashboardStatsModel({
    required this.users,
    required this.administrativeRequests,
    required this.complaints,
    required this.missingDocuments,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      users: UsersStats.fromJson(json['users'] as Map<String, dynamic>),
      administrativeRequests: AdminRequestsStats.fromJson(
          json['administrativeRequests'] as Map<String, dynamic>),
      complaints:
          ComplaintsStats.fromJson(json['complaints'] as Map<String, dynamic>),
      missingDocuments: MissingDocsStats.fromJson(
          json['missingDocuments'] as Map<String, dynamic>),
    );
  }
}

class UsersStats {
  final int total;
  const UsersStats({required this.total});
  factory UsersStats.fromJson(Map<String, dynamic> json) =>
      UsersStats(total: json['total'] as int? ?? 0);
}

class AdminRequestsStats {
  final int total;
  final int pending;
  final int completed;

  const AdminRequestsStats({
    required this.total,
    required this.pending,
    required this.completed,
  });

  factory AdminRequestsStats.fromJson(Map<String, dynamic> json) =>
      AdminRequestsStats(
        total: json['total'] as int? ?? 0,
        pending: json['pending'] as int? ?? 0,
        completed: json['completed'] as int? ?? 0,
      );

  int get inProgress => total - pending - completed;
  double get completionRate => total == 0 ? 0 : (completed / total) * 100;
}

class ComplaintsStats {
  final int total;
  final int resolved;

  const ComplaintsStats({required this.total, required this.resolved});

  factory ComplaintsStats.fromJson(Map<String, dynamic> json) =>
      ComplaintsStats(
        total: json['total'] as int? ?? 0,
        resolved: json['resolved'] as int? ?? 0,
      );

  double get resolutionRate => total == 0 ? 0 : (resolved / total) * 100;
}

class MissingDocsStats {
  final int total;
  final int found;

  const MissingDocsStats({required this.total, required this.found});

  factory MissingDocsStats.fromJson(Map<String, dynamic> json) =>
      MissingDocsStats(
        total: json['total'] as int? ?? 0,
        found: json['found'] as int? ?? 0,
      );

  double get foundRate => total == 0 ? 0 : (found / total) * 100;
}
