import 'package:Fellow4U/core/network/api_client.dart';
import 'package:Fellow4U/features/auth/data/auth_session.dart';

class ProfileService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getMe() async {
    final accessToken = await AuthSession.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      throw ApiException("You are not logged in", statusCode: 401);
    }

    final response = await _apiClient.get(
      "/api/v1/profile/me",
      headers: {"Authorization": "Bearer $accessToken"},
    );
    return response["data"] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateMe({
    String? name,
    String? bio,
    String? avatarUrl,
    String? phone,
    Map<String, dynamic>? preferences,
  }) async {
    final accessToken = await AuthSession.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      throw ApiException("You are not logged in", statusCode: 401);
    }

    final response = await _apiClient.patch(
      "/api/v1/profile/me",
      headers: {"Authorization": "Bearer $accessToken"},
      body: {
        "name": ?name,
        "bio": ?bio,
        if (avatarUrl != null && avatarUrl.isNotEmpty) "avatarUrl": avatarUrl,
        "phone": ?phone,
        "preferences": ?preferences,
      },
    );
    return response["data"] as Map<String, dynamic>;
  }
}
