import 'package:flutter/material.dart';
import '../../constants/appcolors.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;

  const DefaultLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: child,
      ),
    );
  }
}
