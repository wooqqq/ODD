import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:odd/apis/api_interceptor.dart';

class SearchApi {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final ApiInterceptor apiInterceptor = ApiInterceptor();

  // 자동완성
  Future<List<String>> getAutocomplete(String keyword) async {
    final url = '$baseUrl/search/autocomplete?keyword=$keyword';
    final response = await apiInterceptor.get(url);

    try {
      final responseData = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(responseData);
        return data.cast<String>();
      } else {
        print('자동완성 실패 : ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('자동완성 에러발생 $e');
      return [];
    }
  }

  // 검색결과
  Future<Map<String, dynamic>> getSearchResult(
    String keyword,
    String platform,
    int page,
    int size, {
    String sort = 'string',
  }) async {
    final url =
        '$baseUrl/search/items?keyword=$keyword&platform=$platform&page=$page&size=$size&sort=%5B%22$sort%22%5D';
    final response = await apiInterceptor.get(url);

    print("검색 요청 url $url");

    try {
      final responseData = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(responseData);
        return data;
      } else {
        print('검색 요청 실패: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('검색 요청 에러발생 $e');
      return {};
    }
  }
}
