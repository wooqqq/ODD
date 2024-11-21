import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:odd/apis/api_interceptor.dart';

class UserApi {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final ApiInterceptor apiInterceptor = ApiInterceptor();

// 회원가입 (POST)
  Future<http.Response> signUp(Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/auth/user/signup');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  // 이메일 중복체크(POST)
  Future<http.Response> emailDuplication(String email) async {
    final url = Uri.parse('$baseUrl/auth/user/duplication');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email}),
    );
  }

  // 로그인(POST)
  Future<http.Response> logIn(Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/auth/user/login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  // 로그아웃(GET)
  Future<http.Response> logOut() async {
    final url = Uri.parse('$baseUrl/auth/user/logout');
    return await http.get(
      url,
    );
  }

  // 유저 닉네임 가져오기 (GET)
  Future<http.Response> getUsername() async {
    final url = '$baseUrl/user/name';
    final response = await apiInterceptor.get(url);

    print('nickname Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    return response;
  }
}
