import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static const dev = 'development';
  static const prod = 'production';
  static const test = 'testing';

  static const mode = String.fromEnvironment('mode', defaultValue: test);
  static const envFile = mode == prod ? '.env' : '.dev.env';
  static final baseUrl = DotEnv().env['BASE_URL'];
  static final oneSignalId = DotEnv().env['ONE_SIGNAL_ID'];
  static final sentryDsn = DotEnv().env['SENTRY_DSN'];
}
