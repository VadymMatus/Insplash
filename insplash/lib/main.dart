import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:insplash/feature/presentation/bloc/photos_bloc/photos_list_bloc.dart';
import 'package:insplash/feature/presentation/bloc/photos_bloc/photos_list_event.dart';

import 'feature/presentation/bloc/photos_search_bloc/photos_search_bloc.dart';
import 'feature/presentation/router/app_router.dart';
import 'locator_service.dart';

void main() async {
  await init(); // init DI
  runApp(const UnsplashApp());
}

class UnsplashApp extends StatelessWidget {
  const UnsplashApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhotosListBloc>(
          create: (context) => sl<PhotosListBloc>()..add(PhotosRefreshEvent()),
        ),
        BlocProvider(
          create: (context) => sl<PhotosSearchBloc>(),
        ),
      ],
      child: GetMaterialApp(
        theme: ThemeData(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.system,
        initialRoute: '/home',
        getPages: pages,
      ),
    );
  }
}
