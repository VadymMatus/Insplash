import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:insplash/feature/presentation/screens/photos_search_screen.dart';

import '../screens/photo_full_screen.dart';
import '../screens/photo_info_screen.dart';
import '../screens/photos_screen.dart';

List<GetPage> pages = [
  GetPage(
    name: '/home',
    page: () => const PhotosScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: '/search',
    page: () => const PhotosSearchScreen(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: '/photo/info',
    page: () => const PhotoInfoScreen(),
    transition: Transition.fadeIn,
    popGesture: true,
  ),
  GetPage(
    name: '/photo/full',
    page: () => PhotoFullScreen(),
    transition: Transition.fadeIn,
  )
];
