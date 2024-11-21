import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odd/constants/appcolors.dart';
import 'package:odd/modules/user/controller/login_controller.dart';
import 'package:odd/modules/common/custom_button.dart';
import 'package:odd/modules/user/screens/signup_screen.dart';
import 'package:odd/modules/common/default_layout.dart';
import 'package:odd/modules/user/widgets/inputfield.dart';
import 'package:odd/modules/user/widgets/user_layout.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return UserLayout(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.17),
                // 로고 텍스트
                const Text(
                  '우리\n동네\n단골',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'LogoFont',
                    fontWeight: FontWeight.bold,
                    fontSize: 52,
                    color: AppColors.gsPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 60),

                // 이메일 입력 필드
                InputField(
                  hintText: '이메일',
                  onChanged: (value) {
                    controller.email.value = value;
                    controller.loginErrorMessage.value = ''; // 입력 시 에러 메시지 초기화
                  },
                ),

                const SizedBox(height: 16),

                // 비밀번호 입력 필드
                InputField(
                  hintText: '비밀번호',
                  onChanged: (value) {
                    controller.password.value = value;
                    controller.loginErrorMessage.value = ''; // 입력 시 에러 메시지 초기화
                  },
                  isPassword: true,
                ),
                const SizedBox(height: 24),

                // 로그인 에러 메시지 표시
                Obx(() {
                  if (controller.loginErrorMessage.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 22.0),
                      child: Text(
                        controller.loginErrorMessage.value,
                        style: const TextStyle(color: AppColors.notice),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // CustomButton으로 로그인 버튼 대체
                CustomButton(
                  text: '로그인',
                  width: double.infinity,
                  onPressed: () {
                    if (controller.email.isNotEmpty &&
                        controller.password.isNotEmpty) {
                      controller.login();
                      // 로그인 성공 시 화면 전환 추가 가능
                    }
                  },
                ),
                const SizedBox(height: 16),

                // 회원가입 링크
                GestureDetector(
                  onTap: () {
                    // 회원가입 페이지 이동
                    Get.to(() => const SignUpScreen());
                  },
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
