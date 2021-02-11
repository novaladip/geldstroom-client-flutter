import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/request_category_delete/request_category_delete_cubit.dart';
import 'package:geldstroom/core/bloc_base/bloc_base.dart';
import 'package:geldstroom/core/network/service/request_category/request_category_service.dart';
import 'package:mockito/mockito.dart';

class MockIRequestCategoryService extends Mock
    implements IRequestCategoryService {}

void main() {
  group('RequestCategoryDelete', () {
    IRequestCategoryService service;

    setUp(() {
      service = MockIRequestCategoryService();
    });

    test('initial value', () {
      final subject = RequestCategoryDeleteCubit(service);
      expect(subject.state, DeleteState.initial());
    });
  });
}
