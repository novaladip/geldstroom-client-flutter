import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'app.dart';
import 'shared/common/common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUp();
  runApp(App());
}

Future<void> setUp() async {
  await DotEnv().load(Env.envFile);
  configInjector(env: Env.mode);

  HydratedBloc.storage = await HydratedStorage.build();

  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);
}
