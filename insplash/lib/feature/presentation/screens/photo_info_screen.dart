import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insplash/feature/domain/entities/photo_entity.dart';
import 'package:insplash/feature/presentation/widgets/cache_image_widget.dart';

class PhotoInfoScreen extends StatefulWidget {
  const PhotoInfoScreen({Key? key}) : super(key: key);

  @override
  State<PhotoInfoScreen> createState() => _PhotoInfoScreenState();
}

class _PhotoInfoScreenState extends State<PhotoInfoScreen> {
  PhotoEntity photo = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // foregroundColor: Colors.white,
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragEnd: (direction) {
          Get.back();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed('/photo/full', arguments: photo);
                },
                child: Center(
                  child: Hero(
                    tag: photo.id,
                    child: CachedImage(
                      blurHash: photo.blurHash,
                      imageUrl: photo.urls.regular,
                      // height: MediaQuery.of(context).size.height * 0.5,
                      // width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Hero(
                                tag: photo.user.id + photo.id,
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: CachedNetworkImageProvider(
                                    photo.user.profileImage.medium,
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Expanded(
                                child: Text(
                                  photo.user.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: const [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Divider(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            photo.altDescription.capitalizeFirst ?? "",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Divider(),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Center(child: Text('Likes')),
                              subtitle:
                                  Center(child: Text(photo.likes.toString())),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Center(child: Text('Dimensions')),
                              subtitle: Center(
                                  child: Text(
                                      '${photo.width.toString()} x ${photo.height.toString()}')),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
