import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryButton extends StatelessWidget {
  final String text;
  final String? s3url;
  final VoidCallback onTap;

  const CategoryButton({
    Key? key,
    required this.text,
    this.s3url,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ClipOval(
                child: s3url != null && s3url!.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: s3url!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                    'assets/images/default_image.png',
                    fit: BoxFit.cover,
                    color: Colors.grey.withOpacity(0.3),
                    colorBlendMode: BlendMode.darken,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/home/category_button.png',
                    fit: BoxFit.cover,
                  ),
                )
                    : Image.asset(
                  'assets/images/home/category_button.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
