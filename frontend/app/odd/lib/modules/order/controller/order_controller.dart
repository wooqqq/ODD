import 'package:get/get.dart';
import 'package:odd/apis/order_api.dart';
import 'package:odd/constants/appcolors.dart';

class OrderController extends GetxController {
  final OrderApi orderApi = OrderApi();

  var selectedPlatform = 'GS25'.obs;
  var primaryColor = AppColors.gsPrimary.obs;
  var secondaryColor = AppColors.gsSecondary.obs;
  var serviceType = '전체'.obs;
  var orders = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isDetailLoading = false.obs;
  var page = 0.obs;
  var isLastPage = false.obs;
  final int pageSize = 10;
  var orderDetail = {}.obs;
  var totalPurchases = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // 화면이 로드될 때 기본적으로 전체 데이터를 요청
    fetchOrders(reset: true);
  }

  // 플랫폼 변경 메서드
  void changePlatform(String platform) {
    selectedPlatform.value = platform;
    serviceType.value = '전체';

    // 플랫폼에 따른 색상 업데이트
    switch (platform) {
      case 'GS25':
        primaryColor.value = AppColors.gsPrimary;
        secondaryColor.value = AppColors.gsSecondary;
        break;
      case 'GS더프레시':
        primaryColor.value = AppColors.freshPrimary;
        secondaryColor.value = AppColors.freshSecondary;
        break;
      case 'wine25':
        primaryColor.value = AppColors.winePrimary;
        secondaryColor.value = AppColors.wineSecondary;
        break;
      default:
        primaryColor.value = AppColors.gsPrimary;
        secondaryColor.value = AppColors.gsSecondary;
    }

    print('플랫폼이 변경되었습니다: $platform');

    // 필터가 초기화된 상태에서 주문 목록 다시 가져오기
    fetchOrders(reset: true);
  }

  // 서비스 타입 변경 메서드
  void changeServiceType(String type) {
    serviceType.value = type;
    fetchOrders(reset: true);
  }

  // 주문 목록 조회 메서드
  Future<void> fetchOrders({bool reset = false}) async {
    if (isLoading.value) return;

    if (reset) {
      orders.clear();
      totalPurchases.value = 0;
      page.value = 0;
      isLastPage.value = false;
    }

    isLoading.value = true;

    try {
      print('fetchOrders 호출: 플랫폼=${selectedPlatform.value}, 서비스 타입=${serviceType.value}');
      final response = await orderApi.fetchPurchaseList(
        platform: selectedPlatform.value,
        serviceType: serviceType.value,
        page: page.value,
        size: pageSize,
      );

      if (response['purchases'] != null && response['purchases'].isNotEmpty) {
        print('응답 데이터: ${response['purchases']}');
        final List<dynamic> newOrders = response['purchases'];

        if (reset) {
          orders.value = newOrders
              .map((order) => {
            'purchaseId': order['purchaseId'],
            'platform': order['platform'],
            'serviceType': order['serviceType'],
            'totalPrice': order['totalPrice'],
            'purchaseDate': order['purchaseDate'],
            'totalCount': order['totalCount'],
            'firstProductName': order['firstProductName'],
            's3url': order['s3url'],
          })
              .toList();
        } else {
          orders.addAll(newOrders
              .map((order) => {
            'purchaseId': order['purchaseId'],
            'platform': order['platform'],
            'serviceType': order['serviceType'],
            'totalPrice': order['totalPrice'],
            'purchaseDate': order['purchaseDate'],
            'totalCount': order['totalCount'],
            'firstProductName': order['firstProductName'],
            's3url': order['s3url'],
          })
              .toList());
        }

        totalPurchases.value = response['totalPurchases'] ?? 0;
        isLastPage.value = response['last'] ?? true;
        page.value++;
      } else {
        print('주문 내역 없음');
        isLastPage.value = true;
      }
    } catch (e) {
      print('fetchOrders 실패: $e');
      Get.snackbar('오류', '주문 목록을 불러오는 중 오류가 발생했습니다.');
    } finally {
      isLoading.value = false;
      print('fetchOrders 완료: orders=${orders.length}');
    }
  }


  // 주문 상세 조회 메서드
  Future<void> fetchOrderDetail(int purchaseId) async {
    isDetailLoading.value = true;
    print("주문 상세 조회 시작 - purchaseId: $purchaseId");

    try {
      final response = await orderApi.fetchPurchaseDetail(purchaseId);

      if (response != null) {
        print("주문 상세 조회 성공: $response");
        orderDetail.value = response;
      } else {
        print("주문 상세 조회 응답이 비어있습니다.");
      }
    } catch (e) {
      print("주문 상세 조회 중 오류 발생: $e");
    } finally {
      isDetailLoading.value = false;
    }
  }
}
