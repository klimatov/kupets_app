import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'presentation/router/app_router.dart';
import 'presentation/viewmodels/auth_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final deps = await AppDependencies.create();
  final authVm = AuthViewModel(deps.authRepository);
  await authVm.restore();

  final router = createRouter(authVm);

  runApp(
    MultiProvider(
      providers: deps.buildProviders(authVm),
      child: KupetsApp(router: router),
    ),
  );
}
