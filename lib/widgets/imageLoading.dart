import 'package:finale_proj/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyImageWidget extends StatelessWidget {
  final String imageUrl;
  double width;
  double hieght;

  MyImageWidget({
    required this.imageUrl,
    required this.width,
    required this.hieght
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: hieght,
      placeholder: (context, url) => ShimmerContainer(width: 200, height: 200),
      errorWidget: (context, url, error) => Icon(Icons.error),
      fit: BoxFit.cover,
    );
  }
}
