import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:odd/apis/point_api.dart';
import 'dart:convert';

class PointController extends GetxController {
  final UserApi userApi = UserApi();

  var point = 0.obs; // 포인트 점수를 저장하는 observable 변수

  @override
  void onInit() {
    super.onInit();
    // fetchPoint(); // 컨트롤러 초기화 시 포인트 불러오기
  }

  // 포인트 가져오는 함수
  void fetchPoint() async {
    try {
      final response = await userApi.getPoint();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        point.value = data;
        print("포인트 설정 완료: ${point.value}");
      } else {
        point.value = 0; // 오류 발생 시 기본값 설정
        print("포인트 설정 오류: 기본값 0으로 설정");
      }
    } catch (e) {
      point.value = 0; // 예외 발생 시 기본값 설정
      print("포인트 가져오기 실패: $e");
    }
  }

  // 포인트 포맷팅 함수
  String get formattedPoint {
    final formatter = NumberFormat('#,###');
    return formatter.format(point.value);
  }
}
