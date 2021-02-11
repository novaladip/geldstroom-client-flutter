import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../bloc_base/bloc_base.dart';
import '../../network/service/service.dart';
import '../bloc.dart';

@lazySingleton
class RequestCategoryDeleteCubit extends DeleteCubit {
  RequestCategoryDeleteCubit({
    @required IRequestCategoryService service,
    @required AuthCubit authCubit,
  }) : super(service.deleteOneById) {
    authCubit.listen(authCubitListener);
  }

  void authCubitListener(AuthState state) {
    // call clear when user logged out
    if (state is AuthStateUnauthenticated) clear();
  }
}
