import '../models/item.dart';
import '../models/item_list.dart';
import '../../../apis/item_api.dart';

class ItemService {
  final ItemApi _itemApi = ItemApi();

  // 상품 리스트
  Future<ItemList> getItemList(
    String platform,
    String middle,
    String sub,
    String sort,
    String filter,
    int page,
    int pageSize,
  ) async {
    try {
      final itemList = await _itemApi.fetchItemList(
          platform, middle, sub, sort, filter, page, pageSize);

      // Null 처리 - 만약 itemList가 null이라면 기본 값으로 반환
      if (itemList == null) {
        return ItemList(
            pageNo: page,
            pageSize: pageSize,
            totalItems: 0,
            totalPages: 0,
            last: true,
            items: []);
      }

      return itemList; // 정상적인 경우 ItemList 반환
    } catch (e) {
      print('ItemService - 상품 리스트 불러오기 중 오류: $e');
      // 오류 발생 시 기본값 반환
      return ItemList(
          pageNo: page,
          pageSize: pageSize,
          totalItems: 0,
          totalPages: 0,
          last: true,
          items: []);
    }
  }

  // 상품 디테일
  Future<Item?> getItemDetail(String itemId, String platform) async {
    try {
      final json = await _itemApi.fetchItemDetail(itemId, platform);
      if (json != null) {
        return Item.fromJson(json);
      }
    } catch (e) {
      print('ItemService 오류: $e');
    }
    return null;
  }
}
