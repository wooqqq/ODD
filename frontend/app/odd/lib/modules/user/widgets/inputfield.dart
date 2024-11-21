import 'package:flutter/material.dart';
import 'package:odd/constants/appcolors.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final bool isReadOnly; // 텍스트 입력 막기 위한 읽기 전용 변수 생성
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  const InputField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.isReadOnly = false,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      readOnly: isReadOnly,
      decoration: _inputDecoration(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hintText을 입력하세요';
        }
        if (hintText == '이메일' &&
            !RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value)) {
          return '올바른 이메일을 입력하세요';
        }
        return null;
      },
      onTap: onTap,
      onChanged: onChanged,
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.lightgrey),
      ),
      filled: true,
      fillColor: AppColors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.lightgrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.gsPrimary),
      ),
    );
  }
}
