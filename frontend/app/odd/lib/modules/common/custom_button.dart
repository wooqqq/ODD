import 'package:flutter/material.dart';
import 'package:odd/constants/appcolors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final bool isDisabled;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.backgroundColor = AppColors.darkgrey, // 기본 검정색 배경
    this.textColor = AppColors.white, // 기본 흰색 텍스트
    this.width = 200.0,
    this.height = 50.0,
    this.isDisabled = false,
    this.onPressed, // 버튼을 누를 때 실행할 함수
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onPressed, // 비활성화 상태일 때 null
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey : backgroundColor, // 비활성화 시 회색 배경
          borderRadius: BorderRadius.circular(45),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(fontSize: 17, color: textColor),
        ),
      ),
    );
  }
}
