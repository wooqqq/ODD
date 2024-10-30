import 'package:get/get.dart';

class HomeController extends GetxController {
  // 선택된 플랫폼을 저장
  var selectedPlatform = '우리동네단골'.obs;

  // 플랫폼 변경 메서드
  void changePlatform(String platform) {
    selectedPlatform.value = platform;
  }
}
