import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import './injector.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
void configInjector({String env}) {
  init(getIt, environment: env);
}
