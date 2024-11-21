import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // NumberFormat을 사용하기 위해 import 추가
import '../../../constants/appcolors.dart';
import '../controller/cart_controller.dart';

class CartPayModal {
  final CartController cartController = Get.find<CartController>();
  final NumberFormat currencyFormat = NumberFormat('#,###'); // 금액 형식 지정

  Future<void> showCartPayConfirmationDialog(
      BuildContext context, String platform, String serviceType) async {
    final int totalAmount =
        cartController.calculateSelectedType(platform, serviceType);
    final String formattedAmount = currencyFormat.format(totalAmount); // 포맷 적용

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 다른 곳을 눌러도 창이 닫히지 않게 설정
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // 모서리를 둥글게
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '결제 확인',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: "LogoFont"),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '$formattedAmount원을 결제하시겠습니까?\n결제 완료 후에는 환불이 불가합니다.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16), // 본문 스타일
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gsPrimary, // 확인 버튼 색상
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop(); // 모달 닫기
                            await cartController.processPurchase(
                                platform, serviceType); // 결제 실행
                          },
                          child: const Text(
                            '확인',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.white), // 확인 버튼 텍스트
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // 취소 버튼 색상
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // 모달 닫기
                          },
                          child: const Text(
                            '취소',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.white), // 취소 버튼 텍스트
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
