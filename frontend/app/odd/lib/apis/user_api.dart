import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserApi {
  final String? baseUrl = dotenv.env['BASE_URL']; // env 파일에서 BASE_URL 불러오기

  Future<http.Response> signUp(Map<String, String> body) {
    final url = Uri.parse('$baseUrl/api/auth/user/signup');
    return http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }
}
