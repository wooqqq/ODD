import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageCard extends StatelessWidget {
  final String? s3url;
  final double? length;
  final String defaultImg;

  const ImageCard({
    Key? key,
    this.s3url,
    this.length,
    this.defaultImg = 'assets/images/default_image.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: s3url != null && s3url!.isNotEmpty
            ? CachedNetworkImage(
          imageUrl: s3url!,
          fit: BoxFit.cover,
          width: length,
          height: length,
          placeholder: (context, url) => Image.asset(
            defaultImg,
            fit: BoxFit.cover,
            width: length,
            height: length,
            color: Colors.grey.withOpacity(0.3),
            colorBlendMode: BlendMode.darken,
          ),
          errorWidget: (context, url, error) => Image.asset(
            defaultImg,
            fit: BoxFit.cover,
            width: length,
            height: length,
          ),
        )
            : Image.asset(
          defaultImg,
          fit: BoxFit.cover,
          width: length,
          height: length,
        ),
      ),
    );
  }
}
