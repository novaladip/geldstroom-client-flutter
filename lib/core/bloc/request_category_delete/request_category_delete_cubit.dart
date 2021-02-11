import 'package:injectable/injectable.dart';

import '../../bloc_base/bloc_base.dart';
import '../../network/service/service.dart';

@lazySingleton
class RequestCategoryDeleteCubit extends DeleteCubit {
  RequestCategoryDeleteCubit(IRequestCategoryService service)
      : super(service.deleteOneById);
}
