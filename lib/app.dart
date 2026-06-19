import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/local_storage.dart';
import 'data/datasources/meal_remote_datasource.dart';
import 'data/datasources/menu_asset_datasource.dart';
import 'data/datasources/wiki_remote_datasource.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/cart_repository.dart';
import 'data/repositories/meal_repository.dart';
import 'data/repositories/menu_repository.dart';
import 'data/repositories/wiki_repository.dart';
import 'presentation/viewmodels/auth_view_model.dart';
import 'presentation/viewmodels/cart_view_model.dart';
import 'presentation/viewmodels/menu_view_model.dart';
import 'presentation/viewmodels/profile_view_model.dart';
import 'presentation/viewmodels/promotions_view_model.dart';

class KupetsApp extends StatelessWidget {
  const KupetsApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Купец&Ко',
      theme: AppTheme.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppDependencies {
  AppDependencies({
    required this.authRepository,
    required this.menuRepository,
    required this.promotionRepository,
    required this.cartRepository,
    required this.profileRepository,
    required this.mealRepository,
    required this.wikiRepository,
  });

  final AuthRepository authRepository;
  final MenuRepository menuRepository;
  final PromotionRepository promotionRepository;
  final CartRepository cartRepository;
  final ProfileRepository profileRepository;
  final MealRepository mealRepository;
  final WikiRepository wikiRepository;

  static Future<AppDependencies> create() async {
    final menuDs = MenuAssetDataSource();
    final promotionDs = PromotionAssetDataSource();
    final cartLocal = CartLocalDataSource();
    final profileLocal = ProfileLocalDataSource();
    await cartLocal.init();
    await profileLocal.init();

    final authRepository = HiveAuthRepository();
    await authRepository.restoreSession();

    return AppDependencies(
      authRepository: authRepository,
      menuRepository: MenuRepository(menuDs),
      promotionRepository: PromotionRepository(promotionDs),
      cartRepository: CartRepository(cartLocal),
      profileRepository: ProfileRepository(profileLocal),
      mealRepository: MealRepository(MealRemoteDataSource()),
      wikiRepository: WikiRepository(WikiRemoteDataSource()),
    );
  }

  List<SingleChildWidget> buildProviders(AuthViewModel authViewModel) => [
        ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),
        ChangeNotifierProvider(
          create: (_) => MenuViewModel(menuRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => PromotionsViewModel(promotionRepository, mealRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(
            cartRepository,
            profileRepository,
            authRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CartViewModel(cartRepository, menuRepository),
        ),
        Provider.value(value: wikiRepository),
        Provider.value(value: menuRepository),
      ];
}
