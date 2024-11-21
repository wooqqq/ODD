import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:odd/apis/user_api.dart';
import 'package:odd/main.dart';
import 'package:odd/modules/order/controller/order_controller.dart';
import 'package:odd/modules/point/controller/point_controller.dart';
import 'dart:convert';

import 'package:odd/modules/user/screens/login_screen.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  var email = ''.obs;
  var password = ''.obs;
  var isLoggedIn = false.obs;
  var loginErrorMessage = ''.obs;
  var nickname = ''.obs;
  var fcmToken = ''.obs;

  final storage = GetStorage();
  final UserApi userApi = UserApi();
  final OrderController orderController = Get.find<OrderController>();
  final PointController pointController = Get.find<PointController>();


  @override
  void onInit() {
    super.onInit();
    debugPrint('login controller 진입');
    _getFcmToken();
  }

  // 닉네임 가져오는 함수
  void fetchUsername() async {
    try {
      print("닉네임 가져오기 요청 시작");
      final response = await userApi.getUsername();
      print("응답 상태 코드: ${response.statusCode}");
      print("응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        nickname.value = response.body;
        storage.write('nickname', nickname.value);
        print("닉네임 설정 완료: ${nickname.value}");
        print("스토리지에 저장된 닉네임: ${storage.read('nickname')}");
      } else {
        nickname.value = '사용자';
        print("닉네임 설정 오류: 기본 닉네임 '사용자'로 설정");
      }
    } catch (e) {
      print('닉네임 가져오기 실패: $e');
      nickname.value = '사용자';
    }
  }

  // FCM 토큰 가져오는 함수
  void _getFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    if (token != null) {
      fcmToken.value = token;
      print("FCM Token: $token");
    }
  }

  // 로그인 함수
  Future<void> login({String? emailInput, String? passwordInput}) async {
    final body = {
      "email": emailInput ?? email.value,
      "password": passwordInput ?? password.value,
      "fcmToken": fcmToken.value
    };

    print("로그인 요청 데이터: $body");

    try {
      final response = await userApi.logIn(body);
      print("응답 상태 코드: ${response.statusCode}");
      print("응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("응답 데이터 디코딩 성공: $data");

        if (data['success'] == true) {
          String accessToken = data['accessToken'];
          print("accessToken : $accessToken");

          // accessToken 저장
          storage.write('accessToken', accessToken);
          print(
              "저장된 accessToken: ${storage.read('accessToken')}");

          // 로그인 상태 업데이트
          isLoggedIn.value = true;
          print("로그인 상태 업데이트: $isLoggedIn");

          // 닉네임 가져오기
          fetchUsername();

          orderController.fetchOrders();

          pointController.fetchPoint();

          // 메인 화면으로 전환
          Get.offAll(() => MainApp());
          print("메인 화면으로 전환 완료");
        } else {
          loginErrorMessage.value = data['message'] ?? "로그인에 실패했습니다.";
          print("로그인 실패 메시지: ${loginErrorMessage.value}");
        }
      } else {
        print("응답 상태 코드: ${response.statusCode}");
        loginErrorMessage.value = "이메일 혹은 비밀번호를 다시 입력해주세요.";
      }
    } catch (e) {
      loginErrorMessage.value = "로그인 중 오류가 발생했습니다. 다시 시도해 주세요.";
      print('로그인 예외 발생: $e');
    }
  }

  // 로그아웃 함수 수정
  void logout() async {
    try {
      final response = await userApi.logOut();
      if (response.statusCode == 200) {
        // 로그아웃 성공 시
        isLoggedIn.value = false;
        storage.remove('accessToken');
        loginErrorMessage.value = '';
        Get.offAll(() => LoginScreen());
      } else {
        Get.snackbar("로그아웃 실패", "로그아웃에 실패했습니다.");
      }
    } catch (e) {
      Get.snackbar("로그아웃 오류", "로그아웃 중 오류가 발생했습니다. 다시 시도해 주세요.");
    }
  }
}
