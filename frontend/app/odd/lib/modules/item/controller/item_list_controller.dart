import 'package:get/get.dart';
import '../models/item.dart';
import '../service/item_service.dart';

class ItemListController extends GetxController {
  final String platform;
  final String middle;
  final ItemService _itemService = ItemService();

  ItemListController(this.platform, this.middle);

  var items = <Item>[].obs;
  var totalItems = 0.obs;
  var isLoading = false.obs;
  var isLastPage = false.obs;
  var errorMessage = ''.obs;
  var page = 0.obs;
  final int pageSize = 20;

  var sortOption = '추천'.obs;
  var filterOption = '전체'.obs;
  var subOption = '전체'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItemList(reset: true); // 초기 로딩 시 데이터 요청
  }

  // 상품 리스트 호출
  Future<void> fetchItemList({bool reset = false}) async {
    if (isLoading.value) return;

    if (reset) {
      isLoading.value = false;
      isLastPage.value = false;
      page.value = 0;
      items.clear();
      totalItems.value = 0;
      errorMessage.value = '';
    }

    isLoading.value = true;

    try {
      final itemListResponse = await _itemService.getItemList(
        platform,
        middle,
        subOption.value,
        sortOption.value,
        filterOption.value,
        page.value,
        pageSize,
      );

      totalItems.value = itemListResponse.totalItems;

      if (itemListResponse.items.isNotEmpty) {
        items.addAll(itemListResponse.items);
        page.value++;

        isLastPage.value = itemListResponse.last ?? true;
      } else {
        isLastPage.value = true;
      }
    } catch (e) {
      errorMessage.value = '상품 리스트를 불러오는 중 오류가 발생했습니다.';
    } finally {
      isLoading.value = false;
    }
  }

  // 정렬 옵션 업데이트
  void updateSort(String sort) {
    sortOption.value = sort;
    fetchItemList(reset: true);
  }

  // 필터 옵션 업데이트
  void updateFilter(String filter) {
    filterOption.value = filter;
    fetchItemList(reset: true);
  }

  // 소분류 옵션 업데이트
  void updateSub(String sub) {
    subOption.value = sub;
    fetchItemList(reset: true);
  }
}
