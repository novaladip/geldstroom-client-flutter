import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
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
  await Firebase.initializeApp();

  await setUp();

  runZonedGuarded<Future<void>>(() async {
    runApp(App());
  }, (error, stackTrace) {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  });
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
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode)
  ]);
}
