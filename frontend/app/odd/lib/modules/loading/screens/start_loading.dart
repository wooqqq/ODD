import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:odd/constants/appcolors.dart';
import 'package:odd/main.dart';
import 'package:odd/modules/order/controller/order_controller.dart';
import 'package:odd/modules/point/controller/point_controller.dart';
import 'package:odd/modules/user/controller/login_controller.dart';
import 'package:odd/modules/user/screens/login_screen.dart';

class StartLoading extends StatefulWidget {
  const StartLoading({super.key});

  @override
  _StartLoadingState createState() => _StartLoadingState();
}

class _StartLoadingState extends State<StartLoading> {
  final GetStorage storage = GetStorage();
  final LoginController loginController = Get.find<LoginController>();
  final OrderController orderController = Get.find<OrderController>();
  final PointController pointController = Get.find<PointController>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await GetStorage.init(); // GetStorage 초기화 대기
    final accessToken = storage.read('accessToken');
    print("저장된 accessToken: $accessToken");

    // 토큰에 따른 화면 전환
    if (accessToken != null) {
      loginController.isLoggedIn.value = true;
      loginController.fetchUsername(); // 닉네임 불러오기
      orderController.fetchOrders();
      pointController.fetchPoint();
      if (mounted) {
        debugPrint("저장된 토큰 있음");
        Get.offAll(() => MainApp()); // 토큰이 있으면 MainApp으로 이동
      }
    } else {
      if (mounted) {
        debugPrint("저장된 토큰 없음");
        Get.offAll(() => LoginScreen()); // 토큰이 없으면 LoginScreen으로 이동
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.gsPrimary),
        ), // 로딩 중 UI
      ),
    );
  }
}
