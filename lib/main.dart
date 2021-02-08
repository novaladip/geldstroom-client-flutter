import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'app.dart';
import 'shared/common/config/config.dart';
import 'shared/common/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUp();
  runApp(App());
}

Future<void> setUp() async {
  await DotEnv().load(Env.envFile);
  configInjector(env: Env.mode);

  HydratedBloc.storage = await HydratedStorage.build();
  final oneSignal = getIt<OneSignal>();
  oneSignal.init(
    Env.oneSignalId,
    iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    },
  );

  if (Env.mode == Env.dev) {
    oneSignal.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  }

  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);
}
