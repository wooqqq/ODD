import 'package:flutter/material.dart';
import '../../constants/appcolors.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Widget? header;
  final Widget? bottom;

  const DefaultLayout({
    required this.child,
    this.header,
    this.bottom,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      // 상단바
      appBar: header != null
          ? PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: header,
          ),
        ),
      )
          : null,

      // body
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: child,
            ),
          ),
        ],
      ),

      // 하단바
      bottomNavigationBar: bottom != null
        ? SafeArea(
        child: bottom!
      ) : null,
    );
  }
}
