import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:odd/apis/api_interceptor.dart';

class UserApi {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final ApiInterceptor apiInterceptor = ApiInterceptor();

// 포인트 받아오기 (GET)
  Future<http.Response> getPoint() async {
    final url = '$baseUrl/point';
    final response = await apiInterceptor.get(url);

    print('point Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    return response;
  }
}
