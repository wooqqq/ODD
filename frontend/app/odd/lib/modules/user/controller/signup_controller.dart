import 'package:get/get.dart';
import 'package:odd/modules/user/controller/login_controller.dart';
import 'package:odd/main.dart';
import 'package:odd/apis/user_api.dart';

class SignUpController extends GetxController {
  var email = ''.obs;
  var nickname = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var birthday = ''.obs;
  var selectedGender = '0'.obs; // 기본값 설정
  var selectedCategories = <String>[].obs;
  var isAgreed = false.obs;
  var isFormValid = false.obs; // 모든 필드가 올바르게 입력되었는지 확인하는 변수
  var emailDuplicationMessage = ''.obs; // 중복 확인 메시지 추가
  var isEmailChecked = false.obs; // 이메일 중복 확인 여부
  var isEmailValid = false.obs; // 이메일 형식 검증

  // 비밀번호 오류 메시지 추가
  var passwordErrorMessage = ''.obs;
  var confirmPasswordErrorMessage = ''.obs;
  var nicknameErrorMessage = ''.obs;

  final UserApi userApi = UserApi();

// 한글 카테고리와 영문 코드의 맵핑
  final Map<String, String> categoryMapping = {
    '일반식품': 'GENERAL_FOOD',
    '주류': 'ALCOHOLIC_BEVERAGES',
    '과자': 'SNACKS',
    '과일': 'FRUIT',
    '유제품': 'DAIRY',
    '일상용품': 'DAILY_NECESSITIES',
    '빙과류': 'ICE_CREAM',
    '냉장식품': 'REFRIGERATED_FOOD',
    '축산': 'MEAT',
    '채소': 'VEGETABLE',
    '수산': 'SEAFOOD',
    '조리식품': 'PREPARED_FOOD',
    '밀키트': 'MEAL_KITS',
    'freshfood': 'FRESH_FOOD',
    '음료': 'BEVERAGE',
    '간편식품': 'CONVENIENCE_FOOD',
    '뷰티': 'BEAUTY',
  };

  @override
  void onInit() {
    super.onInit();
    everAll([
      email,
      nickname,
      password,
      confirmPassword,
      birthday,
      selectedCategories,
      isAgreed,
      isEmailChecked
    ], (_) => validateForm());
  }

// 필드 초기화 메서드
  void resetFields() {
    email.value = '';
    nickname.value = '';
    password.value = '';
    confirmPassword.value = '';
    birthday.value = '';
    selectedGender.value = '0';
    selectedCategories.clear();
    isAgreed.value = false;
    isFormValid.value = false;
    emailDuplicationMessage.value = '';
    isEmailChecked.value = false;
    isEmailValid.value = false;
    passwordErrorMessage.value = '';
    confirmPasswordErrorMessage.value = '';
  }

// 이메일이 입력될 때마다 호출
  void onEmailChanged(String value) {
    email.value = value;
    // 이메일 형식이 올바른지 확인
    isEmailValid.value = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value);
    emailDuplicationMessage.value = ''; // 중복 메시지 초기화
  }

  // 닉네임 변경 시 유효성 검사 추가
  void onNicknameChanged(String value) {
    nickname.value = value;
    nicknameErrorMessage.value = (value.length >= 2 && value.length <= 20)
        ? ''
        : '닉네임은 2자 이상 20자 이하로 입력해주세요.';
    validateForm();
  }

  // 비밀번호 조건 확인
  void onPasswordChanged(String value) {
    password.value = value;
    passwordErrorMessage.value =
        password.value.length >= 8 ? '' : '비밀번호는 8자 이상이어야 합니다.';
    validateForm();
  }

  // 비밀번호 확인 일치 여부 확인
  void onConfirmPasswordChanged(String value) {
    confirmPassword.value = value;
    confirmPasswordErrorMessage.value =
        password.value == confirmPassword.value ? '' : '비밀번호가 일치하지 않습니다.';
    validateForm();
  }

  // 비밀번호 확인 로직
  bool get isPasswordConfirmed => password.value == confirmPassword.value;

  // 폼 유효성 검사 로직
  void validateForm() {
    // 모든 필드가 채워지고, 비밀번호가 일치하며, 약관에 동의한 경우에만 isFormValid를 true로 설정
    isFormValid.value = email.isNotEmpty &&
        nickname.isNotEmpty &&
        password.isNotEmpty &&
        isPasswordConfirmed &&
        birthday.isNotEmpty &&
        nicknameErrorMessage.value.isEmpty &&
        selectedCategories.isNotEmpty &&
        isAgreed.value &&
        isEmailChecked.value &&
        (selectedGender.value == "F" ||
            selectedGender.value == "M"); // 성별이 선택된 경우만 유효
  }

  // 약관 동의 상태 변경
  void toggleAgreement() {
    isAgreed.value = !isAgreed.value;
    validateForm(); // 동의 상태 변경 시 폼 유효성 검사
  }

  // 생년월일 설정
  void setBirthDay(String date) {
    birthday.value = date;
    validateForm(); // 생년월일 변경 시 폼 유효성 검사
  }

  // 선호 카테고리 설정
  void setCategory(List<String> categories) {
    selectedCategories.assignAll(categories); // 카테고리 리스트로 설정
    validateForm();
  }

  // 카테고리를 영문 코드로 변환하는 메서드 (단순 리스트 형식으로 반환)
  List<String> getMappedCategories() {
    return selectedCategories
        .map((category) => categoryMapping[category] ?? category)
        .toList();
  }

  // 회원가입 완료 후 자동 로그인 및 메인 화면으로 이동
  Future<void> completeSignUp() async {
    if (isFormValid.value) {
      final body = {
        "email": email.value,
        "password": password.value,
        "confirmPassword": confirmPassword.value,
        "nickname": nickname.value,
        "birthday": birthday.value,
        "gender": selectedGender.value,
        "favoriteCategories": getMappedCategories(),
      };

      // 요청 데이터를 출력하여 확인
      print('회원가입 요청 데이터: $body');

      try {
        final response = await userApi.signUp(body);
        if (response.statusCode == 200) {
          print('회원가입 성공');
          // 회원가입 성공 시 자동으로 로그인 시도
          await LoginController.to.login(
            emailInput: email.value,
            passwordInput: password.value,
          );
        } else {
          print("회원가입 실패: ${response.body}");
        }
      } catch (e) {
        print("회원가입 중 오류 발생: $e");
      }
    }
  }

// 이메일 중복 확인 함수
  Future<void> checkEmailDuplication() async {
    try {
      final response = await userApi.emailDuplication(email.value);
      if (response.statusCode == 200) {
        bool isAvailable = response.body == 'false'; // false면 사용 가능
        print('이메일 중복확인 체크 성공');
        emailDuplicationMessage.value =
            isAvailable ? "사용 가능한 이메일입니다." : "이미 사용중인 이메일입니다.";
        isEmailChecked.value = isAvailable; // 사용 가능할 때만 true 설정
      } else {
        print('이메일 중복확인 체크 실패');
        emailDuplicationMessage.value = "이메일 중복 확인 실패";
        isEmailChecked.value = false;
      }
    } catch (e) {
      emailDuplicationMessage.value = "오류가 발생했습니다.";
      isEmailChecked.value = false;
    }
    validateForm(); // 이메일 확인 후 폼 유효성 검사
  }
}
