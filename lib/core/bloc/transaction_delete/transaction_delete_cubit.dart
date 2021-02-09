import 'package:injectable/injectable.dart';

import '../../bloc_base/bloc_base.dart';
import '../../network/service/service.dart';

@lazySingleton
class TransactionDeleteCubit extends DeleteCubit {
  TransactionDeleteCubit(ITransactionService _service)
      : super(_service.deleteOneById);
}
