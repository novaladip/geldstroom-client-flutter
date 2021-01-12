import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import './injector.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configInjector({String env}) {
  getIt.init(environment: env);
}
