import '../models/product.dart';
import '../../../apis/product_api.dart';

class ProductService {
  final ProductApi _productApi = ProductApi();

  // 상품 디테일
  Future<Product?> getProductDetail(int itemId) async {
    try {
      final json = await _productApi.fetchProductDetail(itemId);
      if (json != null) {
        return Product.fromJson(json);
      }
    } catch (e) {
      print('ProductService 오류: $e');
    }
    return null;
  }
}
