import 'package:http/http.dart' as http;

import 'custom_shared_preferences.dart';

class CustomHttpClient extends http.BaseClient {
  final http.Client _httpClient = http.Client();

  final Map<String, String> defaultHeaders = {
    "Content-Type": "application/json"
  };

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    print(" send Token ");
    final String? token = await CustomSharedPreferences.get('token');

    if (token != null) {
      print("Token is not empty");
      defaultHeaders['Authorization'] = "Bearer $token";
    }
    print("Out send");
    request.headers.addAll(defaultHeaders);
    return _httpClient.send(request);
  }
}
