import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../domain/entities/photo_entity.dart';
import '../bloc/photos_bloc/photos_list_bloc.dart';
import '../bloc/photos_bloc/photos_list_event.dart';
import '../bloc/photos_bloc/photos_list_state.dart';
import '../widgets/cache_image_widget.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void setupScrollController(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          BlocProvider.of<PhotosListBloc>(context).add(PhotosPreloadEvent());
          Timer(const Duration(milliseconds: 30), () {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          });
        }
      }
    });
  }

  Widget _buildFab() => FloatingActionButton(
        onPressed: () => Get.toNamed('/search'),
        child: const Icon(Icons.search),
      );

  Widget _buildResultMessage(IconData icon, String message) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
            ),
            const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.6),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ))
      ],
    );
  }

  Widget _buildResultLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildResultError(message) => _buildResultMessage(
      Icons.error_outline, '$message\nPull down to try again');

  Widget _buildResultEmptyList() =>
      _buildResultMessage(Icons.search, 'No photos :(');

  Widget _preloadingIndicator() {
    return const Padding(
        padding: EdgeInsets.only(top: 8), child: LinearProgressIndicator());
  }

  Widget _buildResult() {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<PhotosListBloc>(context).add(PhotosRefreshEvent());
      },
      child:
          BlocBuilder<PhotosListBloc, PhotosState>(builder: (context, state) {
        var photos = <PhotoEntity>[];
        var preload = false;
        if (state is PhotosLoadingState) {
          return _buildResultLoading();
        } else if (state is PhotosEmptyState) {
          return _buildResultEmptyList();
        } else if (state is PhotosErrorState) {
          return _buildResultError(state.message);
        } else if (state is PhotosLoadedState) {
          photos = state.photos;
          preload = state.preload;
        }

        return Column(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: photos.length,
                    itemBuilder: (BuildContext context, int index) {
                      var photo = photos[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: Ink(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    Get.toNamed('/photo/full',
                                        arguments: photo);
                                  },
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    child: Hero(
                                      tag: photo.id,
                                      flightShuttleBuilder: (
                                        BuildContext flightContext,
                                        Animation<double> animation,
                                        HeroFlightDirection flightDirection,
                                        BuildContext fromHeroContext,
                                        BuildContext toHeroContext,
                                      ) {
                                        final Hero hero = (flightDirection ==
                                                HeroFlightDirection.push
                                            ? fromHeroContext.widget
                                            : toHeroContext.widget) as Hero;
                                        return hero.child;
                                      },
                                      child: CachedImage(
                                        blurHash: photo.blurHash,
                                        imageUrl: photo.urls.regular,
                                        width: MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )),
                              InkWell(
                                onTap: () {
                                  Get.toNamed('/photo/info', arguments: photo);
                                },
                                child: ListTile(
                                  leading: Hero(
                                    tag: photo.user.id + photo.id,
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        photo.user.profileImage.medium,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    '${photo.user.name} @${photo.user.username}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      'Uploaded on ${photo.createdAt.split("T").first}',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
            if (preload) _preloadingIndicator()
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    BlocProvider.of<PhotosListBloc>(context).add(PhotosRefreshEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Insplash",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _buildResult(),
      resizeToAvoidBottomInset: true,
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
