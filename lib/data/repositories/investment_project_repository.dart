import '../../core/network/api_client.dart';
import '../models/investment_project_model.dart';

class InvestmentProjectRepository {
  final ApiClient _apiClient;

  InvestmentProjectRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<InvestmentProjectModel>> getProjects() async {
    final response = await _apiClient.getInvestmentProjects();
    final data = response.data;
    final List list = (data is Map)
        ? (data['data'] ?? data['projects'] ?? data['investmentProjects'] ?? [])
        : (data as List? ?? []);
    return list
        .map((e) => InvestmentProjectModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<InvestmentProjectModel> getProject(String id) async {
    final response = await _apiClient.getInvestmentProject(id);
    final data = response.data;
    final map = (data is Map && data.containsKey('data')) ? data['data'] : data;
    return InvestmentProjectModel.fromJson(map as Map<String, dynamic>);
  }
}
