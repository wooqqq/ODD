import 'dart:convert';
import 'package:odd/apis/api_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../modules/notification/models/notification.dart';

class NotificationApi {
  final String? baseUrl = dotenv.env['NOTICE_URL'];
  final ApiInterceptor apiInterceptor = ApiInterceptor();

  // 알림 리스트 조회
  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final response = await apiInterceptor.get('$baseUrl/notification/list');

      // 상태 코드와 응답 바디 출력
      print("알림 리스트 응답 코드: ${response.statusCode}");
      print("알림 리스트 응답 body: ${utf8.decode(response.bodyBytes)}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));

        // success 값 체크 (필요시 사용)
        if (data['success'] == true) {
          List<dynamic> notificationsJson = data['notificationList'];
          return notificationsJson.map((json) => NotificationModel.fromJson(json)).toList();
        } else {
          print('Failed to load notifications: ${data['message']}');
          return [];
        }
      } else {
        print('Failed to load notifications: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('An error occurred while fetching notifications: $e');
      return [];
    }
  }
}
