import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/item_list_controller.dart';

class ScrollControllerManager extends GetxController {
  final ItemListController itemListController;
  final ScrollController scrollController = ScrollController();

  ScrollControllerManager({required this.itemListController}) {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // 스크롤의 남은 거리가 100 이하일 때 페이지네이션 요청
    if (scrollController.position.extentAfter < 100 &&
        !itemListController.isLoading.value &&
        !itemListController.isLastPage.value) {
      print("마지막 스크롤 도달, 새로운 페이지 로딩");
      itemListController.fetchItemList();
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
