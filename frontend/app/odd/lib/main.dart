import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:odd/modules/home/controller/recommend_controller.dart';
import 'package:odd/modules/loading/screens/start_loading.dart';
import 'package:odd/modules/order/controller/order_controller.dart';
import 'package:odd/modules/point/controller/point_controller.dart';
import 'package:odd/modules/search/controller/search_record_controller.dart';
import 'package:odd/modules/search/controller/search_result_controller.dart';
import 'package:odd/modules/user/controller/login_controller.dart';
import 'firebase_options.dart';
import 'modules/cart/controller/cart_controller.dart';
import 'modules/common/navbar.dart';
import 'modules/home/controller/home_controller.dart';
import 'modules/home/controller/main_controller.dart';
import 'modules/notification/service/notification_service.dart';

final notificationService = NotificationService();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print("백그라운드 메시지 수신: ${message.notification?.title}");
  NotificationService.showNotification(message);
}

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();

  // 백그라운드 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Get.put(HomeController());
  Get.put(OrderController());
  Get.put(PointController());
  Get.put(LoginController());
  Get.put(CartController());
  Get.put(RecommendController());
  Get.put(SearchRecordController());
  Get.put(SearchResultController());
  NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'Freesentation'),
      debugShowCheckedModeBanner: false,
      home: StartLoading(),
    );
  }
}

// 메인
class MainApp extends StatelessWidget {
  final MainController controller = Get.put(MainController());

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Obx(() =>
      controller.pages[controller.selectedIndex.value] ?? Container()),
      bottomNavigationBar: Navbar(),
    );
  }
}
