import 'package:Fellow4U/core/network/api_client.dart';

class HomeService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getHomeData() async {
    final response = await _apiClient.get("/api/v1/home");
    final data = response["data"];
    if (data is Map<String, dynamic>) {
      return data;
    }
    throw ApiException("Invalid home data format");
  }

  Future<List<Map<String, dynamic>>> searchTours({
    required String keyword,
    String? location,
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _apiClient.get(
      "/api/v1/home/search",
      queryParams: {
        "keyword": keyword,
        if (location != null && location.isNotEmpty) "location": location,
        if (category != null && category.isNotEmpty) "category": category,
        "page": page.toString(),
        "limit": limit.toString(),
      },
    );

    final data = response["data"];
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((item) => item.map(
              (key, value) => MapEntry(key.toString(), value),
            ))
        .toList();
  }
}
