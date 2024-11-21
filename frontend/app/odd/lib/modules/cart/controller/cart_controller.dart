import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:odd/apis/cart_api.dart';
import 'package:odd/modules/order/controller/order_controller.dart';
import 'package:odd/modules/point/controller/point_controller.dart';

class CartController extends GetxController {
  final box = GetStorage();
  var cartItems = <Map<String, dynamic>>[].obs;

  final CartApi cartApi = CartApi();
  final PointController pointController = Get.find<PointController>();
  final OrderController orderController = Get.find<OrderController>();

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  // 플랫폼 + 배달 방식에 따라 분류
  Map<String, Map<String, List<Map<String, dynamic>>>> get groupedCartItems {
    Map<String, Map<String, List<Map<String, dynamic>>>> groupedItems = {};

    for (var item in cartItems) {
      String platform = item['platform'] ?? 'unknown';
      String serviceType = item['serviceType'] ?? 'pickup';

      groupedItems.putIfAbsent(platform, () => {});
      groupedItems[platform]!.putIfAbsent(serviceType, () => []);
      groupedItems[platform]![serviceType]!.add(item);
    }

    print("그룹별 상품: $groupedItems");
    return groupedItems;
  }

  // 특정 플랫폼 및 배달 방식 결제 금액
  int calculateSelectedType(String platform, String serviceType) {
    final items = groupedCartItems[platform]?[serviceType] ?? [];
    return items.fold(
        0, (int sum, item) => sum + (item['price'] * item['count'] as int));
  }

  // 장바구니 추가
  void addItem(String itemId, String itemName, int price, int count,
      String serviceType, String platform, String s3url) {
    // 특정 플랫폼과 배달 방식에 따라 동일한 아이템 찾기
    final existingItemIndex = cartItems.indexWhere((item) =>
        item['itemId'] == itemId &&
        item['serviceType'] == serviceType &&
        item['platform'] == platform);

    if (existingItemIndex != -1) {
      // 기존 아이템의 수량 증가
      cartItems[existingItemIndex]['count'] += count;
    } else {
      // 새로운 아이템 추가
      final newItem = {
        'itemId': itemId,
        'itemName': itemName,
        'price': price,
        'count': count,
        'serviceType': serviceType,
        'platform': platform,
        'addedTime': DateTime.now().toString(),
        's3url': s3url
      };
      cartItems.add(newItem);
    }

    saveCart(); // 장바구니 저장
    Get.snackbar('장바구니', '$itemName이(가) 장바구니에 추가되었습니다.',
        duration: const Duration(seconds: 2));

    // 장바구니 로그 전송
    cartApi.sendCartLog(itemId, count, platform, serviceType).catchError((e) {
      print("장바구니 로그 전송 중 오류 발생: $e");
    });
  }

  // 장바구니 수량 변경
  void updateItemCount(String itemId, int newCount) {
    final index = cartItems.indexWhere((item) => item['itemId'] == itemId);
    if (index != -1) {
      cartItems[index] = {
        ...cartItems[index],
        'count': newCount,
      };
      cartItems.refresh();
      saveCart();
    }
  }

  // 장바구니 저장
  void saveCart() {
    box.write('cartItems', cartItems);
    debugPrint("장바구니 저장됨: $cartItems");
  }

  // 장바구니 로드
  void loadCart() {
    List<dynamic>? storedItems = box.read<List<dynamic>>('cartItems');
    if (storedItems != null) {
      cartItems.assignAll(
        storedItems.cast<Map<String, dynamic>>().where((item) {
          DateTime addedTime = DateTime.parse(item['addedTime']);
          return DateTime.now().difference(addedTime).inDays <
              7; // 일주일 이내 항목만 유지
        }).toList(),
      );
    }
    debugPrint("장바구니 로드됨: $cartItems");
  }

  // 장바구니 삭제
  void removeItem(String itemId) {
    cartItems.removeWhere((item) => item['itemId'] == itemId);
    saveCart();
  }

  // 장바구니 결제
  Future<void> processPurchase(String platform, String serviceType) async {
    final items = groupedCartItems[platform]?[serviceType] ?? [];
    final int totalAmountValue = calculateSelectedType(platform, serviceType);

    if (items.isEmpty) {
      Get.snackbar("결제 오류", "장바구니가 비어 있습니다.",
          duration: const Duration(seconds: 2));
      return;
    }

    // items 데이터 변환
    final List<Map<String, dynamic>> itemsData = items
        .map((item) => {"id": item["itemId"], "count": item["count"]})
        .toList();

    try {
      await cartApi.processPurchase(
        platform,
        serviceType,
        itemsData,
        totalAmountValue,
      );
      Get.snackbar("결제 성공", "결제가 완료되었습니다.",
          duration: const Duration(seconds: 2));

      // 결제 후 포인트 업데이트
      pointController.fetchPoint();

      // 해당 품목 장바구니에서 제거
      clearCart(platform, serviceType);

      // 결제 후 주문 내역 갱신
      orderController.fetchOrders(reset: true);
    } catch (e) {
      Get.snackbar("결제 실패", e.toString(), duration: const Duration(seconds: 2));
      print("결제 처리 중 오류 발생: $e");
    }
  }

  // 특정 플랫폼 및 배달 방식의 항목만 장바구니에서 제거
  void clearCart(String platform, String serviceType) {
    cartItems.removeWhere((item) =>
        item['platform'] == platform && item['serviceType'] == serviceType);
    saveCart();
  }

  @override
  void onClose() {
    super.onClose();
    saveCart();
  }

  int get totalItems => cartItems.length;
}
