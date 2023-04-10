import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insplash/feature/domain/entities/photo_entity.dart';

import '../widgets/cache_image_widget.dart';

class PhotoFullScreen extends StatelessWidget {
  final PhotoEntity photo = Get.arguments;

  PhotoFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.background.withOpacity(0.2),
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: InteractiveViewer(
        minScale: 1,
        maxScale: 10,
        child: Center(
          child: AspectRatio(
            aspectRatio: photo.width / photo.height,
            child: Hero(
              tag: photo.id,
              child: CachedImage(
                blurHash: photo.blurHash,
                imageUrl: photo.urls.regular,
                // height: MediaQuery.of(context).size.height,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
