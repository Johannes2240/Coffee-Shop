import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/menu/data/menu_local_datasource.dart';
import 'features/menu/data/menu_remote_datasource.dart';
import 'features/menu/models/menu_item_model.dart';
import 'features/menu/presentation/menu_detail_screen.dart';
import 'features/menu/presentation/menu_form_screen.dart';
import 'features/menu/presentation/menu_list_screen.dart';
import 'features/menu/providers/menu_provider.dart';
import 'features/menu/repository/menu_repository.dart';

void main() {
  runApp(const CoffeeShopApp());
}

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MenuProvider>(
      create: (_) => MenuProvider(
        repository: MenuRepository(
          remoteDataSource: MenuRemoteDataSource(),
          localDataSource: MenuLocalDataSource(),
        ),
      )..fetchItems(),
      child: MaterialApp.router(
        title: 'Coffee Shop Manager',
        theme: AppTheme.darkGlassTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MenuListScreen();
      },
    ),
    GoRoute(
      path: '/detail',
      builder: (BuildContext context, GoRouterState state) {
        final item = state.extra as MenuItemModel?;
        if (item == null) {
          return const _MissingScreen(
            message:
                'Select a menu item from the dashboard to view its details.',
          );
        }
        return MenuDetailScreen(item: item);
      },
    ),
    GoRoute(
      path: '/form',
      builder: (BuildContext context, GoRouterState state) {
        final item = state.extra as MenuItemModel?;
        return MenuFormScreen(item: item);
      },
    ),
  ],
);

class _MissingScreen extends StatelessWidget {
  const _MissingScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unavailable')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
