import 'package:Fellow4U/core/network/api_client.dart';
import 'package:Fellow4U/features/auth/data/auth_session.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    await _apiClient.post(
      "/api/v1/auth/register",
      body: {
        "email": email,
        "password": password,
        "name": name,
      },
    );
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      "/api/v1/auth/login",
      body: {
        "email": email,
        "password": password,
        "deviceInfo": "flutter-mobile",
      },
    );

    final data = response["data"] as Map<String, dynamic>;
    await AuthSession.saveTokens(
      accessToken: data["accessToken"].toString(),
      refreshToken: data["refreshToken"].toString(),
    );

    return data["user"] as Map<String, dynamic>;
  }

  Future<void> logout() async {
    final refreshToken = await AuthSession.getRefreshToken();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await _apiClient.post(
          "/api/v1/auth/logout",
          body: {"refreshToken": refreshToken},
        );
      } on ApiException {
        // Clear local session even if server revoke fails.
      }
    }
    await AuthSession.clear();
  }
}
