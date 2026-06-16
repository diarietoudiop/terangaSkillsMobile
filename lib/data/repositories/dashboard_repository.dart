import '../../core/network/api_client.dart';
import '../models/dashboard_model.dart';

class DashboardRepository {
  final ApiClient _apiClient;

  DashboardRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<DashboardStatsModel> getStats() async {
    final response = await _apiClient.getDashboardStats();
    return DashboardStatsModel.fromJson(response.data as Map<String, dynamic>);
  }
}
