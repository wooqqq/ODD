import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // GetStorage 가져오기
import 'package:odd/apis/notification_api.dart';
import '../models/notification.dart';

class NotificationController extends GetxController {
  final NotificationApi notificationApi = NotificationApi();
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // 알림 리스트 조회
  Future<void> fetchNotifications() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      String? accessToken = storage.read('accessToken');
      print("현재 accessToken: $accessToken");

      var result = await notificationApi.fetchNotifications();

      if (result.isEmpty) {
        errorMessage.value = '알림 리스트를 불러오는 데 실패했습니다.';
      } else {
        notifications.value = result;
      }
    } catch (e) {
      print("알림 리스트 조회 중 오류 발생: $e");
      errorMessage.value = '알림 리스트를 불러오는 데 실패했습니다.';
      notifications.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
