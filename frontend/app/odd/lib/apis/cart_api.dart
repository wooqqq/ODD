import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:odd/apis/api_interceptor.dart';

class CartApi {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final ApiInterceptor apiInterceptor = ApiInterceptor();

  // 장바구니 로그 전송
  Future<void> sendCartLog(
      String itemId, int count, String platform, String serviceType) async {
    final url = '$baseUrl/item/cart';
    final body = {
      "itemId": itemId,
      "count": count,
      "platform": platform,
      "serviceType": serviceType
    };

    print('장바구니 요청 body: $body');

    try {
      final response =
          await apiInterceptor.post(url, body, includeContentType: true);

      if (response.statusCode == 200) {
        print('장바구니 담기 성공: ${response.body}');
      } else {
        print('장바구니 담기 실패, Status Code: ${response.statusCode}');
        // 예외 대신 실패 메시지 처리
      }
    } catch (e) {
      print('장바구니 로그 전송 중 오류 발생: $e');
      // 오류 발생 시 처리 (앱 멈추지 않게)
    }
  }

  // 장바구니 결제
  Future<void> processPurchase(String platform, String serviceType,
      List<Map<String, dynamic>> items, int total) async {
    final url = '$baseUrl/purchase';
    final body = {
      "platform": platform,
      "serviceType": serviceType,
      "items": items,
      "total": total
    };

    print('장바구니 결제 요청 body: $body');

    try {
      final response =
          await apiInterceptor.post(url, body, includeContentType: true);

      if (response.statusCode == 200) {
        print('결제 성공: ${response.body}');
      } else {
        print('결제 실패, Status Code: ${response.statusCode}');
        // 결제 실패 시 예외 대신 오류 메시지 처리
      }
    } catch (e) {
      print('결제 처리 중 오류 발생: $e');
      // 오류 발생 시 처리 (앱 멈추지 않게)
    }
  }
}
