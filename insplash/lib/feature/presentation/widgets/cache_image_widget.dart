import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width, height;

  final BoxFit fit;

  final String blurHash;

  const CachedImage(
      {Key? key,
      required this.imageUrl,
      this.width,
      this.height,
      this.blurHash = "",
      this.fit = BoxFit.fitWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: imageUrl,
        fit: fit,
        progressIndicatorBuilder: (context, string, progress) => const Center(
                child: CircularProgressIndicator(
              strokeWidth: 2,
            )),
        errorWidget: (context, url, error) =>
            const Icon(Icons.image_not_supported_outlined));
  }
}
