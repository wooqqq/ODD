import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odd/modules/home/screens/home_screen.dart';
import 'package:odd/modules/my/screens/my_screen.dart';
import 'package:odd/modules/search/screens/search_screen.dart';
import 'package:odd/modules/order/screens/order_screen.dart';
import 'package:odd/modules/pay/widgets/pay_modal.dart';

class MainController extends GetxController {
  RxInt selectedIndex = 0.obs;

  List<Widget?> pages = [
    HomeScreen(),
    SearchScreen(),
    null, // 결제 모달
    OrderScreen(),
    MyScreen(),
  ];

  void changeIndex(int index, BuildContext context) {
    if (index == 2) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return PayModal();
        },
      );
    } else {
      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      selectedIndex.value = index;
    }
  }
}
