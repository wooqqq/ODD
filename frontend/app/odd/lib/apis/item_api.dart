import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:odd/apis/api_interceptor.dart';
import '../modules/item/models/item_list.dart';
import '../modules/item/models/sub.dart';

class ItemApi {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final ApiInterceptor apiInterceptor = ApiInterceptor();

  // 서브 카테고리 조회
  Future<List<Sub>> fetchSubs(String platform, String middle) async {
    final url = '$baseUrl/category/middle?platform=$platform&middle=$middle';
    final response = await apiInterceptor.get(url);
    print('소분류 api 응답: ${response.statusCode}');

    if (response.statusCode == 200) {
      try {
        final responseData = utf8.decode(response.bodyBytes);
        print('소분류 응답: $responseData');

        final List<dynamic> data = json.decode(responseData);
        final List<Sub> subCategories =
            data.map((json) => Sub.fromJson(json)).toList();

        return subCategories;
      } catch (e) {
        print('응답 파싱 중 오류 발생: $e');
        return []; // 실패 시 빈 리스트 반환
      }
    } else {
      print('소분류 불러오기 실패, Status Code: ${response.statusCode}');
      return []; // 실패 시 빈 리스트 반환
    }
  }

  // 상품 리스트 조회
  Future<ItemList?> fetchItemList(
    String platform,
    String middle,
    String sub,
    String sort,
    String filter,
    int page,
    int size,
  ) async {
    final url =
        '$baseUrl/item?platform=$platform&middle=$middle&sub=$sub&sort=$sort&filter=$filter&page=$page&size=$size';
    print('상품 리스트 API 호출 URL: $url');

    final response = await apiInterceptor.get(url);
    if (response.statusCode == 200) {
      try {
        final responseData = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(responseData);

        print("상품 리스트 정보: $jsonResponse");

        return ItemList.fromJson(jsonResponse);
      } catch (e) {
        print("응답 파싱 실패: $e");
        return null; // 실패 시 null 반환
      }
    } else {
      print("상품 리스트 정보 응답 상태: ${response.statusCode}");
      return null; // 실패 시 null 반환
    }
  }

  // 상품 디테일 조회
  Future<Map<String, dynamic>?> fetchItemDetail(
      String itemId, String platform) async {
    final url = '$baseUrl/item/detail/$itemId/$platform';
    print('상품 디테일 API 호출 URL: $url');

    try {
      final response = await apiInterceptor.get(url);
      print('상품 디테일 응답 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = utf8.decode(response.bodyBytes);
        print('상품 디테일 응답 바디: $responseData');

        return json.decode(responseData) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        print('상품이 없습니다.');
        return null; // 404인 경우 null 반환
      } else {
        print('상품 찾기 실패, Status Code: ${response.statusCode}');
        return null; // 다른 실패인 경우 null 반환
      }
    } catch (e) {
      print('API 요청 중 오류 발생: $e');
      return null; // 실패 시 null 반환
    }
  }
}
