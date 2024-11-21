import 'package:get/get.dart';
import '../../../constants/appcolors.dart';
import '../../../apis/home_api.dart';
import '../model/middle.dart';
import '../controller/recommend_controller.dart';

class HomeController extends GetxController {
  final HomeApi homeApi = HomeApi();
  final RecommendController recommendController =
      Get.put(RecommendController());

  var selectedPlatform = '우리동네단골'.obs;
  var primaryColor = AppColors.gsPrimary.obs;
  var secondaryColor = AppColors.gsSecondary.obs;
  var middle = <Middle>[].obs;
  var filteredMiddle = <Middle>[].obs;

  // 초기 카테고리 이름들을 설정
  var requiredCategories = <String>[];

  // 플랫폼 변경
  void changePlatform(String platform) {
    if (selectedPlatform.value != platform) {
      selectedPlatform.value = platform;

      // 플랫폼에 따라 primaryColor와 secondaryColor 변경
      switch (platform) {
        case 'GS25':
          primaryColor.value = AppColors.gsPrimary;
          secondaryColor.value = AppColors.gsSecondary;
          // GS25 카테고리
          requiredCategories = [
            '스낵',
            '도시락',
            '김밥',
            '주먹밥',
            '햄버거/샌드위치',
            '탄산음료',
            '냉동간편식품',
            '냉장간편식품',
            '면류',
            '아이스크림',
            '빵류'
          ];
          break;
        case 'GS더프레시':
          primaryColor.value = AppColors.freshPrimary;
          secondaryColor.value = AppColors.freshSecondary;
          // GS더프레시 카테고리
          requiredCategories = [
            '국산돈육',
            '국산우육',
            '해물',
            '국산과일',
            '수입과일',
            '과채',
            '면류',
            '빵류',
            '양념',
            '계육/계란',
            '생활용품',
            '맥주',
            '소주/전통주',
            '우유',
            '우유/유제품/치즈',
            '생리대/화장지',
            '채소',
            '생수/탄산수',
            '탄산음료'
          ];
          break;
        case 'wine25':
          primaryColor.value = AppColors.winePrimary;
          secondaryColor.value = AppColors.wineSecondary;
          // GS더프레시 카테고리
          requiredCategories = ['온라인주류'];
          break;
        default:
          primaryColor.value = AppColors.gsPrimary;
          secondaryColor.value = AppColors.gsSecondary;
          break;
      }

      // 추천 데이터 불러오기
      recommendController.changePlatform(platform);

      // 중분류 카테고리 데이터 불러오기
      fetchMiddle();
    }
  }

  // 중분류 호출
  Future<void> fetchMiddle() async {
    if (selectedPlatform.value == '우리동네단골') {
      return;
    }
    try {
      final fetchedMiddle = await homeApi.fetchMiddle(selectedPlatform.value);
      middle.value = fetchedMiddle;

      // 필요한 중분류만 필터링하여 저장
      filteredMiddle.value = fetchedMiddle
          .where((item) => requiredCategories.contains(item.middle))
          .toList();
    } catch (e) {
      middle.clear();
      filteredMiddle.clear();
      print('중분류 불러오기 실패: $e'); // 에러 발생 시 로그 출력
      // 실패 시 빈 리스트 또는 기본 값 처리
      filteredMiddle.value = [];
    }
  }
}
