import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BlurredImage extends StatefulWidget {
  final String imageUrl;

  BlurredImage({required this.imageUrl});

  @override
  _BlurredImageState createState() => _BlurredImageState();
}

class _BlurredImageState extends State<BlurredImage> {
  late bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = true;
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
        ),
      ),
    );
  }
}
