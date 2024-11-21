import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:odd/apis/api_interceptor.dart';

import '../modules/notification/data/notification_storage.dart';

class RecommendApi {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final ApiInterceptor apiInterceptor = ApiInterceptor();

  // 선호 카테고리 추천 (GS25, GS더프레시, wine25)
  Future<List<dynamic>?> getFavCategory([String? platform]) async {
    final String url = (platform != null && platform.isNotEmpty)
        ? '$baseUrl/item/fav-category?platform=$platform'
        : '$baseUrl/item/fav-category';

    try {
      final response = await apiInterceptor.get(url);

      print('선호 카테고리 응답 코드: ${response.statusCode}');
      final decodedBody = utf8.decode(response.bodyBytes);
      print('선호 카테고리 응답 body: $decodedBody');

      if (response.statusCode == 200) {
        return jsonDecode(decodedBody) as List<dynamic>;
      } else {
        print('선호 카테고리 로드 실패: 응답 상태 코드 ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('선호 카테고리 로드 중 오류 발생: $e');
      return null;
    }
  }

  // 선호 카테고리 추천 (홈)
  Future<List<dynamic>?> getFavCategoryHome([String? platform]) async {
    final url = '$baseUrl/item/fav-category/all';

    try {
      final response = await apiInterceptor.get(url);

      print('홈 선호 카테고리 응답 코드: ${response.statusCode}');
      final decodedBody = utf8.decode(response.bodyBytes);
      print('홈 선호 카테고리 응답 body: $decodedBody');

      if (response.statusCode == 200) {
        return jsonDecode(decodedBody) as List<dynamic>;
      } else {
        print('홈 선호 카테고리 로드 실패: 응답 상태 코드 ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('홈 선호 카테고리 로드 중 오류 발생: $e');
      return null;
    }
  }

  // 주기별 재구매 추천 (GS더프레시)
  Future<List<dynamic>?> getPurchaseCycle([String? platform]) async {
    final String url = (platform != null && platform.isNotEmpty)
        ? '$baseUrl/item/purchase-cycle?platform=$platform'
        : '$baseUrl/item/purchase-cycle';
    try {
      final response = await apiInterceptor.get(url);

      print('주기별 재구매 응답 코드: ${response.statusCode}');
      final decodedBody = utf8.decode(response.bodyBytes);
      print('주기별 재구매 응답 body: $decodedBody');

      if (response.statusCode == 200) {
        return jsonDecode(decodedBody) as List<dynamic>;
      } else {
        print('주기별 재구매 로드 실패: 응답 상태 코드 ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('주기별 재구매 로드 중 오류 발생: $e');
      return null;
    }
  }

  // 시간대 추천 (GS25)
  Future<List<dynamic>?> getTimeRec([String? platform]) async {
    final hourStorage = HourStorage();
    final String? hour = hourStorage.loadHour(); // 저장된 hour

    if (hour == null) {
      print('hour가 null입니다. 요청을 보내지 않습니다.');
      return null;
    }

    final String url = (platform != null && platform.isNotEmpty)
        ? '$baseUrl/item/time-rec?platform=$platform&hour=$hour'
        : '$baseUrl/item/time-rec?hour=$hour';

    try {
      final response = await apiInterceptor.get(url);

      print('시간대 추천 응답 코드: ${response.statusCode}');
      final decodedBody = utf8.decode(response.bodyBytes);
      print('시간대 추천 응답 body: $decodedBody');

      if (response.statusCode == 200) {
        return jsonDecode(decodedBody) as List<dynamic>;
      } else {
        print('시간대 추천 로드 실패: 응답 상태 코드 ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('시간대 추천 로드 중 오류 발생: $e');
      return null;
    }
  }

  // 최근 구매한 상품 (홈)
  Future<List<dynamic>?> getRecentItems(String platform) async {
    final url = '$baseUrl/item/recent-purchase?platform=$platform';
    try {
      final response = await apiInterceptor.get(url);

      print('최근 구매한 상품 응답 코드: ${response.statusCode}');
      final decodedBody = utf8.decode(response.bodyBytes);
      print('최근 구매한 상품 응답 body: $decodedBody');

      if (response.statusCode == 200) {
        return jsonDecode(decodedBody) as List<dynamic>;
      } else {
        print('최근 구매한 상품 로드 실패: 응답 상태 코드 ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('최근 구매한 상품 로드 중 오류 발생: $e');
      return null;
    }
  }
}
