import 'package:Fellow4U/core/network/api_client.dart';
import 'package:Fellow4U/features/auth/data/auth_session.dart';

class TripsService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Map<String, dynamic>>> getMyTrips({
    required String status,
    int page = 1,
    int limit = 20,
  }) async {
    final accessToken = await AuthSession.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      throw ApiException("You are not logged in", statusCode: 401);
    }

    final response = await _apiClient.get(
      "/api/v1/my-trips",
      headers: {"Authorization": "Bearer $accessToken"},
      queryParams: {
        "status": status,
        "page": page.toString(),
        "limit": limit.toString(),
      },
    );

    final data = response["data"];
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((item) => item.map((k, v) => MapEntry(k.toString(), v)))
        .toList();
  }

  Future<Map<String, dynamic>> getTripDetail(String tripId) async {
    final accessToken = await AuthSession.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      throw ApiException("You are not logged in", statusCode: 401);
    }

    final response = await _apiClient.get(
      "/api/v1/my-trips/$tripId",
      headers: {"Authorization": "Bearer $accessToken"},
    );

    final data = response["data"];
    if (data is! Map<String, dynamic>) {
      throw ApiException("Invalid trip detail data");
    }
    return data;
  }

  Future<Map<String, dynamic>> createTrip({
    required String title,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    required int participants,
    required double totalPrice,
    String status = "next",
    String notes = "",
  }) async {
    final accessToken = await AuthSession.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      throw ApiException("You are not logged in", statusCode: 401);
    }

    final response = await _apiClient.post(
      "/api/v1/my-trips",
      headers: {"Authorization": "Bearer $accessToken"},
      body: {
        "title": title,
        "location": location,
        "status": status,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "participants": participants,
        "totalPrice": totalPrice,
        "notes": notes,
      },
    );

    final data = response["data"];
    if (data is! Map<String, dynamic>) {
      throw ApiException("Invalid trip create data");
    }
    return data;
  }

  Future<Map<String, dynamic>> updateTrip({
    required String tripId,
    String? title,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    int? participants,
    double? totalPrice,
    String? notes,
    String? status,
  }) async {
    final accessToken = await AuthSession.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      throw ApiException("You are not logged in", statusCode: 401);
    }

    final response = await _apiClient.patch(
      "/api/v1/my-trips/$tripId",
      headers: {"Authorization": "Bearer $accessToken"},
      body: {
        if (title != null) "title": title,
        if (location != null) "location": location,
        if (startDate != null) "startDate": startDate.toIso8601String(),
        if (endDate != null) "endDate": endDate.toIso8601String(),
        if (participants != null) "participants": participants,
        if (totalPrice != null) "totalPrice": totalPrice,
        if (notes != null) "notes": notes,
        if (status != null) "status": status,
      },
    );

    final data = response["data"];
    if (data is! Map<String, dynamic>) {
      throw ApiException("Invalid trip update data");
    }
    return data;
  }

  Future<void> deleteTrip(String tripId) async {
    final accessToken = await AuthSession.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      throw ApiException("You are not logged in", statusCode: 401);
    }

    await _apiClient.delete(
      "/api/v1/my-trips/$tripId",
      headers: {"Authorization": "Bearer $accessToken"},
    );
  }
}
