import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:insplash/feature/domain/entities/photo_entity.dart';
import 'package:insplash/feature/presentation/bloc/photos_search_bloc/photos_search_bloc.dart';

import '../widgets/cache_image_widget.dart';

class PhotosSearchScreen extends StatefulWidget {
  const PhotosSearchScreen({super.key});

  @override
  State<PhotosSearchScreen> createState() => _PhotosSearchScreenState();
}

class _PhotosSearchScreenState extends State<PhotosSearchScreen> {
  late TextEditingController _controller;
  late FocusNode _textFieldFocusNode;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = TextEditingController();
    _textFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _textFieldFocusNode.dispose();

    super.dispose();
  }

  void setupScrollController(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          BlocProvider.of<PhotosSearchBloc>(context)
              .add(SearchPhotosPreloadEvent());
          Timer(const Duration(milliseconds: 30), () {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          });
        }
      }
    });
  }

  Widget _buildResultMessage(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
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
      ),
    );
  }

  Widget _buildResultInitialList() =>
      _buildResultMessage(Icons.image_search, "Try search for something");

  Widget _buildResultEmptyList() => _buildResultMessage(
      Icons.search, 'Nothing found for your search "${_controller.text}"');

  Widget _buildResultLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildResultError(message) =>
      _buildResultMessage(Icons.error_outline, '$message');

  Widget _buildResultList(List<PhotoEntity> photos, bool preload) {
    return Column(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: StaggeredGridView.countBuilder(
              controller: _scrollController,
              physics: const ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var photo = photos[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () async {
                        await Get.toNamed(
                          '/photo/full',
                          arguments: photo,
                        );
                      },
                      child: Hero(
                        flightShuttleBuilder: (
                          BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext,
                        ) {
                          final Hero hero =
                              (flightDirection == HeroFlightDirection.push
                                  ? fromHeroContext.widget
                                  : toHeroContext.widget) as Hero;
                          return hero.child;
                        },
                        tag: photo.id,
                        child: CachedImage(
                            blurHash: photo.blurHash,
                            imageUrl: photo.urls.regular,
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.count(2, index.isEven ? 3 : 1.5),
              shrinkWrap: true,
              itemCount: photos.length,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              crossAxisCount: 4,
            ),
          ),
        ),
        if (preload)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(),
          )
      ],
    );
  }

  Widget _buildResult() {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<PhotosSearchBloc>(context)
            .add(SearchPhotosRefreshEvent(query: _controller.text));
      },
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(child:
              BlocBuilder<PhotosSearchBloc, PhotosSearchState>(
                  builder: (context, state) {
            if (state is PhotosSearchInitialState) {
              return _buildResultInitialList();
            } else if (state is PhotosSearchEmptyState) {
              return _buildResultEmptyList();
            } else if (state is PhotosSearchLoadingState) {
              return _buildResultLoading();
            } else if (state is PhotosSearchErrorState) {
              return _buildResultError(
                  '${state.message}\nPull down to try again');
            } else if (state is PhotosSearchLoadedState) {
              return _buildResultList(state.photos, state.preload);
            }

            return _buildResultError("Something went wrong :(");
          }))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    _textFieldFocusNode.requestFocus();
    BlocProvider.of<PhotosSearchBloc>(context).add(SearchPhotosInitialEvent());

    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: TextField(
          focusNode: _textFieldFocusNode,
          controller: _controller,
          onTapOutside: (_) => _textFieldFocusNode.unfocus(),
          onEditingComplete: () {
            _textFieldFocusNode.unfocus();
            BlocProvider.of<PhotosSearchBloc>(context)
                .add(SearchPhotosEvent(query: _controller.text));
          },
          decoration: InputDecoration(
              border: const OutlineInputBorder(borderSide: BorderSide.none),
              hintText: "Type your search query...",
              suffixIconColor: Theme.of(context).colorScheme.onBackground,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  BlocProvider.of<PhotosSearchBloc>(context)
                      .add(SearchPhotosInitialEvent());
                  _textFieldFocusNode.requestFocus();
                },
              )),
        ),
      ),
      body: _buildResult(),
    );
  }
}
