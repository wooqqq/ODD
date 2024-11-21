import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class ApiInterceptor {
  final storage = GetStorage();

  // 공통 헤더 설정 (토큰 포함 / Content-Type 헤더는 필요 시 추가)
  Map<String, String> getHeaders({bool includeContentType = false}) {
    String? accessToken = storage.read('accessToken');
    final headers = {
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      if (includeContentType) 'Content-Type': 'application/json',
    };
    print("생성된 요청 헤더: $headers"); // Authorization 헤더 확인 로그
    return headers;
  }

  // POST 요청 (Content-Type 포함 여부 설정 가능)
  Future<http.Response> post(String url, Map<String, dynamic> body,
      {Map<String, dynamic>? params, bool includeContentType = false}) async {
    final uri = Uri.parse(url).replace(queryParameters: params);
    return await http.post(
      uri,
      headers: getHeaders(includeContentType: includeContentType),
      body: jsonEncode(body),
    );
  }

  // GET 요청 (Content-Type 포함 여부 설정 가능)
  Future<http.Response> get(String url,
      {Map<String, dynamic>? params, bool includeContentType = false}) async {
    final uri = Uri.parse(url).replace(queryParameters: params);
    return await http.get(
      uri,
      headers: getHeaders(includeContentType: includeContentType),
    );
  }

  // DELETE 요청 (Content-Type 포함 여부 설정 가능)
  Future<http.Response> delete(String url,
      {Map<String, dynamic>? params, bool includeContentType = false}) async {
    final uri = Uri.parse(url).replace(queryParameters: params);
    return await http.delete(
      uri,
      headers: getHeaders(includeContentType: includeContentType),
    );
  }
}
