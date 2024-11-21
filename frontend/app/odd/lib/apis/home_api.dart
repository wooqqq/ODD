import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:odd/apis/api_interceptor.dart';
import '../modules/home/model/middle.dart';

class HomeApi {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final ApiInterceptor apiInterceptor = ApiInterceptor();

  // 중분류 조회
  Future<List<Middle>> fetchMiddle(String platform) async {
    final url = '$baseUrl/category/platform?platform=$platform';
    try {
      final response = await apiInterceptor.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => Middle.fromJson(json)).toList();
      } else {
        print('중분류 불러오기 실패, Status Code: ${response.statusCode}');
        return []; // 빈 리스트 반환, 실패 시
      }
    } catch (e) {
      print('중분류 조회 중 오류 발생: $e');
      return []; // 예외 발생 시 빈 리스트 반환
    }
  }
}
