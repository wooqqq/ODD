import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../../apis/recommend_api.dart';
import '../../item/models/item.dart';
import '../../item/screens/item_detail_screen.dart';
import '../data/notification_storage.dart';
import '../../home/screens/recommend_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // 권한 요청
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('사용자가 권한을 허용했습니다');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('사용자가 임시 권한을 허용했습니다');
    } else {
      print('사용자가 권한을 거부했거나 수락하지 않았습니다');
    }

    // flutter_local_notifications 초기화
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/odd');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _handleNotificationClick(response.payload!);
        }
      },
    );

    // 포그라운드 메시지 수신
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("메시지 수신 (포그라운드): ${message.notification?.title}");

      // 알림 표시
      if (message.notification != null) {
        showNotification(message);
      }

      // hour 데이터 처리
      var hour = message.data['hour'];
      if (hour != null) {
        final hourStorage = HourStorage();

        try {
          // hour 저장
          hourStorage.saveHour(hour);

          // 한 시간 뒤 삭제
          Future.delayed(const Duration(hours: 1), () {
            hourStorage.removeHour();
          });

          // 저장된 hour 확인
          String? storedHour = hourStorage.loadHour();
          if (storedHour != null) {
            print('저장된 hour 데이터: $storedHour');
          }
        } catch (e) {
          print('hour 데이터를 처리하는 중 오류 발생: $e');
        }
      }
    });

    // 백그라운드에서 알림을 눌러 앱이 열릴 때 처리
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("메시지 클릭하여 앱 열림: ${message.notification?.title}");

      var platform = message.data['platform'];
      var itemId = message.data['itemId'];
      var hour = message.data['hour'];

      // 시간대 추천
      if (platform == 'GS25' && hour != null) {

        final RecommendApi recommendApi = RecommendApi();
        final timeRecJson = await recommendApi.getTimeRec();
        final timeRec =
            timeRecJson?.map((json) => Item.fromJson(json)).toList() ?? [];

        print('timeRec 데이터 로드 성공: ${timeRec.length}');

        if (timeRec.isNotEmpty) {
          Get.to(() => RecommendScreen(itemList: timeRec));
        } else {
          print('timeRec 데이터가 비어 있습니다.');
        }
        // 주기별 추천
      } else if (platform == 'GS더프레시' && itemId != null) {
        Get.to(() => ItemDetailScreen(
          itemId: itemId,
          platform: platform!,
        ));
      }
    });
  }

  // 알림 표시 함수
  static Future<void> showNotification(RemoteMessage message) async {
    if (message.notification?.title == null &&
        message.notification?.body == null) {
      print("빈 알림이므로 표시하지 않습니다.");
      return;
    }

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'Your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }

  // 알림 클릭 시 데이터 처리
  Future<void> _handleNotificationClick(String payload) async {
    try {
      final data = jsonDecode(payload);
      final String? platform = data['platform'];
      final String? hour = data['hour'];
      final String? itemId = data['itemId'];

      // 시간대 추천
      if (platform == 'GS25' && hour != null) {

        final RecommendApi recommendApi = RecommendApi();
        final timeRecJson = await recommendApi.getTimeRec();
        final timeRec =
            timeRecJson?.map((json) => Item.fromJson(json)).toList() ?? [];

        print('timeRec 데이터 로드 성공: ${timeRec.length}');

        if (timeRec.isNotEmpty) {
          Get.to(() => RecommendScreen(itemList: timeRec));
        } else {
          print('timeRec 데이터가 비어 있습니다.');
        }
        // 주기별 추천
      } else if (platform == 'GS더프레시' && itemId != null) {
        Get.to(() => ItemDetailScreen(
          itemId: itemId,
          platform: platform!,
        ));
      }
    } catch (e) {
      print("알림 클릭 데이터 처리 오류: $e");
    }
  }
}
