import 'package:injectable/injectable.dart';

import '../../bloc_base/bloc_base.dart';
import '../../network/service/service.dart';

@lazySingleton
class ResendEmailVerificationCubit extends FormNoneCubit<String> {
  ResendEmailVerificationCubit(IAuthService service)
      : super(service.resendEmailVerification);
}
