import 'package:flutter/material.dart';
import 'package:odd/modules/common/default_layout.dart';
import 'package:odd/modules/search/widgets/search_header.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      header: SearchHeader(),
      child: SizedBox.shrink(),
    );
  }
}
