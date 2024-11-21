import 'package:get/get.dart';
import '../models/item.dart';
import '../service/item_service.dart';

class ItemDetailController extends GetxController {
  final String itemId;
  final String platform;
  final ItemService _itemService = ItemService();

  ItemDetailController(
    this.itemId,
    this.platform
  );

  var item = Rxn<Item>();
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItemDetail();
  }

  // 상품 디테일 호출
  Future<void> fetchItemDetail() async {
    isLoading.value = true;
    try {
      final fetchedItem = await _itemService.getItemDetail(itemId, platform);
      if (fetchedItem != null) {
        item.value = fetchedItem;
      } else {
        errorMessage.value = '상품을 찾을 수 없습니다.';
      }
    } catch (e) {
      errorMessage.value = '상품을 불러오는 중 오류가 발생했습니다.';
    } finally {
      isLoading.value = false;
    }
  }
}
