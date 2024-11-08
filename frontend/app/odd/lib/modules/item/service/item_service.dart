import '../models/item.dart';
import '../../../apis/item_api.dart';

class ItemService {
  final ItemApi _itemApi = ItemApi();

  // 상품 디테일
  Future<Item?> getItemDetail(int itemId) async {
    try {
      final json = await _itemApi.fetchItemDetail(itemId);
      if (json != null) {
        return Item.fromJson(json);
      }
    } catch (e) {
      print('ItemService 오류: $e');
    }
    return null;
  }
}
