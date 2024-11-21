import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odd/constants/appcolors.dart';
import 'package:odd/modules/common/custom_button.dart';
import 'package:odd/modules/user/controller/signup_controller.dart';
import 'package:odd/modules/common/default_layout.dart';
import 'package:odd/modules/user/widgets/agree_modal.dart';
import 'package:odd/modules/user/widgets/birth_modal.dart';
import 'package:odd/modules/user/widgets/fav_category_modal.dart';
import 'package:odd/modules/user/widgets/gender_button.dart';
import 'package:odd/modules/user/widgets/inputfield.dart';
import 'package:odd/modules/user/widgets/user_layout.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController controller = Get.put(SignUpController());

  @override
  void dispose() {
    controller.resetFields(); // 화면을 떠날 때 필드를 초기화
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserLayout(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 110),
              const Text(
                '우리\n동네\n단골',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'LogoFont',
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: AppColors.gsPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 50),

              // 이메일 입력 필드 & 중복확인
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      hintText: '이메일',
                      onChanged: (value) => controller.onEmailChanged(value),
                    ),
                  ),
                  const SizedBox(width: 10), // 이메일 필드와 버튼 사이 간격
                  Obx(() => Container(
                        height: 57,
                        decoration: BoxDecoration(
                          color: controller.isEmailValid.value
                              ? AppColors.grey
                              : AppColors.lightgrey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextButton(
                          onPressed: controller.isEmailValid.value
                              ? () {
                                  controller.checkEmailDuplication();
                                }
                              : null,
                          child: const Text(
                            '중복확인',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              // 이메일 중복 확인 메시지 표시
              Obx(() {
                return controller.emailDuplicationMessage.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            controller.emailDuplicationMessage.value,
                            style: TextStyle(
                              color: controller.emailDuplicationMessage.value ==
                                      '사용 가능한 이메일입니다.'
                                  ? AppColors.accent
                                  : AppColors.notice,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              }),
              const SizedBox(height: 16),

              // 닉네임 입력 필드
              InputField(
                hintText: '닉네임',
                onChanged: (value) => controller.onNicknameChanged(value),
              ),
              Obx(() => controller.nicknameErrorMessage.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          controller.nicknameErrorMessage.value,
                          style: const TextStyle(
                            color: AppColors.notice,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 16),

              // 비밀번호 입력 필드
              InputField(
                hintText: '비밀번호 (8자 이상)',
                onChanged: controller.onPasswordChanged,
                isPassword: true,
              ),
              Obx(() => controller.passwordErrorMessage.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft, // 왼쪽 정렬 설정
                        child: Text(
                          controller.passwordErrorMessage.value,
                          style: const TextStyle(
                            color: AppColors.notice,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 16),

              // 비밀번호 확인 입력 필드
              InputField(
                hintText: '비밀번호 확인',
                onChanged: controller.onConfirmPasswordChanged,
                isPassword: true,
              ),
              Obx(() => controller.confirmPasswordErrorMessage.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft, // 왼쪽 정렬 설정
                        child: Text(
                          controller.confirmPasswordErrorMessage.value,
                          style: const TextStyle(
                            color: AppColors.notice,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 16),

              // 생년월일 입력 필드
              Obx(() => InputField(
                    hintText: controller.birthday.value.isNotEmpty
                        ? controller.birthday.value
                        : '생년월일',
                    isReadOnly: true,
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return BirthModal(
                            onDateSelected: (selectedDate) {
                              controller.setBirthDay(selectedDate);
                            },
                          );
                        },
                      );
                    },
                    onChanged: (value) {},
                  )),
              const SizedBox(height: 16),

              // 성별 선택 필드
              Obx(() => GenderButton(
                    selectedGender: controller.selectedGender.value,
                    onGenderSelected: (gender) {
                      controller.selectedGender.value = gender;
                    },
                  )),

              const SizedBox(height: 16),

              // 선호 카테고리 입력 필드
              Obx(() => InputField(
                    hintText: controller.selectedCategories.isNotEmpty
                        ? controller.selectedCategories.join(', ')
                        : '선호 카테고리',
                    isReadOnly: true,
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FavCategoryModal(
                            onCategoriesSelected: (selectedCategories) {
                              controller.setCategory(selectedCategories);
                            },
                          );
                        },
                      );
                    },
                    onChanged: (value) {},
                  )),
              const SizedBox(height: 5),

              // 이용약관 동의 체크박스
              Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.isAgreed.value,
                        onChanged: (bool? value) {
                          if (controller.isAgreed.value) {
                            controller.toggleAgreement();
                          } else {
                            AgreeModal.showAgreementDialog(context, () {
                              controller.toggleAgreement();
                            });
                          }
                        },
                        activeColor: AppColors.gsPrimary,
                      ),
                      const Expanded(
                        child: Text(
                          '(필수) 우리동네단골 서비스 이용약관에 동의합니다.',
                          style: TextStyle(color: AppColors.grey),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 10),

              // CustomButton 회원가입 버튼
              Obx(() => CustomButton(
                    text: '회원가입하기',
                    width: double.infinity,
                    isDisabled: !controller.isFormValid.value,
                    onPressed: controller.isFormValid.value
                        ? () {
                            controller.completeSignUp();
                          }
                        : null,
                  )),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
