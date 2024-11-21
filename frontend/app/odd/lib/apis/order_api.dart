import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:odd/apis/api_interceptor.dart';

class OrderApi {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final ApiInterceptor apiInterceptor = ApiInterceptor();

  // 구매 목록 조회 (GET)
  Future<Map<String, dynamic>> fetchPurchaseList({
    required String platform,
    String serviceType = '전체',
    required int page,
    required int size,
  }) async {
    final url =
        '$baseUrl/purchase/list?platform=$platform&serviceType=$serviceType&page=$page&size=$size';

    try {
      final response = await apiInterceptor.get(url, includeContentType: true);
      print('구매 목록 조회 API 응답 코드: ${response.statusCode}');
      print('구매 목록 응답: $response');

      if (response.statusCode == 200) {
        final responseData = utf8.decode(response.bodyBytes);
        print('구매 목록 조회 응답 데이터: $responseData');

        final Map<String, dynamic> data = json.decode(responseData);
        return data; // 정상 응답 반환
      } else {
        print('구매 목록 조회 실패, 상태 코드: ${response.statusCode}');
        return {}; // 실패 시 빈 데이터 반환
      }
    } catch (e) {
      print('구매 목록 조회 중 오류 발생: $e');
      return {}; // 오류 발생 시 빈 데이터 반환
    }
  }

  // 구매 상세 조회 (GET)
  Future<Map<String, dynamic>?> fetchPurchaseDetail(int purchaseId) async {
    final url = '$baseUrl/purchase/$purchaseId';
    try {
      final response = await apiInterceptor.get(url, includeContentType: true);
      print('구매 상세 조회 API 응답 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = utf8.decode(response.bodyBytes);
        final data = json.decode(responseData);
        print("구매 상세 조회 데이터: $data");
        return data; // 정상 응답 반환
      } else {
        print("구매 상세 조회 실패, 상태 코드: ${response.statusCode}");
        return null; // 실패 시 null 반환
      }
    } catch (e) {
      print("구매 상세 조회 중 오류 발생: $e");
      return null; // 실패 시 null 반환
    }
  }
}
